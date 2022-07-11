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
    let mensajeClass = MensajeAlert()
    
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
    var saldo: Double?
    var usuarioCrypto: CryptoUsuario?
    

    
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
                self.saldoCrypto.text = usuario.saldo.conversionPrecio()
                self.saldo = usuario.saldo
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
    }
    
    @IBAction func compraCryptoAction(_ sender: Any) {
        
        guard let saldoActual = self.saldo, let precioCrypto = Double(precio!) else {
            return }
        
        let saldoRestante = saldoActual - precioCrypto
        let permisoCompra = saldoRestante < 0
        switch permisoCompra{
            case true:
                self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "No tiene saldo para hacer esta compra", tituloBoton: "OK"), animated: true, completion: nil)
                break
                
            case false:
                if var listaCrypto = listaCrypto, !listaCrypto.isEmpty{
                    var mismaMoneda = false
                    for var (index,crypto) in listaCrypto.enumerated(){
                        if crypto.nombre == nombreCrypto.text{
                            let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: 1, precio: precioCrypto,tipo: "Compra")
                            crypto.historial?.append(detalleHistorial!)
                            crypto.cantidadTotalCrypto += 1
                            listaCrypto[index] = crypto
                            mismaMoneda = true
                            break
                        }
                    }
                    switch mismaMoneda{
                        
                        case true:
                            self.listaCrypto = listaCrypto
                            break
                        case false:
                            crearTransaccion(cantidad: 1, precio: precioCrypto, tipo: "Compra")
                            break
                    }
                }else {
                    crearTransaccion(cantidad: 1, precio: precioCrypto, tipo: "Compra")
                }
            
                let usuario = Usuario(correo: correo, listaCrypto: listaCrypto, saldo: saldoRestante)
                do{
                   try db.collection("Usuarios").document(correo).setData(from: usuario)
                } catch let error{
                    print("Error", error)
                }
            self.viewWillAppear(true)
                break
        }
    }
    
    @IBAction func ventaCryptoAction(_ sender: Any) {
        
        guard var usuarioCrypto = self.listaCrypto!.enumerated().first(where: {$0.element.nombre == self.nombreCrypto.text}) else {
            self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "No tiene esta cryptomoneda", tituloBoton: "OK"), animated: true, completion: nil)
            return}
        let cantidadTotalCrypto = usuarioCrypto.element.cantidadTotalCrypto - 1
        guard let _ =  usuarioCrypto.element.historial, let precioCrypto = Double(precio!), let saldo = self.saldo, cantidadTotalCrypto >= 0 else{
            
            self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "No tiene esta cryptomoneda", tituloBoton: "OK"), animated: true, completion: nil)
            return
        }
        
        let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: 1, precio: precioCrypto,tipo: "Venta")
        usuarioCrypto.element.historial?.append(detalleHistorial!)
        usuarioCrypto.element.cantidadTotalCrypto = cantidadTotalCrypto
        self.listaCrypto![usuarioCrypto.offset] = usuarioCrypto.element
        let saldoRestante  = saldo + precioCrypto
        
        let usuario = Usuario(correo: correo, listaCrypto: listaCrypto, saldo: saldoRestante)
        do{
           try db.collection("Usuarios").document(correo).setData(from: usuario)
        } catch let error{
            print("Error", error)
        }
        self.viewWillAppear(true)
        
    }
    
    func crearTransaccion(cantidad: Double, precio: Double, tipo: String){
        
        let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: cantidad, precio: precio,tipo: tipo)
        var historial: [DetalleHistorialUsuario]? = []
            historial?.append(detalleHistorial!)
        let cryptousuario: CryptoUsuario? = CryptoUsuario(nombre: nombreCrypto.text!, historial: historial,cantidadTotalCrypto: cantidad)
        self.listaCrypto?.append(cryptousuario!)
    }
}
