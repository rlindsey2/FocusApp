//
//  CircleView.swift
//  FocusMe
//
//  Created by ryan lindsey on 26/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class CircleView: UIView {

    var path: UIBezierPath!

 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    
    override func draw(_ rect: CGRect) {

        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(3 * Double.pi / 2)
        let centerPoint = CGPoint(x: frame.width/2 , y: frame.height/2)
        self.path = UIBezierPath(arcCenter:centerPoint, radius: frame.width/1.5 - 30.0, startAngle:startAngle, endAngle:endAngle, clockwise: true)
        
        path.lineWidth = 1
        UIColor(white: 1, alpha: 0.5).setStroke()
        UIColor.clear.setFill()
        path.fill()
        path.stroke()
    }
}
