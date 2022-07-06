//
//  DetalleViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 2/07/22.
//

import UIKit
import Kingfisher

class DetalleViewController: UIViewController {

    
    @IBOutlet weak var imageDetalleCrypto: UIImageView!
    @IBOutlet weak var fechaNoticiaCrypto: UILabel!
    @IBOutlet weak var detalleNoticiaCrypto: UILabel!
    @IBOutlet weak var tituloNoticiaCrypto: UILabel!
    @IBOutlet weak var cambioPrecioCrypto: UILabel!
    @IBOutlet weak var nombreCrypto: UILabel!
    
    @IBOutlet weak var precioCrypto: UILabel!
    
    var simbolo: String?
    var nombre: String?
    var image: String?
    var precio: String?
    var cambioPrecio: String?
    var tituloNoticia: String?
    var detalleNoticia: String?
    var fechaNoticia: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let simbolo = simbolo, let nombre = nombre, let _ = image, let precio = precio, let cambioPrecio = cambioPrecio, let tituloNoticia = tituloNoticia, let detalleNoticia = detalleNoticia, let fechaNoticia = fechaNoticia{
            nombreCrypto.text = "\(nombre) (\(simbolo.uppercased()))"
            precioCrypto.text = precio
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
    
}
