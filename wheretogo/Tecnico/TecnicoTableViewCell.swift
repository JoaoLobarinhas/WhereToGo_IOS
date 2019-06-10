//
//  TecnicoTableViewCell.swift
//  wheretogo
//
//  Created by Lobarinhas on 05/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class TecnicoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMorada: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelServico: UILabel!
    @IBOutlet weak var labelEstado: UILabel!
    @IBOutlet weak var btnConcluido: MDCButton!
    @IBOutlet weak var btnCancelar: MDCButton!
    
    @IBOutlet weak var imageEstado: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let containerScheme = MDCContainerScheme()
        containerScheme.colorScheme.primaryColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        btnConcluido.applyContainedTheme(withScheme: containerScheme)
        btnCancelar.applyOutlinedTheme(withScheme: containerScheme)
        btnCancelar.setBorderColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        
        btnConcluido.isUppercaseTitle = false
        btnCancelar.isUppercaseTitle = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
