//
//  ServicesAdminTableViewCell.swift
//  wheretogo
//
//  Created by Carlos Pinheiro on 05/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit

class ServicesAdminTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
