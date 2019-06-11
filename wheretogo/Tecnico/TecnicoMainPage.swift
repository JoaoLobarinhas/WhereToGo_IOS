//
//  TecnicoMainPage.swift
//  wheretogo
//
//  Created by Lobarinhas on 04/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase

class TecnicoMainPage: UITabBarController{
    
    var tabBarIteam = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], for: .normal)
        
        let selectedImageAssign = UIImage(named: "assignments_blue")?.withRenderingMode(.alwaysOriginal)
        let DeSelectedImageAssign = UIImage(named: "assignments_grey")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[0])!
        tabBarIteam.image = DeSelectedImageAssign
        tabBarIteam.selectedImage = selectedImageAssign
        tabBarIteam.title = "Serviços"
        
        let selectedImageAdd = UIImage(named: "map_blue")?.withRenderingMode(.alwaysOriginal)
        let DeSelectedImageAdd = UIImage(named: "map_grey")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[1])!
        tabBarIteam.image = DeSelectedImageAdd
        tabBarIteam.selectedImage = selectedImageAdd
        tabBarIteam.title = "Mapa"
        
        // initaial tab bar index
        self.selectedIndex = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUrlImage()
        self.navigationItem.setHidesBackButton(true, animated: true)
        let btnLogOut = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(TecnicoMainPage.logOut))
        self.navigationItem.rightBarButtonItem = btnLogOut
        getUrlImage()
    }
    
    func getUrlImage(){
        
        Database.database().reference().child("users").queryOrdered(byChild: "id").queryEqual(toValue: Auxiliar.userLoged).observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let urlImage = dictionary["profile"] as! String
                let image = UIImage(named: "user")
                let imageView = UIImageView(image: image)
                imageView.layer.cornerRadius = 15
                imageView.layer.masksToBounds = true
                imageView.loadImageUsingCacheWithUrlString(urlString: urlImage)
                self.navigationItem.titleView = imageView
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    @IBAction func logOut() {
        let alert = UIAlertController(title: "Confirmação", message: "Quer mesmo terminar a sua sessão?", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Sim", style: UIAlertActionStyle.default, handler: {
            (_)in
            try! Auth.auth().signOut()
            let window = UIApplication.shared.keyWindow!
            let frame = window.rootViewController!.view.frame
            
            let controller = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "navigationInicial")
            
            controller.view.frame = frame
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = controller
            }, completion: { completed in
               
            })
        })
        alert.addAction(OKAction)
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

