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
    
    var pickerData: [String] = [String]()
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    var mapUsers = Dictionary<String, Array<ServiceFirebase>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = GMSCameraPosition.camera(withLatitude: 41.701497, longitude: -8.834756, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
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
        
        
        picker = UIPickerView.init()
        picker.delegate = self
        picker.autoresizingMask = .flexibleWidth
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: 0.0,  width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.view.addSubview(picker)
        
        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: 60, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .default
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)
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
                    self.pickerData.append(user)
                }
                
                
                DispatchQueue.main.async {
                    for(key, values) in self.mapUsers{
                        
                        for value in values {
                            var servico = value as! ServiceFirebase
                            print(servico.data)
                        }
                    }
                }
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
        }.resume()
    }
    
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        let selected = picker.selectedRow(inComponent: 0)
        print(selected)
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
