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
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        
        
        self.ref?.child("servico").queryOrdered(byChild: "tecnico").queryEqual(toValue: Auxiliar.userLoged).observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let data:String = dictionary["data"] as! String
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                let dataAux = dateFormatter.date(from:data)!
                let date = Date()
                print(dataAux)
                print(date)
                
                if dataAux >= date {
                    let contato:String = dictionary["contato"] as! String
                    
                    let descricao:String = dictionary["descricao"] as! String
                    let estado:String = dictionary["estado"] as! String
                    let id:String = dictionary["id"] as! String
                    let morada:String = dictionary["morada"] as! String
                    let tecnico:String = dictionary["tecnico"] as! String
                    let tipo:String = dictionary["tipo"] as! String
                    
                    let latitude:NSNumber = dictionary["coordenadas"]!["latitude"] as! NSNumber
                    let longitude:NSNumber = dictionary["coordenadas"]!["longitude"] as! NSNumber
                    
                    print(dictionary)
                    
                    let service:Service = Service(id: id, contato: contato , data: data, descricao: descricao, estado: estado, morada: morada, tecnico: tecnico, tipo: tipo, coordenadas: Coordenadas(latitude: latitude.floatValue, longitude: longitude.floatValue ));
                    
                    self.arrayServices.append(service)
                    
                    self.tableView.reloadData()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TecnicoTableViewCell
        let ec:Service = arrayServices[indexPath.row]
        cell.labelData.text = ec.data;
        cell.labelMorada.text = ec.morada;
        cell.labelEstado.text = ec.estado;
        cell.labelServico.text = ec.descricao;
        cell.imageEstado.image = UIImage(named: "map_blue");
        return cell;
    }
}
