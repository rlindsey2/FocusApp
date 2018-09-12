//
//  Kern.swift
//  FocusMe
//
//  Created by ryan lindsey on 11/09/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

extension UILabel {
    func addCharacterSpacing(kernValue: Double = 2) {
        if let labelText = text, labelText.count > 0 {
            let attributedString = NSMutableAttributedString(string: labelText)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
}



@IBDesignable class SpacedString: UILabel {
    
    @IBInspectable var kern: Double {
        get {
            return Double(2)
        }
        set {
            if let labelText = self.text, labelText.count > 0 {
                let attributedString = NSMutableAttributedString(string: labelText)
                attributedString.addAttribute(NSAttributedStringKey.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length - 1))
                attributedText = attributedString
            }
        }
    }
}
