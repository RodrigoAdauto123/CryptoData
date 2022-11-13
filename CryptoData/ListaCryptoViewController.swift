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
           
    @IBOutlet weak var listaCrypto: UITableView!
    
    var cryptoList: [Crypto]?
    var backupCryptoList: [Crypto] = []
    var email: String?
    var searchController: UISearchController!
    var filteredCrypto = [Crypto]()
    private var resultadoCryptoTableViewController: ResultadoCryptoTableViewController?
    let listaRepository: CryptoRepository
    let userDefaults = UserDefaults.standard
    let alertaClass = MensajeAlert()
    let detalle: DetalleRepository?
    
    
    enum Constant {
        static let buttonMessageLogOut = "Ocurrio un error"
        static let buttonMessageTitleLogOut = "Intentare de nuevo"
        static let alertMessageNew = "Por el momento no hay data sobre esta crypto, espera las siguientes actualizaciones"
    }
    
    init?(coder: NSCoder, listaRepository: CryptoRepository, detalleRepository: DetalleRepository) {
        self.listaRepository = listaRepository
        self.detalle =  detalleRepository
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func cerrarSesionBarButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            // Delete session data
            userDefaults.removeObject(forKey: "email")
            userDefaults.synchronize()
            if let inicio = storyboard?.instantiateViewController(withIdentifier: "LogueoViewController"){
                navigationController?.pushViewController(inicio, animated: false)
            }
            
        } catch {
            present(alertaClass.crearMensajeAlert(titulo: "UPS!", mensaje: Constant.buttonMessageLogOut, tituloBoton: Constant.buttonMessageTitleLogOut), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cryptomonedas"
        setUpHideBackNavigationItem()
        // Configurarndo el UISearchController
        setSearchController()
        setUpNavigationItem()
        listaCrypto.dataSource = self
        listaCrypto.delegate = self
        saveDataUserDefaults()
        
    }
    
    private func saveDataUserDefaults(){
        if let _ = userDefaults.string(forKey: "email"){
        } else {
            //Guardamos el correo
            userDefaults.set(email, forKey: "email")
            userDefaults.synchronize()
        }
    }
    
    private func setUpHideBackNavigationItem(){
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setUpNavigationItem(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func setSearchController () {
        resultadoCryptoTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultadoCryptoTableViewController") as? ResultadoCryptoTableViewController
        resultadoCryptoTableViewController?.tableView.delegate = self
        searchController = UISearchController(searchResultsController: resultadoCryptoTableViewController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Data reload
        if animated == true{
            self.listaCrypto.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //        listaRepository = CryptoRemoteRepository()
        //        listaRepository.getCrypto { listaCrypto in
        //            if let listaCrypto = listaCrypto{
        //                self.cryptoList = listaCrypto
        //                self.backupCryptoList = listaCrypto
        //                self.listaCrypto.reloadData()
        //            }
        //        }
        listaRepository.getCrypto { listaCrypto in
            if let listaCrypto = listaCrypto {
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetalleViewController") as? DetalleViewController
        guard let cryptoNoticia: NoticiaCrypto =  filtroNoticia(cryptoList![indexPath.row].name) else {
            self.present(alertaClass.crearMensajeAlert(titulo: "UPS", mensaje: Constant.alertMessageNew, tituloBoton: "OK"), animated: true, completion: nil)
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
        
        
//        detalle = DetalleLocalRepository()
//        guard let variable = detalle?.getDetalle() else { return nil}
//        for crypto in variable.crypto{
//            if (crypto.nombre.lowercased() == nombre.lowercased()){
//                return crypto
//            }
//        }
        
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
}

