//
//  LogueoViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 26/06/22.
//

import UIKit
import FirebaseAuth

class LogueoViewController: UIViewController {

    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var contraseniaLogin: UITextField!
    @IBOutlet weak var correoLogin: UITextField!
    @IBOutlet weak var inicioSesionLogin: UIButton!
    @IBOutlet weak var registroLogin: UIButton!
    
    let userDefaults = UserDefaults.standard
    let mensajeClass = MensajeAlert()
    
    
    @IBAction func botonLogin(_ sender: Any) {
        if let email = correoLogin.text, let contrasenia = contraseniaLogin.text {
            Auth.auth().signIn(withEmail: email, password: contrasenia) { result, error in
                if let result = result, error == nil{
                    let usuario = result.user
                    self.performSegue(withIdentifier: "loginSegue", sender: usuario)
                      
                } else {
                    self.present(self.mensajeClass.crearMensajeAlert(titulo: "Error", mensaje: "No se puede iniciar sesión", tituloBoton: "OK"), animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inicio de Sesión"
        if let _ = userDefaults.object(forKey: "email"){
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = segue.identifier, s == "loginSegue"{
            if let correo = correoLogin.text {
                let viewController = segue.destination as? ListaCryptoViewController
                viewController?.email = correo
            }
        }
    }
    
    func crearAlert(titulo: String, mensaje: String, tituloBoton: String) -> UIAlertController{
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: tituloBoton, style: .default))
        return alertController
    }
}
