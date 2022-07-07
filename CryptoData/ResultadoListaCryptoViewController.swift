//
//  ResultadoListaCryptoViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 6/07/22.
//

import UIKit

class ResultadoListaCryptoViewController: UIViewController {

    var productosFiltrados: [Crypto]?
    let alertaClass = MensajeAlert()
    
    @IBOutlet weak var detalleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detalleTableView.dataSource = self
        detalleTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    

}

extension ResultadoListaCryptoViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let cryptos = productosFiltrados else{
            return 0
        }
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "cellResultado", for: indexPath) as? ResultadoListaTableViewCell else {
            fatalError("Sin servicio")
        }
        let crypto = productosFiltrados![indexPath.row]
        cell.detalleImageCell.kf.setImage(with: URL(string: crypto.image))
        cell.detalleSimboloCell.text =  crypto.name + " (" + crypto.symbol.uppercased() + ")"
        cell.detallePrecioCell.text = crypto.currentPrice.conversionPrecio()
        
        let porcentajeString :String = String (format: "%.3f", crypto.priceChangePercentage24h)
        cell.detallePorcentajeCell.text = porcentajeString + "%"
        if(porcentajeString.contains("-")){
            cell.detallePorcentajeCell.textColor = UIColor.red} else {
                cell.detallePorcentajeCell.textColor = UIColor.init(red: 0.05, green: 0.46, blue: 0.13, alpha: 0.93)
            }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleViewController") as? DetalleViewController
        
        guard let cryptoNoticia: NoticiaCrypto =  filtroNoticia(productosFiltrados![indexPath.row].name) else {
            
            self.present(alertaClass.crearMensajeAlert(titulo: "UPS", mensaje: "Por el momento no hay data sobre esta crypto, espera las siguientes actualizaciones", tituloBoton: "OK"), animated: true, completion: nil)
            return
        }
        
        vc?.simbolo =  productosFiltrados![indexPath.row].symbol
        vc?.image = productosFiltrados![indexPath.row].image
        vc?.nombre =  productosFiltrados![indexPath.row].name
        vc?.precio = String(productosFiltrados![indexPath.row].currentPrice.conversionPrecio())
        vc?.cambioPrecio = String (format: "%.3f", productosFiltrados![indexPath.row].priceChangePercentage24h)
        vc?.tituloNoticia = cryptoNoticia.titulo
        vc?.detalleNoticia = cryptoNoticia.detalleNoticia
        vc?.fechaNoticia = cryptoNoticia.fechaNoticia
        self.navigationController?.pushViewController(vc!, animated: true)
    }
   
    func filtroNoticia(_ nombre: String) -> NoticiaCrypto?{
        
        let detalle: DetalleRepository?
        detalle = DetalleLocalRepository()
        guard let variable = detalle?.getDetalle() else { return nil}
        for crypto in variable.crypto{
            if (crypto.nombre.lowercased() == nombre.lowercased()){
                return crypto
            }
        }
        return nil
    }
    
}
