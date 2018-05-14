//
//  CountdownOneVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 03/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import  CoreData

class CountdownVC: UIViewController {
    
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var topLineLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
 
    private var headerText = "Put your \nheadphones on."
    private var countDownNumber = 3
    
    private var timer: Timer?
    private let music = MusicLogic()
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCustomLightBackgroundImage()
        setTimer()
        
        let headerMutableString = NSMutableAttributedString(
            string: headerText,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Avenir-Light",
                size: 32.0)!])
        headerMutableString.addAttribute(
            NSAttributedStringKey.font,
            value: UIFont(
                name: "Avenir-Medium",
                size: 32.0)!,
            range: NSRange(
                location: 9,
                length: 14))
        
        topLineLabel.attributedText = headerMutableString
        topLineLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func setTimer() {
        let countDownTimeInterval = 1.9
        invalidateTimer()
        
        timer = Timer.scheduledTimer(timeInterval: countDownTimeInterval,
                                     target: self,
                                     selector: #selector(updateValue),
                                     userInfo: nil,
                                     repeats: true)
        setupProgressBar()
    }
 
    
    @objc private func setupProgressBar() {
        progressBar.resetAnimation()
        progressBar.timerDuration = Int(6)
        progressBar.start()
    }
    

    @objc func updateValue() {

        countDownNumber -= 1
        
        if countDownNumber == 2 {
            headerText = "Close your eyes \nfor \(Int(round(music.backgroundSoundPlayer.duration / 60))) min."
            let countdown2 = NSMutableAttributedString(
                string: headerText,
                attributes: [NSAttributedStringKey.font:UIFont(
                    name: "Avenir-Light",
                    size: 32.0)!])
            countdown2.addAttribute(
                NSAttributedStringKey.font,
                value: UIFont(
                    name: "Avenir-Medium",
                    size: 32.0)!,
                range: NSRange(
                    location: 16,
                    length: 11))
            
            topLineLabel.attributedText = countdown2
            numberLabel.text = String(countDownNumber)
        }
        
        if countDownNumber == 1 {
            
            headerText = "Count the \nchimes you hear."
            let countdown3 = NSMutableAttributedString(
                string: headerText,
                attributes: [NSAttributedStringKey.font:UIFont(
                    name: "Avenir-Light",
                    size: 32.0)!])
            countdown3.addAttribute(
                NSAttributedStringKey.font,
                value: UIFont(
                    name: "Avenir-Medium",
                    size: 32.0)!,
                range: NSRange(
                    location: 11,
                    length: 15))
            
            topLineLabel.attributedText = countdown3
            numberLabel.text = String(countDownNumber)
        }
        
        if countDownNumber == 0 {
            
            invalidateTimer()
            self.segue()
        }
    }
    
    func invalidateTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc func segue() {
        performSegue(withIdentifier: "CountdownToSession", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let destinationViewController = segue.destination as? SessionStartedVC {
        
                destinationViewController.managedObjectContext = managedObjectContext
        }
    }
}
