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

class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrayServices = [Service]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        /*self.ref?.child("servico").observe(DataEventType.value, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let contato = dictionary["contato"] as? String;
                let data = dictionary["data"] as? String;
                let descricao = dictionary["descricao"] as? String;
                let estado = dictionary["estado"] as? String;
                let id = dictionary["id"] as? String;
                let morada = dictionary["morada"] as? String;
                let tecnico = dictionary["tecnico"] as? String;
                let tipo = dictionary["tipo"] as? String;
                let coord = dictionary["coordenadas"] as? NSObject
                
                print(contato)
                print(data)
                print(descricao)
                print(estado)
                print(id)
                print(morada)
                print(tecnico)
                print(tipo)
                print(coord)
                
                /*let service:Service = Service(id: id!, contato: contato! , data: data!, descricao: descricao!, estado: estado!, morada: morada!, tecnico: tecnico!, tipo: tipo!, coordenadas: Coordenadas(latitude: coord?.value(forKey: "latitude") as! Float, longitude: coord?.value(forKey: "longitude") as! Float) )*/
                
                //self.arrayServices.append(service)
                
                //self.tableView.reloadData()
                
                print("entrei")
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }*/
        
        self.ref?.child("servico").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let contato:String = dictionary["contato"] as! String
                let data:String = dictionary["data"] as! String
                let descricao:String = dictionary["descricao"] as! String
                let estado:String = dictionary["estado"] as! String
                let id:String = dictionary["id"] as! String
                let morada:String = dictionary["morada"] as! String
                let tecnico:String = dictionary["tecnico"] as! String
                let tipo:String = dictionary["tipo"] as! String
                
                let latitude:NSNumber = dictionary["coordenadas"]!["latitude"] as! NSNumber
                let longitude:NSNumber = dictionary["coordenadas"]!["longitude"] as! NSNumber
                
                let service:Service = Service(id: id, contato: contato , data: data, descricao: descricao, estado: estado, morada: morada, tecnico: tecnico, tipo: tipo, coordenadas: Coordenadas(latitude: latitude.floatValue, longitude: longitude.floatValue ));
                
                self.arrayServices.append(service)
                
                self.tableView.reloadData()
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicesAdminTableViewCell
        let ec:Service = arrayServices[indexPath.row]
        cell.labelData.text = ec.data;
        cell.labelMorada.text = ec.morada;
        cell.labelEstado.text = ec.estado;
        cell.labelDesc.text = ec.descricao;
        cell.imageUser.image = UIImage(named: "map_blue");
        return cell;
    }
}


