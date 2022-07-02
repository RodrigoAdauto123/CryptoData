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
    
    
    @IBAction func botonLogin(_ sender: Any) {
        if let email = correoLogin.text, let contrasenia = contraseniaLogin.text {
            Auth.auth().signIn(withEmail: email, password: contrasenia) { result, error in
                if let result = result, error == nil{
                     
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                      
                } else {
                    let alertController = UIAlertController(title: "Erro", message: "No se puede iniciar sesión", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Inicio de Sesión"

        if let _ = userDefaults.object(forKey: "email"){
     
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
//            loginStackView.isHidden = true
//            self.navigationController?.pushViewController(ListaCryptoViewController(), animated: true)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = segue.identifier, s == "loginSegue"{
            if let correo = correoLogin.text {
                let viewController = segue.destination as? ListaCryptoViewController
                viewController?.email = correoLogin.text
            }
            
             
        }
    }


}
