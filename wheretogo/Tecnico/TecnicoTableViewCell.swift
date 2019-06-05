//
//  TecnicoTableViewCell.swift
//  wheretogo
//
//  Created by Lobarinhas on 05/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit

class TecnicoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMorada: UILabel!
    @IBOutlet weak var lblData: UILabel!
    @IBOutlet weak var lblServico: UILabel!
    @IBOutlet weak var btnConcluido: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCancelar.backgroundColor = .clear
        btnCancelar.layer.cornerRadius = 5
        btnCancelar.layer.borderWidth = 1
        btnCancelar.layer.borderColor = UIColor.red.cgColor
        
        btnCancelar.backgroundColor = .clear
        btnCancelar.layer.cornerRadius = 5
        btnCancelar.layer.borderWidth = 1
        btnCancelar.layer.borderColor = UIColor.init(red: 0, green: 122, blue: 255, alpha: 1).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
