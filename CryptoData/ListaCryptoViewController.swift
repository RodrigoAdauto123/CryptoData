//
//  ListaCryptoViewController.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 24/06/22.
//

import UIKit
import FirebaseAuth
import Kingfisher
import FirebaseFirestore
import FirebaseFirestoreSwift

class ListaCryptoViewController: UIViewController {

    
    let db = Firestore.firestore()
    
    @IBAction func HistorialCryptoButton(_ sender: Any) {
        if let historialCrypto = storyboard?.instantiateViewController(withIdentifier: "HistorialCryptoTableViewController") as? HistorialCryptoTableViewController{
            
            db.collection("Usuarios").document(userDefaults.object(forKey: "email") as! String).getDocument(as: Usuario.self) { result in
                switch result{
                case .success(let usuario):
                    historialCrypto.usuario = usuario
                    self.navigationController?.pushViewController(historialCrypto, animated: true)
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
            
    }
    @IBOutlet weak var listaCrypto: UITableView!
    var cryptoList: [Crypto]?
    var backupCryptoList: [Crypto] = []
    
    var email: String?
    let userDefaults = UserDefaults.standard
    let alertaClass = MensajeAlert()
    
    var searchController: UISearchController!
    private var resultadoCryptoTableViewController: ResultadoCryptoTableViewController?
    var filteredCrypto = [Crypto]()
    
    @IBAction func cerrarSesionBarButton(_ sender: Any) {
        do {
           try Auth.auth().signOut()
            
            //Borrando los datos de sesion
            userDefaults.removeObject(forKey: "email")
            userDefaults.synchronize()
            
            if let inicio = storyboard?.instantiateViewController(withIdentifier: "LogueoViewController"){
                
                navigationController?.pushViewController(inicio, animated: false)
            }
            
        } catch {
            present(alertaClass.crearMensajeAlert(titulo: "UPS!", mensaje: "Ocurrio un error", tituloBoton: "Intentare de nuevo"), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cryptomonedas"
        
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        // Configurarndo el UISearchController
        resultadoCryptoTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultadoCryptoTableViewController") as? ResultadoCryptoTableViewController
        
        resultadoCryptoTableViewController?.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultadoCryptoTableViewController)
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        listaCrypto.dataSource = self
        listaCrypto.delegate = self
        if let _ = userDefaults.string(forKey: "email"){
        } else {
            //Guardamos el correo
            userDefaults.set(email, forKey: "email")
            userDefaults.synchronize()
        }
        
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
                self.backupCryptoList = listaCrypto
                self.listaCrypto.reloadData()
            }
        }
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
            cell.porcentajeCrypto.textColor = UIColor.red} else {
                cell.porcentajeCrypto.textColor = UIColor.init(red: 0.05, green: 0.46, blue: 0.13, alpha: 0.93)
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc: DetalleViewController?
        if tableView == self.listaCrypto{
             
            vc = envioDatos(listaCryptos: cryptoList, indexPath: indexPath)
        }else{
            
            vc = envioDatos(listaCryptos: resultadoCryptoTableViewController?.productosFiltrados, indexPath: indexPath)
        }
        if let vc = vc{
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
extension ListaCryptoViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

extension ListaCryptoViewController: UISearchResultsUpdating, UISearchControllerDelegate{
    
    
        func updateSearchResults(for searchController: UISearchController) {
            
            filteredCrypto =  filterContentForSearchText(searchController.searchBar.text!)
            
            if let resultsController = searchController.searchResultsController as? ResultadoCryptoTableViewController {
                resultsController.productosFiltrados = filteredCrypto
                resultsController.tableView.reloadData()
            }
        }
    
    func filterContentForSearchText(_ searchText: String) -> [Crypto] {
       
        filteredCrypto = (cryptoList?.filter({ (crypto: Crypto) -> Bool in
            return crypto.name.lowercased().contains(searchText.lowercased())
        }))!
      
        return filteredCrypto
    }
    
    func envioDatos(listaCryptos: [Crypto]?, indexPath: IndexPath) -> DetalleViewController?{
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleViewController") as? DetalleViewController
        if let listaCryptos = listaCryptos{
            
            guard let cryptoNoticia: NoticiaCrypto =  filtroNoticia(listaCryptos[indexPath.row].name) else {
                
                self.present(alertaClass.crearMensajeAlert(titulo: "UPS", mensaje: "Por el momento no hay data sobre esta crypto, espera las siguientes actualizaciones", tituloBoton: "OK"), animated: true, completion: nil)
                return nil
            }
            vc?.simbolo =  listaCryptos[indexPath.row].symbol
            vc?.image = listaCryptos[indexPath.row].image
            vc?.nombre =  listaCryptos[indexPath.row].name
            vc?.precio = String(listaCryptos[indexPath.row].currentPrice)
            vc?.precioFormateado = String(listaCryptos[indexPath.row].currentPrice.conversionPrecio())
            vc?.cambioPrecio = String (format: "%.3f", listaCryptos[indexPath.row].priceChangePercentage24h)
            vc?.tituloNoticia = cryptoNoticia.titulo
            vc?.detalleNoticia = cryptoNoticia.detalleNoticia
            vc?.fechaNoticia = cryptoNoticia.fechaNoticia
            
        }
        return vc
    }
}

