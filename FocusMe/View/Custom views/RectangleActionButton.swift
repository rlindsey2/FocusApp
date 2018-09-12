//
//  RectangleActionButton.swift
//  FocusMe
//
//  Created by ryan lindsey on 10/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class RectangleActionButton: UIButton {

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
        self.translatesAutoresizingMaskIntoConstraints = false
        let buttonHeight = CGFloat(55)
        self.widthAnchor.constraint(equalToConstant: 250).isActive = true
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.layer.cornerRadius = buttonHeight / 2
        self.layer.borderWidth = 2
    }
    

    func greenBorder() {
        self.layer.borderColor = #colorLiteral(red: 0.2745098039, green: 0.9333333333, blue: 0.6509803922, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1), for: .normal)
    }
    

    func whiteBorder() {
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
}


