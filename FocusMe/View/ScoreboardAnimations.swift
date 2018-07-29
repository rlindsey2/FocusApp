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
    

    func animation(width: Int, superViewWidth: Int, completion: (() -> Swift.Void)? = nil) {
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: {
            
            self.frame.size.width = CGFloat(width)
            
        }, completion: { (finished) in
            if width == superViewWidth {
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



class CountingLabel: UILabel {

    let startValue: Double
    let endValue: Double
    let animationDuration: Double
    let animationStartDate = Date()
    private var displayLink: CADisplayLink?
    
    
    init(startValue: Double, endValue: Double, animationDuration: Double){
        self.startValue = startValue
        self.endValue = endValue
        self.animationDuration = animationDuration
        super.init(frame: .zero)
        self.text = "\(startValue)"
        
        self.textColor = UIColor.white

        displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
        displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc func handleUpdate() {

        let now = Date()
        let elapsedTime = now.timeIntervalSince(animationStartDate)

        if elapsedTime > animationDuration {
            stopDisplayLink()
            self.text = "\(Int(endValue * 100))%"
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.text =  "\(Int(value * 100))%"
        }
    }


    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}
