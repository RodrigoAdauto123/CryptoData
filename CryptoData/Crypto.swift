//
//  Crypto.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 25/06/22.
//

import Foundation

struct Crypto: Decodable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let totalVolume, high24H, low24H: Double
    let circulatingSupply: Double
    let priceChange24h: Double
    
    enum CodingKeys: String, CodingKey{
        case id, symbol, name, image
        case currentPrice = "current_price"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case circulatingSupply = "circulating_supply"
        case priceChange24h = "price_change_24h"
    }
}


