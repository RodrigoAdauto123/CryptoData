//
//  CryptoLocalRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 5/07/22.
//

import Foundation

class CryptoLocalRepository:CryptoRepository{
    func getCrypto(completion: @escaping (([Crypto]?) -> (Void))) {
        
    if let url = Bundle.main.url(forResource: "crypto_success_response", withExtension: "json") {
       let data = try! Data(contentsOf: url)
       let decoder = JSONDecoder()
       let listaCrypto = try! decoder.decode([Crypto].self, from: data)
           completion(listaCrypto)
        }
    }
}
