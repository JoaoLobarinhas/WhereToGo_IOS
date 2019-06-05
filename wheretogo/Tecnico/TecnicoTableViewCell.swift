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
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelServico: UILabel!
    @IBOutlet weak var labelEstado: UILabel!
    @IBOutlet weak var btnConcluido: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    @IBOutlet weak var imageEstado: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnCancelar.backgroundColor = .clear
        btnCancelar.layer.cornerRadius = 5
        btnCancelar.layer.borderWidth = 1
        btnCancelar.layer.borderColor = UIColor.red.cgColor
        
        btnConcluido.backgroundColor = .clear
        btnConcluido.layer.cornerRadius = 5
        btnConcluido.layer.borderWidth = 1
        btnConcluido.layer.borderColor = UIColor.blue.cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
