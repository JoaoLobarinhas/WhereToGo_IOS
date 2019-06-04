//
//  TecnicoMainPage.swift
//  wheretogo
//
//  Created by Lobarinhas on 04/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit

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
        
        let selectedImageAdd = UIImage(named: "assignments_blue")?.withRenderingMode(.alwaysOriginal)
        let DeSelectedImageAdd = UIImage(named: "assignments_grey")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[1])!
        tabBarIteam.image = DeSelectedImageAdd
        tabBarIteam.selectedImage = selectedImageAdd
        
        let selectedImageAdds = UIImage(named: "assignments_blue")?.withRenderingMode(.alwaysOriginal)
        let DeSelectedImageAdds = UIImage(named: "assignments_grey")?.withRenderingMode(.alwaysOriginal)
        tabBarIteam = (self.tabBar.items?[2])!
        tabBarIteam.image = DeSelectedImageAdds
        tabBarIteam.selectedImage = selectedImageAdds
        
        // initaial tab bar index
        self.selectedIndex = 2
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
