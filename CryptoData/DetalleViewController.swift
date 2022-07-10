//
//  DetalleViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 2/07/22.
//

import UIKit
import Kingfisher
import FirebaseFirestore

class DetalleViewController: UIViewController {

    
    
    @IBOutlet weak var saldoCrypto: UILabel!
    
    @IBOutlet weak var imageDetalleCrypto: UIImageView!
    @IBOutlet weak var fechaNoticiaCrypto: UILabel!
    @IBOutlet weak var detalleNoticiaCrypto: UILabel!
    @IBOutlet weak var tituloNoticiaCrypto: UILabel!
    @IBOutlet weak var cambioPrecioCrypto: UILabel!
    @IBOutlet weak var nombreCrypto: UILabel!
    
    @IBOutlet weak var precioCrypto: UILabel!
    
    let userDefaults = UserDefaults.standard
    let db = Firestore.firestore()
    var listaCrypto: [CryptoUsuario]? = []
    
    var simbolo: String?
    var nombre: String?
    var image: String?
    var precio: String?
    var cambioPrecio: String?
    var tituloNoticia: String?
    var detalleNoticia: String?
    var fechaNoticia: String?
    var correo: String = ""
    var precioFormateado: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let simbolo = simbolo, let nombre = nombre, let _ = image, let precioFormateado = precioFormateado, let cambioPrecio = cambioPrecio, let tituloNoticia = tituloNoticia, let detalleNoticia = detalleNoticia, let fechaNoticia = fechaNoticia{
            nombreCrypto.text = "\(nombre) (\(simbolo.uppercased()))"
            precioCrypto.text = precioFormateado
            cambioPrecioCrypto.text = "\(cambioPrecio)%"
            if(cambioPrecio.contains("-")){
                cambioPrecioCrypto.textColor = UIColor.red
            }
            if let image = image{
                imageDetalleCrypto.kf.setImage(with: URL(string: image))
            }
            tituloNoticiaCrypto.text = tituloNoticia
            detalleNoticiaCrypto.text = detalleNoticia
            fechaNoticiaCrypto.text = fechaNoticia
        }     
    }
 
    override func viewWillAppear(_ animated: Bool) {
       correo = userDefaults.object(forKey: "email") as! String
        db.collection("Usuarios").document(correo).getDocument(as: Usuario.self) { result in
            switch result{
            case .success(let usuario):
                self.listaCrypto = usuario.listaCrypto
                self.saldoCrypto.text = String(usuario.saldo)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
    }
    
    @IBAction func compraCryptoAction(_ sender: Any) {
        
        guard let saldoActual = Double(self.saldoCrypto.text!), let precioCrypto = Double(precio!) else {
            print("ERROR")
            return }
        
        let saldoRestante = saldoActual - precioCrypto
        if var listaCrypto = listaCrypto, !listaCrypto.isEmpty{
            var mismaMoneda = false
            for var (index,crypto) in listaCrypto.enumerated(){
                if crypto.nombre == nombreCrypto.text{
                    let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: 1, precio: precioCrypto)
                    crypto.historial?.append(detalleHistorial!)
                    listaCrypto[index] = crypto
                    mismaMoneda = true
                    break
                }
            }
            
            if mismaMoneda{
                self.listaCrypto = listaCrypto
            }else {
                let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: 1, precio: precioCrypto)
                var historial: [DetalleHistorialUsuario]? = []
                    historial?.append(detalleHistorial!)
                let cryptousuario: CryptoUsuario? = CryptoUsuario(nombre: nombreCrypto.text!, historial: historial)
                self.listaCrypto?.append(cryptousuario!)
            }
            
            
        }else {

            let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: 1, precio: precioCrypto)
            var historial: [DetalleHistorialUsuario]? = []
                historial?.append(detalleHistorial!)
            let cryptousuario: CryptoUsuario? = CryptoUsuario(nombre: nombreCrypto.text!, historial: historial)
            
            listaCrypto?.append(cryptousuario!)
        }
        let usuario = Usuario(correo: correo, listaCrypto: listaCrypto, saldo: saldoRestante)
        do{
           try db.collection("Usuarios").document(correo).setData(from: usuario)
        } catch let error{
            print("Error", error)
        }
        
    }
    
    @IBAction func ventaCryptoAction(_ sender: Any) {
        
    }
}
