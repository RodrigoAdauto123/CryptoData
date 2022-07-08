//
//  RegistroViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 26/06/22.
//

import UIKit
import FirebaseAuth
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
        if let correo = correoRegistro.text, let contrasenia = contraseniaRegistro.text, let repitaContrasenia = repitaContrasenia.text, contrasenia.elementsEqual(repitaContrasenia) {
             
            let registroUsuario: RegistroRepositoryProtocol
            registroUsuario = RegistroAuthRepository()
            
            registroUsuario.registroUsuario(correo: correo, contrasenia: contrasenia) { result, error in
                if let _ = result, error == nil{
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.present(self.alertaClass.crearMensajeAlert(titulo: "Error en registro de usuario", mensaje: "Hubo un problema al registrar el usuario, revise que el correo ya no se encuentra en uso", tituloBoton: "OK"), animated: true, completion: nil)
                }
            }            
        }
    }
    func cryptoAnimacion(){
        registroAnimated.center = view.center
        registroAnimated.contentMode = .scaleAspectFill
        registroAnimated.loopMode = .loop
        registroAnimated.play()
        
    }
}
