//
//  DetalleViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 2/07/22.
//

import UIKit
import Kingfisher

class DetalleViewController: UIViewController {

    
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet var detalleView: UIView!
    @IBOutlet weak var saldoCrypto: UILabel!
    
    @IBOutlet weak var imageDetalleCrypto: UIImageView!
    @IBOutlet weak var fechaNoticiaCrypto: UILabel!
    @IBOutlet weak var detalleNoticiaCrypto: UILabel!
    @IBOutlet weak var tituloNoticiaCrypto: UILabel!
    @IBOutlet weak var cambioPrecioCrypto: UILabel!
    @IBOutlet weak var nombreCrypto: UILabel!
    
    @IBOutlet weak var precioCrypto: UILabel!
    
    let userDefaults = UserDefaults.standard
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
        // MARK: Muestra nombre, precio, imagen y noticia de la cryptomoneda
        indicatorView.startAnimating()
        
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
        // MARK: Mostrar y actualizar el saldo del CryptoUsuario
       correo = userDefaults.object(forKey: "email") as! String
        let getUsuario: GetUsuarioDBRepositoryProtocol
        getUsuario = UsuarioDbRepository()
        getUsuario.getUsuario(correo: correo) { result in
            switch result{
            case .success(let usuario):
                self.listaCrypto = usuario.listaCrypto
                self.saldoCrypto.text = usuario.saldo.conversionPrecio()
                self.saldo = usuario.saldo
                self.indicatorView.stopAnimating()
                break
            case .failure(_):
                self.present(self.mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "Hubo problemas para mostrar su saldo actual. Intente de nuevo", tituloBoton: "OK"), animated: true, completion: nil)
                break
            }
        }
    }
    // MARK: Compra de cryptomoneda
    @IBAction func compraCryptoAction(_ sender: Any) {
        
        guard let saldoActual = self.saldo, let precioCrypto = Double(precio!) else {
            return }
        
        let saldoRestante = saldoActual - precioCrypto
        let permisoCompra = saldoRestante < 0
        let actualizarUsuarioDb: RegistroDbRepositoryProtocol
        switch permisoCompra{
            case true:
                self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "No tiene saldo para hacer esta compra", tituloBoton: "OK"), animated: true, completion: nil)
                break
                
            case false:
                if var listaCrypto = listaCrypto, !listaCrypto.isEmpty{
                    var mismaMoneda = false
                    for var (index,crypto) in listaCrypto.enumerated(){
                        if crypto.nombre == nombreCrypto.text{
                            let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: Constantes.cantidadCrypto, precio: precioCrypto,tipo: "Compra")
                            crypto.historial?.append(detalleHistorial!)
                            crypto.cantidadTotalCrypto += Constantes.cantidadCrypto
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
                        crearTransaccion(cantidad: Constantes.cantidadCrypto, precio: precioCrypto, tipo: "Compra")
                            break
                    }
                }else {
                    crearTransaccion(cantidad: Constantes.cantidadCrypto, precio: precioCrypto, tipo: "Compra")
                }
            
            actualizarUsuarioDb = RegistroDbRepository()
            let error = actualizarUsuarioDb.registroUsuarioDb(correo: correo, listaCrypto: listaCrypto, saldo: saldoRestante)
            if error != nil{
                self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "Tenemos problemas con nuestro servicio de venta. Intente de nuevo", tituloBoton: "OK"), animated: true, completion: nil)
            }
            self.viewWillAppear(true)
                break
        }
    }
    // MARK: Venta de cryptomoneda
    @IBAction func ventaCryptoAction(_ sender: Any) {
        let actualizarUsuarioDb: RegistroDbRepositoryProtocol
        
        guard var usuarioCrypto = self.listaCrypto!.enumerated().first(where: {$0.element.nombre == self.nombreCrypto.text}) else {
            self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "No tiene esta cryptomoneda", tituloBoton: "OK"), animated: true, completion: nil)
            return}
        let cantidadTotalCrypto = usuarioCrypto.element.cantidadTotalCrypto - Constantes.cantidadCrypto
        guard let _ =  usuarioCrypto.element.historial, let precioCrypto = Double(precio!), let saldo = self.saldo, cantidadTotalCrypto >= 0 else{
            
            self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "No tiene esta cryptomoneda", tituloBoton: "OK"), animated: true, completion: nil)
            return
        }
        
        let detalleHistorial: DetalleHistorialUsuario? = DetalleHistorialUsuario(cantidad: Constantes.cantidadCrypto, precio: precioCrypto,tipo: "Venta")
        usuarioCrypto.element.historial?.append(detalleHistorial!)
        usuarioCrypto.element.cantidadTotalCrypto = cantidadTotalCrypto
        self.listaCrypto![usuarioCrypto.offset] = usuarioCrypto.element
        let saldoRestante  = saldo + precioCrypto
        
        actualizarUsuarioDb = RegistroDbRepository()
        let error = actualizarUsuarioDb.registroUsuarioDb(correo: correo, listaCrypto: listaCrypto, saldo: saldoRestante)
        if error != nil{
            self.present(mensajeClass.crearMensajeAlert(titulo: "UPS", mensaje: "Tenemos problemas con nuestro servicio de venta. Intente de nuevo", tituloBoton: "OK"), animated: true, completion: nil)
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
