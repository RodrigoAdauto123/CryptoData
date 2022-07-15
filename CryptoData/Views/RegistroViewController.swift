//
//  RegistroViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 26/06/22.
//

import UIKit
import Lottie

class RegistroViewController: UIViewController {

    @IBOutlet weak var registroAnimated: AnimationView!
    @IBOutlet weak var repitaContrasenia: UITextField!
    @IBOutlet weak var contraseniaRegistro: UITextField!
    @IBOutlet weak var correoRegistro: UITextField!
    let alertaClass = MensajeAlert()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro de usuario"
        cryptoAnimacion()
    }
    
    @IBAction func registroUsuarioAction(_ sender: Any) {
        view.endEditing(true)
        if let correo = correoRegistro.text, let contrasenia = contraseniaRegistro.text, let repitaContrasenia = repitaContrasenia.text, contrasenia == repitaContrasenia && !contrasenia.isEmpty && !correo.isEmpty{
             
            let registroUsuario: RegistroRepositoryProtocol
            registroUsuario = RegistroAuthRepository()
            let registroDb: RegistroDbRepositoryProtocol
            registroDb = RegistroDbRepository()
            
            registroUsuario.registroUsuario(correo: correo, contrasenia: contrasenia) { result, error in
                if let _ = result, error == nil{
                    if let _ = registroDb.registroUsuarioDb(correo: correo,listaCrypto: [],saldo: Constantes.saldo){
                        // MARK: Error del servicio de firestore
                        self.present(self.alertaClass.crearMensajeAlert(titulo: "Error en registro de usuario", mensaje: "Actualmente tenemos problemas con nuestro servicio de logueo. Intente de nuevo", tituloBoton: "OK"), animated: true, completion: nil)
                    }else{
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                }else {
                    // MARK: Error del servicio de Authetication
                    self.present(self.alertaClass.crearMensajeAlert(titulo: "Error en registro de usuario", mensaje: "Hubo un problema al registrar el usuario, revise que el correo no se encuentre en uso", tituloBoton: "OK"), animated: true, completion: nil)
                }
            }            
        }else {
            // MARK: Error en las validaciones
            self.present(self.alertaClass.crearMensajeAlert(titulo: "UPS", mensaje: "Querido CryptoUsuario para registrarse necesita colocar un usuario y contraseña", tituloBoton: "OK"), animated: true, completion: nil)
        }
    }
    func cryptoAnimacion(){
        registroAnimated.center = view.center
        registroAnimated.contentMode = .scaleAspectFill
        registroAnimated.loopMode = .loop
        registroAnimated.play()
    }
}
