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
    
    var latUser:String?
    var lngUser:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 41.701497, longitude: -8.834756, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.0))
        path.add(CLLocationCoordinate2D(latitude: 37.45, longitude: -122.2))
        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.2))
        path.add(CLLocationCoordinate2D(latitude: 37.36, longitude: -122.0))
        
        let rectangle = GMSPolyline(path: path)
        rectangle.map = mapView
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude:41.701497 , longitude: -8.834756))
        marker.title = "TESTE"
        marker.map = mapView
    }
    
    func centerMap(location: CLLocation) {
        //let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        //mapView.setRegion(coordinateRegion,animated: true)
    }
    
    func getCoordUser(){
        Database.database().reference().child("users").queryOrdered(byChild: "id").queryEqual(toValue: Auxiliar.userLoged).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func drawRoute(map : GMSMapView){
        let origin = "\(41.697607),\(-8.849940)"
        let destination = "\(41.695732),\(-8.849264)"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAOEfIHh-VYr8V73LmBo_ubiQrOeMdgPaE"
        
        var newUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=41.697131,-8.835841&destination=41.697412,-8.841945&waypoints=optimize:true|41.693257,-8.846853|41.690134,-8.830279|41.694667,-8.833592|41.695114,-8.820588|41.701545,-8.835176&key=AIzaSyAOEfIHh-VYr8V73LmBo_ubiQrOeMdgPaE"
        
        
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
                                polyline.strokeColor = .red
                                polyline.strokeWidth = 10.0
                                polyline.map = map
                            }
                            
                        }
                        
                    }
                    
                    
                }
            }catch let parsingError {
                print("ERRO")
                print(parsingError)
            }
            
            /*let json = JSON(data: response.data!)
             
             
             */
            }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
