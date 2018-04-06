//
//  calculatorButton.swift
//  FocusMe
//
//  Created by ryan lindsey on 31/03/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

@IBDesignable
class calculatorButton: UIButton {

    @IBInspectable var roundButton: Bool = false {
        didSet {
            if roundButton {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        if roundButton {
            layer.cornerRadius = frame.height / 2
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}
