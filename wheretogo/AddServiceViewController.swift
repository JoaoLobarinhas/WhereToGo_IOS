//
//  AddServiceViewController.swift
//  wheretogo
//
//  Created by Aluno on 11/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming
import SkyFloatingLabelTextField
import CoreLocation
import FirebaseDatabase

class AddServiceViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var searchText: SkyFloatingLabelTextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var addButton: MDCButton!
    
    @IBOutlet weak var desc: SkyFloatingLabelTextField!
    @IBOutlet weak var contato: SkyFloatingLabelTextField!
    
    let date = Date()
    var formatter = DateFormatter()
    var dateString = ""
    var chosenMorada = ""
    
    
    var geocoder = CLGeocoder()
    var pickerData: [String] = [String]()
    var users: [User] = [User]()
    var mapUsers = Dictionary<String, User>()
    
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        self.dateString = self.formatter.string(from: date)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let containerScheme = MDCContainerScheme()
        containerScheme.colorScheme.primaryColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        addButton.applyContainedTheme(withScheme: containerScheme)
        
        searchText.placeholder = "Morada"
        searchText.tintColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        searchText.lineColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        searchText.selectedTitleColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        searchText.selectedLineColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        desc.placeholder = "Descrição"
        desc.tintColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        desc.lineColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        desc.selectedTitleColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        desc.selectedLineColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        contato.placeholder = "Contato"
        contato.tintColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        contato.lineColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        contato.selectedTitleColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        contato.selectedLineColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.mapUsers[user.nome!] = user
                self.pickerData.append(user.nome!)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchMorada(_ sender: Any) {
        let aux:String = searchText.text!
        searchText.resignFirstResponder()
        geocoder.geocodeAddressString(aux){
            (placemarks, error) in
            self.processResponse(withPlacemarks: placemarks, error: error, text: aux)
        }
    }
    
    @IBAction func addServico(_ sender: Any) {
        var id:String = Database.database().reference().child("servico").childByAutoId().key!
        let selected = pickerView.selectedRow(inComponent: 0)
        let user = self.pickerData[selected]
        
        let new_tecnico = [
            "email" : self.mapUsers[user]?.email,
            "id": self.mapUsers[user]?.id,
            "nome": self.mapUsers[user]?.nome,
            "profile": self.mapUsers[user]?.profile,
            "tipo": self.mapUsers[user]?.tipo,
            "coordenadas": self.mapUsers[user]?.coordenadas as Any
            ] as [String : Any]
        
        let coordenadas = [
            "latitude": self.latitude,
            "longitude": self.longitude
        ]
        
        let new_servico = [
            "id": id,
            "contato": self.contato.text,
            "data": self.dateString,
            "estado": "Pendente_por_aceitar",
            "descricao": desc.text,
            "morada": self.chosenMorada,
            "tecnico": new_tecnico,
            "tipo": "Serviço externo",
            "coordenadas": coordenadas
            ] as [String : Any]
        
        
        Database.database().reference().child("servico").child(id).setValue(new_servico)
        
        self.pickerView.selectRow(0, inComponent: 0, animated: true)
        self.contato.text = ""
        self.searchText.text = ""
        self.desc.text = ""
        
        
        let alert = UIAlertController(title: "Serviço adicionado", message: "Adicionado!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
 
    }
    
    func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?, text: String){
        if let error = error {
            print("Unable to fetch the request "+error.localizedDescription)
            print("Nao consegui encontrar")
        }
        else{
            var location:CLLocation?
            var city:String
            
            if let placemarks = placemarks, placemarks.count>0 {
                location = placemarks.first?.location
                city = (placemarks.first?.locality)!
                self.chosenMorada = text + ", " + city
                if let location = location{
                    let coordinate = location.coordinate
                    let latAux = NSNumber(value: (coordinate.latitude) as Double)
                    let lngAux = NSNumber(value: (coordinate.longitude) as Double)
                    
                    self.latitude = Double(latAux)
                    self.longitude = Double(lngAux)
                    let alert = UIAlertController(title: "Confirmar morada", message: "Deseja selecionar a morada " + text + ", " + city, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Nao", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true)
                }
                    
                else{
                    print("Nada")
                }
            }
            
        }
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
