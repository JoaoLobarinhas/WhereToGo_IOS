//
//  AdminViewController.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 29/05/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import MaterialComponents.MaterialButtons

class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var pickerData: [String] = [String]()
    var user = [User]()
    var serviceClicked:Int = 0
    var arrayServices = [Service]()
    
    var services = [ServiceFirebase]()
    
    var ourGrey: UIColor = UIColor.init(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    var ourBlue: UIColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
    
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    let date = Date()
    var formatter = DateFormatter()
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func getServicos(todayDate : String){
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: todayDate).observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let servico = ServiceFirebase(dictionary: dictionary)
                
                
                let dateString = servico.data;
                let date = self.formatter.date(from: dateString!);
                
                self.services.append(servico)
                
            
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false;
        
        self.picker.delegate = self
        self.picker.dataSource = self
        
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let todayString = self.formatter.string(from: date)
        
        
        
        
        getServicos(todayDate: todayString)
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.user.append(user)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        Database.database().reference().child("servico").observe(.childChanged, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                

                let servicoUpdated = ServiceFirebase(dictionary: dictionary)
                
                
                for i in 0..<self.services.count {
                    if(self.services[i].id == servicoUpdated.id){
                        self.services[i] = servicoUpdated
                        break
                    }
                }
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicesAdminTableViewCell
        let ec:ServiceFirebase = services[indexPath.row]
        cell.labelData.text = ec.data;
        cell.labelMorada.text = ec.morada;
        if(ec.estado == "Pendente_por_aceitar"){
            cell.labelEstado.text = "Por aceitar";
        }else{
            cell.labelEstado.text = ec.estado
        }
        cell.labelDesc.text = ec.descricao;
        cell.imageUser.image = UIImage(named: "user")
        
        
        if let profileImageUrl:String = ec.tecnico?.value(forKey: "profile") as? String {
            cell.imageUser.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        if(cell.labelEstado.text == "Concluido" || cell.labelEstado.text == "Cancelado" ){
            cell.btnRealocar.isEnabled = false
            cell.btnCancelar.isEnabled = false
            cell.btnCancelar.setBorderColor(ourGrey, for: .normal)
        } else {
            cell.btnRealocar.isEnabled = true
            cell.btnCancelar.isEnabled = true
            cell.btnCancelar.setBorderColor(ourBlue, for: .normal)
        }
        
        cell.btnRealocar.addTarget(self, action: #selector(realocar(sender:)), for: .touchUpInside)
        cell.btnRealocar.tag = indexPath.row
        
        
        cell.btnCancelar.addTarget(self, action: #selector(cancelar(sender:)), for: .touchUpInside)
        cell.btnCancelar.tag = indexPath.row
        
        return cell;
    }
    
    @objc func realocar(sender: MDCButton){
        self.pickerData.removeAll()
        self.serviceClicked = sender.tag
        
        
        for user in user {
            if(user.id != services[serviceClicked].tecnico?.value(forKey: "id") as? String){
                pickerData.append(user.nome!)
            }
        }
        
        /*picker = UIPickerView.init()
        picker.delegate = self
        picker.autoresizingMask = .flexibleWidth
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: 0.0,  width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: 60, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)*/
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Escolha o técnico", message: "", preferredStyle: UIAlertControllerStyle.alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        
        let OKAction = UIAlertAction(title: "Confirmar", style: UIAlertActionStyle.default, handler: {
            (_)in
            let selected = pickerView.selectedRow(inComponent: 0)
            
            var userClicked: User!
            
            for u in self.user {
                if(u.nome == self.pickerData[selected]){
                    userClicked = u
                    break
                }
            }
            
            let serviceSelected = self.services[self.serviceClicked].id
            
            let new_tecnico = [
                "email" : userClicked.email,
                "id": userClicked.id,
                "nome": userClicked.nome,
                "profile": userClicked.profile,
                "tipo": userClicked.tipo,
                "coordenadas": userClicked.coordenadas as Any
                ] as [String : Any]
            
            
            Database.database().reference().child("servico").child(serviceSelected!).updateChildValues(["tecnico": new_tecnico], withCompletionBlock: {error, ref in
                if error != nil{
                    print("ERROR")
                }else{
                    //self.getUsers()
                }
            } )
            
        })
        
        editRadiusAlert.addAction(OKAction)
        editRadiusAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    @objc func cancelar(sender: MDCButton){
        self.serviceClicked = sender.tag
        let serviceSelected = services[serviceClicked].id
        Database.database().reference().child("servico").child(serviceSelected!).updateChildValues(["estado": "Cancelado"])
    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        let selected = picker.selectedRow(inComponent: 0)
        
        var userClicked: User!
        
        for u in user {
            if(u.nome == self.pickerData[selected]){
                userClicked = u
                break
            }
        }
        
        let serviceSelected = services[serviceClicked].id
        
        let new_tecnico = [
            "email" : userClicked.email,
            "id": userClicked.id,
            "nome": userClicked.nome,
            "profile": userClicked.profile,
            "tipo": userClicked.tipo,
            "coordenadas": userClicked.coordenadas as Any
            ] as [String : Any]
    
        
        Database.database().reference().child("servico").child(serviceSelected!).updateChildValues(["tecnico": new_tecnico], withCompletionBlock: {error, ref in
            if error != nil{
                print("ERROR")
            }else{
                //self.getUsers()
            }
        } )
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
}


