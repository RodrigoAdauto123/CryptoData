//
//  Double.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 25/06/22.
//

import Foundation

extension Double{
    
    
    private var formatoDoublePrecio: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 5 
        return formatter
    }
    
    
    func conversionPrecio() -> String{
        let number = NSNumber(value: self)
        return formatoDoublePrecio.string(from: number) ?? "$0.00"
    }
    
}
