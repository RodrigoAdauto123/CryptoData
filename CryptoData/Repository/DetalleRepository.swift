//
//  DetalleRepository.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 2/07/22.
//

import Foundation

protocol DetalleRepository{
    func getDetalle() -> DetalleResponse?
}
