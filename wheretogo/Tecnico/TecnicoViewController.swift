//
//  TecnicoViewController.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 29/05/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MaterialComponents.MaterialButtons

class TecnicoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var services = [ServiceFirebase]()
    
    var dateF:String?
    
    var serviceClicker:Int = 0
    
    let date = Date()
    var formatter = DateFormatter()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dates = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: dates)
        dateF = String(components.day!)+"-"+String(components.month!)+"-"+String(components.year!)
        
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let todayString = self.formatter.string(from: date)
        
        getServicesFirebase(todayDate: todayString)
        updateServicos(todayDate: todayString)
    }
    
    func getServicesFirebase(todayDate : String){
        
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: todayDate).observe(.childAdded, with: { (snapshot) in

            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged{
                
                    let servico = ServiceFirebase(dictionary: dictionary)
                    
                    if(dictionary["estado"] as! String == "Pendente" || dictionary["estado"] as! String == "Aceite"){
                        self.services.append(servico)
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func updateServicos(todayDate : String){
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: todayDate).observe(.childChanged, with: { (snapshot)
            in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                print(dictionary)
                
                if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged{
                    
                    let servicoUpdated = ServiceFirebase(dictionary: dictionary)
                    
                    for i in 0..<self.services.count{
                        if self.services[i].id == servicoUpdated.id{
                            if(servicoUpdated.estado! as! String == "Pendente" || servicoUpdated.estado! as! String == "Aceite"){
                                self.services[i] = servicoUpdated
                                break
                            }
                            else{
                                self.services.remove(at: i)
                                break
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                }
                
            }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TecnicoTableViewCell
        let ec:ServiceFirebase = services[indexPath.row]
        cell.labelData.text = ec.data;
        cell.labelMorada.text = ec.morada;
        cell.labelEstado.text = ec.estado;
        cell.labelServico.text = ec.descricao;
        cell.imageEstado.image = UIImage(named: "map_blue");
        
        if cell.labelEstado.text == "Pendente"{
            
            cell.btnConcluido.setTitle("Aceitar", for: .normal)
            cell.btnConcluido.addTarget(self, action: #selector(aceitarSerivco(sender:)), for: .touchUpInside)
            cell.btnConcluido.tag = indexPath.row
            
            cell.btnCancelar.setTitle("Recusar", for: .normal)
            cell.btnCancelar.addTarget(self, action: #selector(recusarServico(sender:)), for: .touchUpInside)
            cell.btnCancelar.tag = indexPath.row
            
        }
        else if cell.labelEstado.text == "Aceite"{
            
            cell.btnConcluido.setTitle("Concluir", for: .normal)
            cell.btnConcluido.addTarget(self, action: #selector(concluirServico(sender:)), for: .touchUpInside)
            cell.btnConcluido.tag = indexPath.row
            
            cell.btnCancelar.setTitle("Cancelar", for: .normal)
            cell.btnCancelar.addTarget(self, action: #selector(cancelarServico(sender:)), for: .touchUpInside)
            cell.btnCancelar.tag = indexPath.row
            
        }
        
        return cell;
    }
    
    @objc func recusarServico(sender: MDCButton){
        let serviceCanceled = services[sender.tag].id
        
        let alert = UIAlertController(title: "Confirmação", message: "Quer mesmo recusar o serivco?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {
            (_)in
            Database.database().reference().child("servico").child(serviceCanceled!).updateChildValues(["estado":"Recusado"])
        })
        alert.addAction(OKAction)
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func aceitarSerivco(sender: MDCButton){
        let serviceAccepted = services[sender.tag].id
        
        Database.database().reference().child("servico").child(serviceAccepted!).updateChildValues(["estado":"Aceite"])
    }
    
    @objc func cancelarServico(sender: MDCButton){
        let serviceCanceled = services[sender.tag].id
        
        let alert = UIAlertController(title: "Confirmação", message: "Quer mesmo cancelar o serivco?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {
            (_)in
            Database.database().reference().child("servico").child(serviceCanceled!).updateChildValues(["estado":"Cancelado"])
        })
        alert.addAction(OKAction)
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func concluirServico(sender: MDCButton){
        let serviceCanceled = services[sender.tag].id
        
        let alert = UIAlertController(title: "Confirmação", message: "Concluio o serviço?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {
            (_)in
            Database.database().reference().child("servico").child(serviceCanceled!).updateChildValues(["estado":"Concluido"])
        })
        alert.addAction(OKAction)
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
