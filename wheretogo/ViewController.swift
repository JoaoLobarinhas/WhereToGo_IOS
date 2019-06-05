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

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK properties
    
    @IBOutlet weak var usernamelbl: UITextField!
    @IBOutlet weak var passwordlbl: UITextField!
    @IBOutlet weak var erroMessage: UILabel!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        /*self.ref?.child("users").child("jaPbkxC9WXaIcgyFMLgGppDsc4A3")
            .setValue(["nome": "Paulo", "tipo": "Tecnico", "id": "jaPbkxC9WXaIcgyFMLgGppDsc4A3", "email": "paulo@paulo.pt"])*/
        
        /*self.ref?.child("servico").observe(.value) { snapshot in
            for child in snapshot.children {
                print(child)
            }
        }*/
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
    
    @IBAction func login(_ sender: UIButton) {
        loader.isHidden = false
        Auth.auth().signIn(withEmail: usernamelbl.text!, password: passwordlbl.text!) { user, error in
            if error == nil && user != nil {
                
                let userID = Auth.auth().currentUser?.uid
                self.ref?.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    self.loader.isHidden = true
                    let value = snapshot.value as? NSDictionary
                    let tipo = value?["tipo"] as? String ?? ""
                    if(tipo == "Administrador"){
                        self.performSegue(withIdentifier: "Segue_Admin", sender: self.btnLogin)
                    }else{
                        self.performSegue(withIdentifier: "Tecnico_Segue", sender: self.btnLogin)
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


