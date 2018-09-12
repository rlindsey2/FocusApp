//
//  NewCountdownVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 28/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class NewCountdownVC: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UILabel!
    
    var level = 0
    
    private let numberOfSelectors = 3
    private let countdownTime = 1.5
    private var timer: Timer!
    private var indexNumber = 0
    private var screensToShow = [CountdownPage]()
    private var previousNumbers = [UInt32]()
    
    let options: [CountdownPage] = [
        CountdownPage(image: "icon_headphones", text: "HEADPHONES ON"),
        CountdownPage(image: "icon_eyesclosed", text: "EYES CLOSED"),
        CountdownPage(image: "icon_nodistractions", text: "NO DISTRACTIONS"),
        CountdownPage(image: "icon_breathe", text: "BREATHE"),
        CountdownPage(image: "icon_relax", text: "RELAX")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        for _ in 1...numberOfSelectors {
            pickCountdown()
        }
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(countdownTime), target: self, selector: #selector(changeDetails), userInfo: nil, repeats: true)
        text.addCharacterSpacing(kernValue: 2)
    }
    

    private func setupView() {
        setCustomLightBackgroundImage()
    }
    
    
    @objc private func changeDetails() {
        indexNumber += 1
        
        if indexNumber <= (screensToShow.count - 1) {
            image.image = UIImage(named: screensToShow[indexNumber].image)
            text.text = screensToShow[indexNumber].text
        }
        
        if indexNumber == (screensToShow.count) {
            timer.invalidate()
            performSegue(withIdentifier: "NewCountdownToSession", sender: nil)
        }
        text.addCharacterSpacing(kernValue: 2)
    }
    
    
    private func pickCountdown() {
        
        var randomNumber = arc4random_uniform(5)
        while previousNumbers.contains(randomNumber)  {
            randomNumber = arc4random_uniform(5)
        }
        
        previousNumbers.append(randomNumber)
        screensToShow.append(options[Int(randomNumber)])
        image.image = UIImage(named: screensToShow[indexNumber].image)
        text.text = screensToShow[indexNumber].text
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewCountdownToSession" {
            if let destinationViewController = segue.destination as? SessionInProgressVC {
                destinationViewController.level = level
                destinationViewController.session = ListOfLevels.sharedInstance.allLevels[level]
                
            }
        }
    }
}
