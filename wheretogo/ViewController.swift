//
//  ViewController.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 28/05/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    // MARK properties
    
    @IBOutlet weak var usernamelbl: UITextField!
    @IBOutlet weak var passwordlbl: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
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
        Auth.auth().signIn(withEmail: usernamelbl.text!, password: passwordlbl.text!) { user, error in
            if error == nil && user != nil {
                print("Login feito")
            } else {
                print("Error logging in: \(error!.localizedDescription)")
            }
        }
    }
    
    
}


