//
//  ListaCryptoViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 24/06/22.
//

import UIKit

class ListaCryptoViewController: UIViewController {

    @IBOutlet weak var filtroListaCrypto: UITextField!
    @IBOutlet weak var listaCrypto: UITableView!
    var cryptoList: [Crypto]?
    var backupCryptoList: [Crypto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listaCrypto.dataSource = self
//        listaCrypto.register(ListaTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        filtroListaCrypto.addTarget(self, action: #selector(filtroLista(_:)), for: .editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        requestModel()
    }
    
}

extension ListaCryptoViewController{
    
    @objc func filtroLista(_ filtro: UITextField){
        
        var listafiltrada: [Crypto] = []
        let texto = filtro.text ?? ""
        for crypto in backupCryptoList{
            if (crypto.name.lowercased().contains(texto.lowercased())){
                listafiltrada.append(crypto)
            }
        }
        cryptoList = (texto.count > 0) ? listafiltrada : backupCryptoList
        listaCrypto.reloadData()
    }
}

extension ListaCryptoViewController: UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let cryptos = cryptoList else{
            return 0
        }
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListaTableViewCell else {
            fatalError("Sin servicio")
        }
        
        let crypto = cryptoList![indexPath.row]
        cell.simboloCrypto.text =  crypto.name + " (" + crypto.symbol.uppercased() + ")"
        
        
        
        cell.precioCrypto.text = crypto.currentPrice.conversionPrecio()
        
        let porcentajeString :String = String (format: "%.3f", crypto.priceChange24h)
        cell.porcentajeCrypto.text = porcentajeString + "%"
        if(porcentajeString.contains("-")){
            cell.porcentajeCrypto.textColor = UIColor.red     }
        
       
        return cell
    }
    
    
}
