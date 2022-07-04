//
//  CryptoRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 3/07/22.
//

import Foundation

protocol CryptoRepository{
    func getCrypto(completion: @escaping (([Crypto]?) -> (Void)))
}
