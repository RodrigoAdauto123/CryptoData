//
//  DetalleResponse.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 2/07/22.
//

import Foundation

struct DetalleResponse: Decodable{
    let success: Bool
    let crypto: [NoticiaCrypto]
}
