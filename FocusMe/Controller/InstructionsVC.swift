//
//  InstructionsVCViewController.swift
//  FocusMe
//
//  Created by ryan lindsey on 28/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class InstructionsVC: UIViewController {

    @IBOutlet weak var actionButton: RectangleActionButton!
    
    @IBOutlet weak var text: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.greenBorder()
        
        text.text = "Increase your focus to enhance your life.\n\n1. Focus on the dings and keep count of how many you hear. \n\n2. At the end of each session, enter the number of dings you counted and see how focused you were.\n\n3. Improve your focus with every session."
        
    }
 
}