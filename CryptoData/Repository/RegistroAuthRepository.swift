//
//  RegistroAuthRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 8/07/22.
//

import Foundation
import FirebaseAuth

class RegistroAuthRepository: RegistroRepositoryProtocol{
    func registroUsuario(correo: String, contrasenia: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: correo, password: contrasenia) { (result,error) in
            completion(result,error)
        }
    }
}
