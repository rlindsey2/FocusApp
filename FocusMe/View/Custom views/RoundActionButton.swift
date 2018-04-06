//
//  ActionButton.swift
//  FocusMe
//
//  Created by ryan lindsey on 09/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class RoundActionButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonStyle()
    }
    
    override func awakeFromNib() {
        buttonStyle()
    }
    
    func buttonStyle() {
        self.layer.cornerRadius = 0.5 * self.bounds.size.height
        
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor(red: 59/255, green: 153/255, blue: 252/255, alpha: 0.2)
        self.setTitleColor(.white, for: .normal)
    }
}
