//
//  Coordenadas.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 05/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import Foundation

class Coordenadas: Codable {
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    
    init(latitude: Float, longitude: Float) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
}
