//
//  MapViewController.swift
//  wheretogo
//
//  Created by Aluno on 10/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import MaterialComponents.MaterialButtons
import Firebase
import FirebaseDatabase

class MapViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    

    
    let date = Date()
    var formatter = DateFormatter()
    var map_view = GMSMapView()
    
    var pickerData: [String] = [String]()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var mapUsers = Dictionary<String, Array<ServiceFirebase>>()
    var services: Array<ServiceFirebase> = Array<ServiceFirebase>()
    var coordenadas:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.dataSource = self
        
        let camera = GMSCameraPosition.camera(withLatitude: 41.701497, longitude: -8.834756, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        self.map_view = mapView
        
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let todayString = self.formatter.string(from: date)
        getAllServices(todayDate: todayString)
        
        
        //drawRoute(map: mapView)
        
        let button = MDCButton()
        let width = UIScreen.main.bounds.size.width/2
        let x = UIScreen.main.bounds.size.width/2 - width/2
        let y = (self.tabBarController?.tabBar.frame.height)! + 20;
        
        
        button.frame = CGRect(x: x, y: y , width: width, height: 30)
        button.setTitle("Filtrar técnico", for: UIControlState.normal)
        button.setImage(UIImage(named: "filter"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: -20)
        
        button.isUppercaseTitle = false;
        let containerScheme = MDCContainerScheme()
        containerScheme.colorScheme.primaryColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        button.applyContainedTheme(withScheme: containerScheme)
        button.addTarget(self, action: #selector(filtrar(sender:)), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    
    @objc func filtrar(sender: MDCButton){
        
        self.pickerData.removeAll()
        
        for(key, values) in self.mapUsers{
            self.pickerData.append(key)
        }
        
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
            let user = self.pickerData[selected]
        
            self.services = self.mapUsers[user]!
            var coordenadasString = ""
            for s in self.services {
                var latitude = s.coordenadas?.value(forKey: "latitude") as? NSNumber
                var longitude = s.coordenadas?.value(forKey: "longitude") as? NSNumber
                coordenadasString += (latitude?.stringValue)!
                coordenadasString += ","
                coordenadasString += (longitude?.stringValue)!
                coordenadasString += "|"
            }
            
            self.coordenadas = coordenadasString
            
            self.drawRoute()
            
        })
        
        editRadiusAlert.addAction(OKAction)
        editRadiusAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    func getAllServices(todayDate : String){
        
        
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: todayDate).observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let servico = ServiceFirebase(dictionary: dictionary)
                let user = dictionary["tecnico"]?["nome"] as! String
                
                if var arr = self.mapUsers[user] {
                    arr.append(servico)
                    self.mapUsers[user] = arr
                }else{
                    self.mapUsers[user] = [servico]
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    

    func drawRoute(){
        let origin = "\(41.697607),\(-8.849940)"
        let destination = "\(41.695732),\(-8.849264)"
        
        var newUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=41.697131,-8.835841&destination=41.697412,-8.841945&waypoints=optimize:true|"
            + self.coordenadas! +
        "&key=AIzaSyAOEfIHh-VYr8V73LmBo_ubiQrOeMdgPaE"
        
        self.map_view.clear()
        let url = URL(string: newUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)

        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            
            if(error != nil){
                print("ERRO")
                print(error?.localizedDescription)
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let dictionaryMain = json as? [String: AnyObject] {
                    
                    if let arrayRoutes = dictionaryMain["routes"] as? [Any] {
                        
                        if let routeDictionary = arrayRoutes[0] as? [String: AnyObject] {
                            let points = routeDictionary["overview_polyline"]!["points"] as? String
                            
                            DispatchQueue.main.async {
                               
                                let path = GMSPath.init(fromEncodedPath: points!)
                                
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
                                polyline.strokeWidth = 5.0
                                polyline.map = self.map_view
                            }
                            
                        }
                        
                    }
                    
                    
                }
            }catch let parsingError {
                print("ERRO")
                print(parsingError)
            }
        }.resume()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
