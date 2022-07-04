//
//  RegistroViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 26/06/22.
//

import UIKit
import FirebaseAuth

class RegistroViewController: UIViewController {

    @IBOutlet weak var repitaContrasenia: UITextField!
    @IBOutlet weak var contraseniaRegistro: UITextField!
    @IBOutlet weak var correoRegistro: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro de usuario"

    }
    
    @IBAction func registroUsuarioAction(_ sender: Any) {
        if let correo = correoRegistro.text, let contrasenia = contraseniaRegistro.text, let repitaContrasenia = repitaContrasenia.text, contrasenia.elementsEqual(repitaContrasenia) {
            Auth.auth().createUser(withEmail: correo, password: contrasenia) { (result,error) in
                if let result = result, error == nil{
                    
                    self.navigationController?.popViewController(animated: true)
                    
                }else {
                    let alertaError = UIAlertController(title: "Error en registro de usuario", message: "Hubo un problema al registrar el usuario, revise que el correo ya no se encuentra en uso", preferredStyle: .alert)
                    
                    alertaError.addAction(UIAlertAction(title: "OK", style: .destructive))
                    self.present(alertaError, animated: true, completion: nil)
                }
            }
        }
    }
    

}
