//
//  TecnicoMapaViewController.swift
//  wheretogo
//
//  Created by Lobarinhas on 11/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GoogleMaps

class TecnicoMapaViewController: UIViewController{
    
    var services:[ServiceFirebase] = [ServiceFirebase]()
    
    let date = Date()
    var formatter = DateFormatter()
    
    var map_view = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: (Auxiliar.userLat.toDouble())!, longitude: (Auxiliar.userLng.toDouble())!, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        self.map_view = mapView
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:(Auxiliar.userLat.toDouble())!, longitude: (Auxiliar.userLng.toDouble())!))
        marker.title = "Utilizador"
        marker.map = self.map_view
        
        formatter.dateFormat = "dd-MM-yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let todayString = self.formatter.string(from: date)
        getServicesTecnico(todayDate: todayString)
        updateServicos(todayDate: todayString)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getServicesTecnico(todayDate : String){
        
        
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: todayDate).observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged{
                    
                    let servico = ServiceFirebase(dictionary: dictionary)
                    
                    if(dictionary["estado"] as! String == "Pendente" || dictionary["estado"] as! String == "Concluido"){
                        self.services.append(servico)
                        
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.drawRoute()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func updateServicos(todayDate : String){
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryEqual(toValue: todayDate).observe(.childChanged, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged{
                    
                    let servicoUpdated = ServiceFirebase(dictionary: dictionary)
                    
                    
                    
                    for i in 0..<self.services.count{
                        if self.services[i].id == servicoUpdated.id{
                            if(servicoUpdated.estado! as! String == "Pendente" || servicoUpdated.estado! as! String == "Concluido"){
                                self.services[i] = servicoUpdated
                                break
                            }
                            else{
                                self.services.remove(at: i)
                                break
                            }
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.drawRoute()
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func drawRoute(){
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
        
        
        let destination = "\(41.695732),\(-8.849264)"
        let origin = "\(Auxiliar.userLat.toDouble()!),\(Auxiliar.userLng.toDouble()!)"
        var newUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&waypoints=optimize:true|"
            + coordenadasString +
        "&key=AIzaSyAOEfIHh-VYr8V73LmBo_ubiQrOeMdgPaE"
        
        
        let url = URL(string: newUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        
        
        let markerOrigem = GMSMarker(position: CLLocationCoordinate2D(latitude: Auxiliar.userLat.toDouble()!, longitude: Auxiliar.userLng.toDouble()!))
        markerOrigem.title = "Origem"
        markerOrigem.map = self.map_view
        
        let markerDestino = GMSMarker(position: CLLocationCoordinate2D(latitude: 41.695732, longitude: -8.849264))
        markerDestino.title = "Destino"
        markerDestino.map = self.map_view
        
        
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
    
}

extension String
{
    /// EZSE: Converts String to Double
    public func toDouble() -> Double?
    {
        if let num = NumberFormatter().number(from: self) {
            return num.doubleValue
        } else {
            return nil
        }
    }
}
