//
//  MainVCResultCell.swift
//  FocusMe
//
//  Created by ryan lindsey on 10/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//


import UIKit
import CoreData

class MainVCResultCell: UITableViewCell {
    
    static let reuseIdentifier = "ResultCell"
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var trainingNumberLabel: UILabel!
    @IBOutlet weak var movingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        percentageLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        trainingNumberLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
}


