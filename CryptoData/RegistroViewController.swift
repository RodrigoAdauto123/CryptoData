//
//  RegistroViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 26/06/22.
//

import UIKit
import FirebaseAuth

class RegistroViewController: UIViewController {

    @IBOutlet weak var contraseniaRegistro: UITextField!
    @IBOutlet weak var correoRegistro: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func registroUsuarioAction(_ sender: Any) {
        if let correo = correoRegistro.text, let contrasenia = contraseniaRegistro.text {
            Auth.auth().createUser(withEmail: correo, password: contrasenia) { (result,error) in
                if let result = result, error == nil{
                    self.navigationController?.popViewController(animated: true)
                    
                }else {
                    // Crear un alert para mostrar que hay error al crear el usuario
                    print("Error")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
