//
//  NoticiaCrypto.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 2/07/22.
//

import Foundation

struct NoticiaCrypto: Decodable {
    let nombre: String
    let titulo: String
    let detalleNoticia: String
    let fechaNoticia: String
    
    enum CodingKeys: String, CodingKey{
        case nombre, titulo
        case detalleNoticia = "detalle_noticia"
        case fechaNoticia = "fecha_noticia"
    }
}
