//
//  LogueoRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 8/07/22.
//

import Foundation
import FirebaseAuth

protocol LogueoRepositoryProtocol{
    func logueoUsuario(correo: String,contrasenia: String ,completion: @escaping (AuthDataResult?,Error?) -> Void)
    
}
