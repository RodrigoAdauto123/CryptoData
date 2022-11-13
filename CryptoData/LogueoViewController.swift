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
        
        navigationItem.setHidesBackButton(true, animated: false)
        if let _ = userDefaults.object(forKey: "email"){
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }else {
            cryptoAnimacion()
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        correoLogin.text = ""
        contraseniaLogin.text = ""
        if let _ = userDefaults.object(forKey: "email"){
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
        if let email = correoLogin.text, let contrasenia = contraseniaLogin.text {
            
            let logueoRepository : LogueoRepositoryProtocol
            logueoRepository = LogueoAuthRepository()
            
            logueoRepository.logueoUsuario(correo: email, contrasenia: contrasenia,completion: { result, error in
                if let result = result, error == nil{
                    let usuario = result.user
                    //                    self.performSegue(withIdentifier: "loginSegue", sender: usuario)
                    
                    let tableView = (self.storyboard?.instantiateViewController(identifier: "ListaCryptoViewController", creator: { coder in
                        ListaCryptoViewController(coder: coder ,listaRepository: CryptoRemoteRepository())
                    }))!
                    self.navigationController?.pushViewController(tableView, animated: false)
                    
                } else {
                    self.present(self.mensajeClass.crearMensajeAlert(titulo: "Error", mensaje: "No se puede iniciar sesión", tituloBoton: "OK"), animated: true, completion: nil)
                }
            })
        }
    }
    
    func cryptoAnimacion(){
        inicioAnimated.center = view.center
        inicioAnimated.contentMode = .center
        inicioAnimated.loopMode = .loop
        inicioAnimated.play()
        
    }
}
