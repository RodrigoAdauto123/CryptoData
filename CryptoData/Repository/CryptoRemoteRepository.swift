//
//  CryptoRemoteRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 3/07/22.
//

import Foundation
import Alamofire
import UIKit


class CryptoRemoteRepository: CryptoRepository{
    
    // Usar @Escaping cuando se hacen peticiones async
    func getCrypto(completion: @escaping (([Crypto]?) -> (Void))) {
        
        AF.request("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h").responseDecodable(of: [Crypto].self) { response in
            switch response.result{
            case .success(let cryptos):
                completion(cryptos)
                
            case .failure(_):
                completion(nil)
                
            }
        }
    }
}
