//
//  Networking.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 25/06/22.
//

import Foundation
import UIKit
import Alamofire

extension ListaCryptoViewController{
    
    
    
     func requestModel(){
        AF.request("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h").responseDecodable(of: [Crypto].self) { response in
            
            switch response.result{
            case .success(let cryptos):
                self.cryptoList = cryptos
                self.listaCrypto.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
            
//            debugPrint(response)
        }
    }
}
