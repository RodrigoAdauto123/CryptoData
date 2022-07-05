//
//  ListaCryptoViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 24/06/22.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ListaCryptoViewController: UIViewController {

    
    @IBOutlet weak var filtroListaCrypto: UITextField!
    @IBOutlet weak var listaCrypto: UITableView!
    var cryptoList: [Crypto]?
    var backupCryptoList: [Crypto] = []
    
    var email: String?
    let userDefaults = UserDefaults.standard
    
    @IBAction func cerrarSesionButton(_ sender: Any) {
        
        do {
           try Auth.auth().signOut()
            
            //Borrando los datos de sesion
            userDefaults.removeObject(forKey: "email")
            userDefaults.synchronize()
            
            navigationController?.popViewController(animated: true)
        } catch {
            //Mostrar mensaje de error al cerrar sesion
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        listaCrypto.dataSource = self
        listaCrypto.delegate = self
        
        
        if let _ = userDefaults.string(forKey: "email"){
            
        } else {
            
            //Guardamos el correo
            userDefaults.set(email, forKey: "email")
            userDefaults.synchronize()
        }
        
        
        
        
        
        filtroListaCrypto.addTarget(self, action: #selector(filtroLista(_:)), for: .editingChanged)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        // Cada vez que regresa hacia atras, se actualiza la lista de cryptomonedas
        if animated == true{
            self.listaCrypto.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let listaRepository: CryptoRepository
        listaRepository = CryptoRemoteRepository()
        listaRepository.getCrypto { listaCrypto in
            if let listaCrypto = listaCrypto{
                self.cryptoList = listaCrypto
                self.listaCrypto.reloadData()
                self.backupCryptoList = listaCrypto
            }
        }
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

extension ListaCryptoViewController: UITableViewDataSource, UITableViewDelegate{
    
    
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
        cell.imageViewCrypto.kf.setImage(with: URL(string: crypto.image))
        cell.simboloCrypto.text =  crypto.name + " (" + crypto.symbol.uppercased() + ")"
        
        
        
        cell.precioCrypto.text = crypto.currentPrice.conversionPrecio()
        
        let porcentajeString :String = String (format: "%.3f", crypto.priceChangePercentage24h)
        cell.porcentajeCrypto.text = porcentajeString + "%"
        if(porcentajeString.contains("-")){
            cell.porcentajeCrypto.textColor = UIColor.red     }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleViewController") as? DetalleViewController
        
        guard let cryptoNoticia: NoticiaCrypto =  filtroNoticia(cryptoList![indexPath.row].name) else { let alerta = UIAlertController(title: "UPS", message: "Por el momento no hay data sobre esta crypto, espera las siguientes actualizaciones.", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            return
        }
        
        vc?.simbolo =  cryptoList![indexPath.row].symbol
        vc?.image = cryptoList![indexPath.row].image
        vc?.nombre =  cryptoList![indexPath.row].name
        vc?.precio = String(cryptoList![indexPath.row].currentPrice.conversionPrecio())
        vc?.cambioPrecio = String (format: "%.3f", cryptoList![indexPath.row].priceChangePercentage24h)
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
