//
//  DetalleListaTableViewCell.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 6/07/22.
//

import UIKit

class ResultadoListaTableViewCell: UITableViewCell {

//    @IBOutlet weak var detalleImageCell: UIImageView!
//    @IBOutlet weak var detalleSimboloCell: UILabel!
//    @IBOutlet weak var detallePorcentajeCell: UILabel!
//    @IBOutlet weak var detallePrecioCell: UILabel!
    
    @IBOutlet weak var detalleImageCell: UIImageView!

    @IBOutlet weak var detallePorcentajeCell: UILabel!
    @IBOutlet weak var detallePrecioCell: UILabel!
    @IBOutlet weak var detalleSimboloCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
