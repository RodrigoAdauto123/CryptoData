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
    func registroUsuarioDb(correo: String, listaCrypto: [CryptoUsuario]?, saldo: Double) -> Error?
}

protocol GetUsuarioDBRepositoryProtocol{
    func getUsuario(correo: String, completion: @escaping (Result<Usuario, Error>) -> Void)
}
