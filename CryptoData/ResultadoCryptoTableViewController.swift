//
//  ResultadoCryptoTableViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 6/07/22.
//

import UIKit

class ResultadoCryptoTableViewController: UITableViewController {

    var productosFiltrados: [Crypto]?
    let alertaClass = MensajeAlert()
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cryptomonedas"
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let cryptos = productosFiltrados else{return 0}
        return cryptos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "cellResultado", for: indexPath) as? ResultadoListaTableViewCell else {
            fatalError("Sin servicio")}
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

}
