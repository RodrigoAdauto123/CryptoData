

import Foundation

class DetalleLocalRepository: DetalleRepository{
    
    func getDetalle() -> DetalleResponse? {
        guard let data = loadData("detalle_success_response") else {
            fatalError("No se cargaron los archivos")
        }
        
        let decoder = JSONDecoder()
        return try! decoder.decode(DetalleResponse.self, from: data)
    }
    
    func loadData(_ nombre: String) -> Data?{
        guard let url = Bundle.main.url(forResource: nombre, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
}
