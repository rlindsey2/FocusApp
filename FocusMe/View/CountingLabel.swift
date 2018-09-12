//
//  CountingLabel.swift
//  FocusMe
//
//  Created by ryan lindsey on 07/08/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {
    
    var startValue: Double
    var endValue: Double
    var animationDuration: Double
    let percentage: Bool
    private let animationStartDate = Date()
    private var displayLink: CADisplayLink?
    
    
    init(startValue: Double, endValue: Double, animationDuration: Double, percentage: Bool){
        self.startValue = startValue
        self.endValue = endValue
        self.percentage = percentage
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
            switch percentage {
            case true:
                self.text = "\(Int(endValue * 100))%"
            case false:
                self.text = "\(Int(endValue))"
            }
        } else {
            let percentageComplete = elapsedTime / animationDuration
            let value = startValue + percentageComplete * (endValue - startValue)
            
            switch percentage {
            case true:
                self.text =  "\(Int(value * 100))%"
            case false:
                self.text =  "\(Int(value))"
            }
        }
    }
    
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
}
