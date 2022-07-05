    //
//  ListaTableViewCell.swift
//  CryptoData
//
//  Created by Rodrigo Alexander Adauto Ortiz on 25/06/22.
//

import UIKit

class ListaTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageViewCrypto: UIImageView!
    @IBOutlet weak var porcentajeCrypto: UILabel!
    @IBOutlet weak var simboloCrypto: UILabel!
    @IBOutlet weak var precioCrypto: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
