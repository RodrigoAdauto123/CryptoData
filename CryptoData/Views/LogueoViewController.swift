//
//  LogueoViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 26/06/22.
//

import UIKit
import Lottie

class LogueoViewController: UIViewController {

    
    @IBOutlet weak var inicioAnimated: AnimationView!
    @IBOutlet weak var loginStackView: UIStackView!
    @IBOutlet weak var contraseniaLogin: UITextField!
    @IBOutlet weak var correoLogin: UITextField!
    @IBOutlet weak var inicioSesionLogin: UIButton!
    @IBOutlet weak var registroLogin: UIButton!
    
    let userDefaults = UserDefaults.standard
    let mensajeClass = MensajeAlert()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CryptoData"
        
        //MARK: Configuracion nombre del backbutton
        let backBarBtnItem = UIBarButtonItem()
            backBarBtnItem.title = "Ingreso"
            navigationItem.backBarButtonItem = backBarBtnItem
        
        navigationItem.setHidesBackButton(true, animated: false)
        if let _ = userDefaults.object(forKey: "email"){
            loginStackView.isHidden = true
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }else {
            cryptoAnimacion()
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
    
    @IBAction func botonLogin(_ sender: Any) {
        if let email = correoLogin.text, let contrasenia = contraseniaLogin.text, !correoLogin.text!.isEmpty && !contraseniaLogin.text!.isEmpty{
            
            let logueoRepository: LogueoRepositoryProtocol
            logueoRepository = LogueoAuthRepository()
            
            logueoRepository.logueoUsuario(correo: email, contrasenia: contrasenia,completion: { result, error in
                if let _ = result, error == nil{
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                      
                } else {
                    self.present(self.mensajeClass.crearMensajeAlert(titulo: "Error", mensaje: "Correo y/o contraseña incorrectas", tituloBoton: "OK"), animated: true, completion: nil)
                }
            })
        }else {
            self.present(self.mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "Querido CryptoUsuario para ingresar necesita colocar un usuario y contraseña", tituloBoton: "OK"), animated: true, completion: nil)
        }
    }
    
}

extension LogueoViewController{
    
    func cryptoAnimacion(){
        inicioAnimated.center = view.center
        inicioAnimated.contentMode = .center
        inicioAnimated.loopMode = .loop
        inicioAnimated.play()
        
    }
}
