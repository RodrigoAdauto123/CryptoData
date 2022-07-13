//
//  HistorialCryptoTableViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 11/07/22.
//

import UIKit

class HistorialCryptoTableViewController: UITableViewController {

    var usuario: Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Historial de compra y venta"
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let cantidadSecciones = usuario?.listaCrypto?.count else {return 0}
        
        
        return cantidadSecciones
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let cantidadFilas = usuario?.listaCrypto![section].historial?.count else {return 0}
        
        return cantidadFilas
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "historialCryptoCell", for: indexPath) as? HistorialCryptoTableViewCell else {
            fatalError("Sin servicio")
        }
        if let historial = usuario?.listaCrypto![indexPath.section].historial![indexPath.row]{
            
            cell.cantidadCryptoHistorial.text = String(historial.cantidad)
            cell.tipoCompraHistorial.text = String(historial.tipo)
            cell.precioCryptoHistorial.text = String(historial.precio.conversionPrecio())
            if(String(historial.tipo).contains("enta")){
                cell.precioCryptoHistorial.textColor = UIColor.red
                cell.tipoCompraHistorial.textColor = UIColor.red
                cell.cantidadCryptoHistorial.textColor = UIColor.red
            } else {
                cell.precioCryptoHistorial.textColor = UIColor.init(red: 0.05, green: 0.46, blue: 0.13, alpha: 0.93)
                cell.tipoCompraHistorial.textColor = UIColor.init(red: 0.05, green: 0.46, blue: 0.13, alpha: 0.93)
                cell.cantidadCryptoHistorial.textColor = UIColor.init(red: 0.05, green: 0.46, blue: 0.13, alpha: 0.93)
                }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        
        switch section{
        case 0...:
            
            guard let nombre = usuario?.listaCrypto![section].nombre, let cantidad = usuario?.listaCrypto![section].cantidadTotalCrypto else {return ""}
            return "\(nombre)/(USD) (Saldo: \(cantidad))"
        default:
            return " "
        }
    }
}
