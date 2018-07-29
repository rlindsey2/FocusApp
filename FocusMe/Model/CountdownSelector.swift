//
//  PickCountdown.swift
//  FocusMe
//
//  Created by ryan lindsey on 28/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

struct CountdownPage {
    let image: String
    let text: String
}

class CountdownSelector {
    
    let numberOfSelectors = 3
    let countdownTime = 2
    var indexNumber = 0
    var screensToShow = [CountdownPage]()
    private var previousNumbers = [UInt32]()
    let vc = NewCountdownVC()
    var image = ""
    var textvc = ""
    
    init() {
        
        for _ in 1...numberOfSelectors {
            pickCountdown()
        }
        print(screensToShow[indexNumber].image)
        image = screensToShow[indexNumber].image
        textvc = screensToShow[indexNumber].text
        
        while indexNumber < screensToShow.count {
            let countdownTimer = Timer(timeInterval: TimeInterval(countdownTime), target: self, selector: #selector(changeDetails), userInfo: nil, repeats: true)
            
            if indexNumber == screensToShow.count {
                countdownTimer.invalidate()
            }
        }
    }
    
    @objc func changeDetails() {
        indexNumber += 1
        image = screensToShow[indexNumber].image
        textvc = screensToShow[indexNumber].text
    }
    
    func pickCountdown() {
        
        var randomNumber = arc4random_uniform(5)
        while previousNumbers.contains(randomNumber)  {
            randomNumber = arc4random_uniform(5)
        }
        
        previousNumbers.append(randomNumber)
        screensToShow.append(vc.options[Int(randomNumber)])
    }
    
}
