//
//  AdminMainPage.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 30/05/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase

class AdminMainPage: UITabBarController {
    
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
        
        
        
        /*let selectedImageAdds = UIImage(named: "logout_blue")?.withRenderingMode(.alwaysOriginal)
        let DeSelectedImageAdds = UIImage(named: "logout_grey")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[2])!
        tabBarIteam.image = DeSelectedImageAdds
        tabBarIteam.selectedImage = selectedImageAdds
        tabBarIteam.title = "Logout"*/
        
        // initaial tab bar index
        self.selectedIndex = 0

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: true)
        let btnLogOut = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(AdminMainPage.logOut))
        self.navigationItem.rightBarButtonItem = btnLogOut
        
        print("IMAGEM")
        print(Auxiliar.userProfile)
        let imageView = UIImageView(image:UIImage(named: "cancel"))
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.loadImageUsingCacheWithUrlString(urlString: Auxiliar.userProfile)
        self.navigationItem.titleView = imageView
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
                // maybe do something here
            })
        })
        alert.addAction(OKAction)
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
