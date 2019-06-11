//
//  User.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 06/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import Foundation

class User: NSObject {
    var email: String?
    var id: String?
    var nome: String?
    var profile: String?
    var tipo: String?
    var coordenadas: NSObject?
    
    init(dictionary: [String: AnyObject]) {
        
        super.init()
        email = dictionary["email"] as? String
        id = dictionary["id"] as? String
        nome = dictionary["nome"] as? String
        profile = dictionary["profile"] as? String
        tipo = dictionary["tipo"] as? String
        coordenadas = dictionary["coordenadas"] as? NSObject
    }
    
}
