//
//  MensajeAlert.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 5/07/22.
//

import Foundation
import UIKit

class MensajeAlert{
    func crearMensajeAlert(titulo: String, mensaje: String, tituloBoton: String) -> UIAlertController{
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: tituloBoton, style: .default))
        return alertController
    }
}
