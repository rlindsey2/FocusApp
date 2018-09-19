//
//  LoadingBar.swift
//  FocusMe
//
//  Created by ryan lindsey on 02/07/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class ProgressBar: UIView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
         layer.cornerRadius = 8
    }


    func animation(width: Int, unlocked: Bool, completion: (() -> Swift.Void)? = nil) {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            
            self.frame.size.width = CGFloat(width)
            
        }, completion: { (finished) in
            print(unlocked)
            if unlocked == true {
                    completion?()
            }
        })
    }
}


class fadeInImage: UIImageView {
    //TODO: change so these are functions that take a UIElement in rather than being a class of type. Might make it easier with multiple animation types. Example: http://www.dwstroud.com/fading-in-a-uiimageview-in-swift/
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    
    func animation(height: Int) {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            
            self.frame.origin.y -= CGFloat(30)
            self.alpha = 0
           
        }, completion: { (finished) in
            print("animation finshed!")
        })
    }
}



