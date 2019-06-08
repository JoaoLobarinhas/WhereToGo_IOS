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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getServicesFirebase()
        
    }
    
    func getServicesFirebase(){
        
        let dates = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: dates)
        let dateF = String(components.day!)+"-"+String(components.month!)+"-"+String(components.year!)
        
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: dateF).observe(.childAdded, with: { (snapshot) in

            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                print(dictionary["tecnico"]?["id"] as! String)
                let servico = ServiceFirebase(dictionary: dictionary)
                
               if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged{
                    print("Estou aqui")
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
