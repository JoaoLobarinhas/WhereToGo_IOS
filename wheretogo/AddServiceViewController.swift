//
//  AddServiceViewController.swift
//  wheretogo
//
//  Created by Aluno on 11/06/2019.
//  Copyright © 2019 estg.ipvc. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextFields_Theming
import MaterialComponents.MaterialContainerScheme

class AddServiceViewController: UIViewController {

    let containerScheme = MDCContainerScheme()
    
    @IBOutlet weak var searchMorada: MDCTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchMorada.placeholder = "Morada"
        searchMorada.cursorColor = UIColor.init(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
