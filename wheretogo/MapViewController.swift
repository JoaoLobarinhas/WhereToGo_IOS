//
//  MapViewController.swift
//  wheretogo
//
//  Created by Aluno on 10/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: 41.701497, longitude: -8.834756)
        
        self.centerMap(location: initialLocation)
        
        drawRoute()

        // Do any additional setup after loading the view.
    }
    
    func centerMap(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        mapView.setRegion(coordinateRegion,animated: true)
    }
    
    func drawRoute(){
        let origin = "\(41.700122),\(-8.846185)"
        let destination = "\(41.693048),\(-8.843095)"
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyAOEfIHh-VYr8V73LmBo_ubiQrOeMdgPaE"
        let url = URL(string: urlString)
        
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
                            let points = routeDictionary["overview_polyline"]!["points"]
                            let path = GMSPath.init(fromEncodedPath: points!)
                            
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeColor = .black
                            polyline.strokeWidth = 10.0
                            polyline.map = self.mapView
                        }
                        
                    }
                    
                    
                }
                /*for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = .black
                    polyline.strokeWidth = 10.0
                    polyline.map = mapViewX
                    
                }*/
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
