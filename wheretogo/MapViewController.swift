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
    
    var latitudeUser = 0.0
    var longitudeUser = 0.0
    
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
        updateService(todayDate: todayString)
        
        
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
            var coordenadasUser = self.services.first?.tecnico?.value(forKey: "coordenadas") as? NSObject
            self.latitudeUser = coordenadasUser?.value(forKey: "latitude") as! Double
            self.longitudeUser = coordenadasUser?.value(forKey: "longitude") as! Double
            
            self.map_view.clear()
            var coordenadasString = ""
            for s in self.services {
                var latitude = s.coordenadas?.value(forKey: "latitude") as? NSNumber
                var longitude = s.coordenadas?.value(forKey: "longitude") as? NSNumber
                coordenadasString += (latitude?.stringValue)!
                coordenadasString += ","
                coordenadasString += (longitude?.stringValue)!
                coordenadasString += "|"
                
                var lat = s.coordenadas?.value(forKey: "latitude") as! Double
                var lng = s.coordenadas?.value(forKey: "longitude") as! Double
                
                let markerIntermedio = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                markerIntermedio.title = "Serviço " + s.estado!
                
                if(s.estado == "Concluido"){
                    markerIntermedio.icon = GMSMarker.markerImage(with: UIColor.init(red: 135/255, green: 211/255, blue: 124/255, alpha: 1))
                }else{
                    markerIntermedio.icon = GMSMarker.markerImage(with: UIColor.init(red: 245/255, green: 171/255, blue: 53/255, alpha: 1))
                }
                
                markerIntermedio.map = self.map_view
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
    
    func updateService(todayDate : String){
        
        
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: todayDate).observe(.childChanged, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let servico = ServiceFirebase(dictionary: dictionary)
                let user = dictionary["tecnico"]?["nome"] as! String
                var position = -1
                
                if var arr = self.mapUsers[user] {
                    
                    
                    for i in 0..<arr.count{
                        if(arr[i].id == servico.id){
                            position = i
                        }
                    }
                    
                    if(position != -1){
                        arr[position] = servico
                    }else{
                        arr.append(servico)
                    }
                    
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
        let destination = "\(41.695732),\(-8.849264)"
        let origin = "\(self.latitudeUser),\(self.longitudeUser)"
        var newUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&waypoints=optimize:true|"
            + self.coordenadas! +
        "&key=AIzaSyAOEfIHh-VYr8V73LmBo_ubiQrOeMdgPaE"
        
        
        let url = URL(string: newUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        
        let markerOrigem = GMSMarker(position: CLLocationCoordinate2D(latitude: self.latitudeUser, longitude: self.longitudeUser))
        markerOrigem.title = "Origem"
        markerOrigem.map = self.map_view
        
        let markerDestino = GMSMarker(position: CLLocationCoordinate2D(latitude: 41.695732, longitude: -8.849264))
        markerDestino.title = "Destino"
        markerDestino.map = self.map_view

        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            
            if(error != nil){
                let alert = UIAlertController(title: "Erro", message: error?.localizedDescription, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                
                return
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
                let alert = UIAlertController(title: "Erro", message: parsingError as! String, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                self.present(alert, animated: true)
                
                return
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
