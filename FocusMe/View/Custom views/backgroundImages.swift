//
//  designElements.swift
//  FocusMe
//
//  Created by ryan lindsey on 27/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func setCustomLightBackgroundImage(){
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_gradient_light.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setCustomDarkBackgroundImage(){
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background_gradient_dark.png")
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
}
