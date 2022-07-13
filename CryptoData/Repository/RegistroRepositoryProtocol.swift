//
//  RegistroRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 8/07/22.
//

import Foundation
import FirebaseAuth

protocol RegistroRepositoryProtocol{
    func registroUsuario(correo: String,contrasenia: String ,completion: @escaping (AuthDataResult?,Error?) -> Void)
}

protocol RegistroDbRepositoryProtocol{
    func registroUsuarioDb(correo: String)
}
