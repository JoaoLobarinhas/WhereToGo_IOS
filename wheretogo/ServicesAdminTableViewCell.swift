//
//  ServicesAdminTableViewCell.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 05/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialButtons
import MaterialComponents.MaterialButtons_Theming

class ServicesAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRealocar: MDCButton!
    @IBOutlet weak var btnCancelar: MDCButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        let containerScheme = MDCContainerScheme()
        containerScheme.colorScheme.primaryColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        btnRealocar.applyContainedTheme(withScheme: containerScheme)
        btnCancelar.applyOutlinedTheme(withScheme: containerScheme)
        btnCancelar.setBorderColor(UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var labelMorada: UILabel!
    @IBOutlet weak var labelData: UILabel!
    @IBOutlet weak var labelDesc: UILabel!
    @IBOutlet weak var labelEstado: UILabel!
    
    @IBOutlet weak var imageUser: UIImageView!
    
    
    

}
