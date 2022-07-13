//
//  UsuarioDBRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 13/07/22.
//

import Foundation
import FirebaseFirestore

class UsuarioDbRepository: GetUsuarioDBRepositoryProtocol{
    
    let db = Firestore.firestore()
    
    func getUsuario(correo: String, completion: @escaping (Result<Usuario, Error>) -> Void) {
        
        db.collection("Usuarios").document(correo).getDocument(as: Usuario.self) { result in
            completion(result)
        }
    }
}
