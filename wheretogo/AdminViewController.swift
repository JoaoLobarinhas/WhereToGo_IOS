//
//  AdminViewController.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 29/05/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//
import UIKit

class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrayEntities = [Service]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let service:Service = Service(id: "1", contato: "aaa" , data: "9999", descricao: "Cena", estado: "Pendente", morada: "Viana", tecnico: "Paulo Mendes", tipo: "Reparacao", coordenadas: Coordenadas(latitude: 1.2, longitude: 2.2) )
        
        arrayEntities.append(service)
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ServicesAdminTableViewCell
        let ec:Service = arrayEntities[indexPath.row]
        cell.labelData.text = ec.data;
        cell.labelMorada.text = ec.morada;
        cell.labelEstado.text = ec.estado;
        cell.labelDesc.text = ec.descricao;
        cell.imageUser.image = UIImage(named: "map_blue");
        return cell;
    }
}


