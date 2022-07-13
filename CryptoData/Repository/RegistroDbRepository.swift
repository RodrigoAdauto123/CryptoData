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
    let listaCrypto: [CryptoUsuario] = []
    private let saldoInicial : Double = 5000.0
    
    func registroUsuarioDb(correo: String) {
        self.db.collection("Usuarios").document(correo).setData(["correo" : correo, "listaCrypto": listaCrypto, "saldo": self.saldoInicial ])
    }
    
    
}
