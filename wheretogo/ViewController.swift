//
//  ViewController.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 28/05/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK properties
    
    @IBOutlet weak var usernamelbl: UITextField!
    @IBOutlet weak var passwordlbl: UITextField!
    @IBOutlet weak var erroMessage: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: MDCButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Database.database().reference().keepSynced(true)
        
        
        if Auth.auth().currentUser != nil {
            let userID = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                self.loader.isHidden = true
                let value = snapshot.value as? [String: AnyObject]
                let tipo = value?["tipo"] as? String ?? ""
                let profile = value?["profile"] as? String ?? ""
                let userLat = value?["coordenadas"]?["latitude"] as! NSNumber
                let userLng = value?["coordenadas"]?["longitude"] as! NSNumber
                
                Auxiliar.userLat = userLat.stringValue
                Auxiliar.userLng = userLng.stringValue
                Auxiliar.userLoged = userID!
                Auxiliar.userProfile = profile
                
                if(tipo == "Administrador"){
                    self.performSegue(withIdentifier: "Segue_Admin", sender: self)
                }else{
                    self.performSegue(withIdentifier: "Tecnico_Segue", sender: self)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        let containerScheme = MDCContainerScheme()
        containerScheme.colorScheme.primaryColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        btnLogin.applyOutlinedTheme(withScheme: containerScheme)
        btnLogin.setBorderColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        
        /*self.ref?.child("users").child("tDREuicczZgLyBsZ4JUeqedI19j2")
            .setValue(["nome": "Lobarinhas", "tipo": "Tecnico", "id": "tDREuicczZgLyBsZ4JUeqedI19j2", "email": "lobarinhas@pinheiro.pt"])*/
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
        self.erroMessage.isHidden = true;
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == usernamelbl{
            usernamelbl.resignFirstResponder()
            passwordlbl.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC: AdminMainPage = segue.destination as! AdminMainPage
        secondVC.userLoged = self.userLoged;
        
    }*/
    
    
    @IBAction func login(_ sender: Any) {
        loader.isHidden = false
        Auth.auth().signIn(withEmail: usernamelbl.text!, password: passwordlbl.text!) { user, error in
            if error == nil && user != nil {
                
                let userID = Auth.auth().currentUser?.uid
                Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    self.loader.isHidden = true
                    let value = snapshot.value as? [String: AnyObject]
                    let tipo = value?["tipo"] as? String ?? ""
                    let profile = value?["profile"] as? String ?? ""
                    let userLat = value?["coordenadas"]?["latitude"] as! NSNumber
                    let userLng = value?["coordenadas"]?["longitude"] as! NSNumber
                    
                    Auxiliar.userLat = userLat.stringValue
                    Auxiliar.userLng = userLng.stringValue
                    Auxiliar.userLoged = userID!
                    Auxiliar.userProfile = profile
                    
                    if(tipo == "Administrador"){
                        self.performSegue(withIdentifier: "Segue_Admin", sender: self)
                    }else{
                        self.performSegue(withIdentifier: "Tecnico_Segue", sender: self)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            } else {
                self.erroMessage.text = "Credenciais incorretas"
                self.erroMessage.isHidden = false;
                self.loader.isHidden = true
            }
        }
    }
    
    
}


