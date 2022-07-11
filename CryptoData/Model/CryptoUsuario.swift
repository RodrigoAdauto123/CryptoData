//
//  Historial.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 9/07/22.
//

import Foundation

struct CryptoUsuario: Codable{
    var nombre: String
    var historial: [DetalleHistorialUsuario]?
    var cantidadTotalCrypto: Double
}
