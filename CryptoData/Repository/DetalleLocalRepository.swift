

import Foundation

class DetalleLocalRepository: DetalleRepository{
    
    func getDetalle() -> DetalleResponse? {
        if let data = loadData("detalle_success_response") {
            let decoder = JSONDecoder()
            return try! decoder.decode(DetalleResponse.self, from: data)
        }
        return nil
    }
    
    func loadData(_ nombre: String) -> Data?{
        guard let url = Bundle.main.url(forResource: nombre, withExtension: "json") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
    
}
