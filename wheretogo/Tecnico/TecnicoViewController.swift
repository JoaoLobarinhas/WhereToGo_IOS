//
//  TecnicoViewController.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 29/05/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase

class TecnicoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var arrayServices = [Service]()
    
    var services = [ServiceFirebase]()
    
    var dateF:String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dates = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: dates)
        dateF = String(components.day!)+"-"+String(components.month!)+"-"+String(components.year!)
        
        getServicesFirebase()
        updateServicos()
    }
    
    func getServicesFirebase(){
        
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: dateF).observe(.childAdded, with: { (snapshot) in

            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                print(dictionary["tecnico"]?["id"] as! String)
                
                if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged{
                
                    let servico = ServiceFirebase(dictionary: dictionary)
                    self.services.append(servico)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }

                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func updateServicos(){
        Database.database().reference().child("servico").queryOrdered(byChild: "data").observe(.childChanged, with: { (snapshot)
            in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                print(dictionary)
                
                if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged{
                    
                    let servicoUpdated = ServiceFirebase(dictionary: dictionary)
                    
                    for i in 0..<self.services.count{
                        if self.services[i].id == servicoUpdated.id{
                            if servicoUpdated.data as! String == self.dateF as! String{
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
        return cell;
    }
}
