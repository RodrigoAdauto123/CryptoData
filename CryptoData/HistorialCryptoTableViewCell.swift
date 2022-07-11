//
//  HistorialCryptoTableViewCell.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 11/07/22.
//

import UIKit

class HistorialCryptoTableViewCell: UITableViewCell {

    @IBOutlet weak var tipoCompraHistorial: UILabel!
    @IBOutlet weak var precioCryptoHistorial: UILabel!
    @IBOutlet weak var cantidadCryptoHistorial: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
