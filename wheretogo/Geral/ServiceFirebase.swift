//
//  ServiceFirebase.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 06/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import Foundation

class ServiceFirebase: NSObject {
    var id: String?
    var contato: String?
    var data: String?
    var descricao: String?
    var estado: String?
    var morada: String?
    var tipo: String?
    var tecnico: NSObject?
    var coordenadas: NSObject?
    
    init(dictionary: [String: AnyObject]) {
        
        super.init()
        id = dictionary["id"] as? String
        contato = dictionary["contato"] as? String
        data = dictionary["data"] as? String
        descricao = dictionary["descricao"] as? String
        tipo = dictionary["tipo"] as? String
        tecnico = dictionary["tecnico"] as? NSObject
        estado = dictionary["estado"] as? String
        morada = dictionary["morada"] as? String
        coordenadas = dictionary["coordenadas"] as? NSObject
    }
}
