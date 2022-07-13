//
//  RegistroDbRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 12/07/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class RegistroDbRepository: RegistroDbRepositoryProtocol{
    let db = Firestore.firestore()
    
    func registroUsuarioDb(correo: String, listaCrypto: [CryptoUsuario]?, saldo: Double ) -> Error? {
        
        let usuario = Usuario(correo: correo, listaCrypto: listaCrypto, saldo: saldo)
        do{
           try db.collection("Usuarios").document(correo).setData(from: usuario)
           return nil
        } catch let error{
            return error
        }
    }  
}
