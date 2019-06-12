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
        
        getServicos(todayDate: todayString)
        
        
        
    }
    
    
    func getServicos(todayDate: String){
        
        
        Database.database().reference().child("servico").queryOrdered(byChild: "data").queryOrdered(byChild: todayDate).observe(.childAdded, with: { (snapshot) in
            
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                print(dictionary)
                
                if dictionary["tecnico"]?["id"] as! String == Auxiliar.userLoged {
                    let servico = ServiceFirebase(dictionary: dictionary)
                    self.services.append(servico)
    
                }
                
                //DispatchQueue.main.async {
                    //self.drawRoute()
                //}
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func drawRoute(){
        var coordenadasString:String = ""
        for s in self.services{
            var latitude = s.coordenadas?.value(forKey: "latitude") as? NSNumber
            var longitude = s.coordenadas?.value(forKey: "longitude") as? NSNumber
            coordenadasString += (latitude?.stringValue)!
            coordenadasString += ","
            coordenadasString += (longitude?.stringValue)!
            coordenadasString += "|"
        }
        var newUrl = "https://maps.googleapis.com/maps/api/directions/json?origin="+Auxiliar.userLat+","+Auxiliar.userLng+"&destination=41.697412,-8.841945&waypoints=optimize:true|"
            + coordenadasString +
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
