//
//  Usuario.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 9/07/22.
//

import Foundation

// MARK: Usuario en firestore
struct Usuario: Codable{
    var correo: String
    var listaCrypto: [CryptoUsuario]?
    var saldo: Double = 5000.0
    
}
