//
//  Geral.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 04/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import Firebase

class Auxiliar{
    
    static let shared = Auxiliar()

    static var userLoged:String = ""
    static var userProfile:String = ""
    
    //Initializer access level change now
    private init(){}
    
    func getBtnLogout() -> UIButton {
        let logout = UIButton(type: .system)
        logout.setImage(UIImage(named: "logout_blue")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return logout
    }
}

