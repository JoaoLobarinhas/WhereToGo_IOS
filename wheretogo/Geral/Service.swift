//
//  Service.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 05/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import Foundation

class Service {
    var id: String
    var contato: String
    var data: String
    var descricao: String
    var estado: String
    var morada: String
    var tecnico: String
    var tipo: String
    var coordenadas: Coordenadas
    
    
    init(id: String, contato: String, data: String, descricao: String, estado: String, morada: String, tecnico: String, tipo: String, coordenadas: Coordenadas) {
        self.id = id;
        self.contato = contato;
        self.data = data;
        self.descricao = descricao;
        self.estado = estado;
        self.morada = morada;
        self.tecnico = tecnico;
        self.tipo = tipo;
        self.coordenadas = coordenadas;
    }
}
