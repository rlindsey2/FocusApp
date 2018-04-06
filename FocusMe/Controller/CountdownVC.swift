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
    
    @IBOutlet weak var topLineLabel: UILabel!
    @IBOutlet weak var countdownImage: UIImageView!
    
    private var text = "Put your \nheadphones on."

    private var countDownStartingNumber = 3
    private let countDownTimeInterval = 1.5
    private var timer: Timer?
    
    private var countDownCurrentValue: Int {
        if countDownStartingNumber <= 1 {
            invalidateTimer()
            return 0
        }
        
        return countDownStartingNumber
    }
    
    private let music = MusicLogic()
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomLightBackgroundImage()
        
        let returningHeaderMutableString = NSMutableAttributedString(
            string: text,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Avenir-Light",
                size: 32.0)!])
        returningHeaderMutableString.addAttribute(
            NSAttributedStringKey.font,
            value: UIFont(
                name: "Avenir-Medium",
                size: 32.0)!,
            range: NSRange(
                location: 9,
                length: 14))
        
        topLineLabel.attributedText = returningHeaderMutableString
        topLineLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let countDownTime = Double(countDownStartingNumber) * countDownTimeInterval
        Timer.scheduledTimer(timeInterval: TimeInterval(countDownTime),
                             target: self,
                             selector: #selector(self.segue),
                             userInfo: nil,
                             repeats: false)
        
        
        /*
         Delete core data
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSession")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext?.execute(batchDeleteRequest)
            
        } catch {
            // Error Handling
        }
         */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        count()
    }
    
    func count() {
        
        invalidateTimer()
        
        if countDownStartingNumber == 0 {
            updateText(value: 0)
            return
        }
        
        timer = Timer.scheduledTimer(timeInterval: countDownTimeInterval,
                                     target: self,
                                     selector: #selector(updateValue),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateValue() {
        countDownStartingNumber -= 1
        updateText(value: countDownCurrentValue)
        
    }
    
    func updateText(value: Int) {

        if countDownStartingNumber == 2 {
            text = "Close your eyes \nfor \(Int(round(music.backgroundSoundPlayer.duration / 60))) min."
            let countdown2 = NSMutableAttributedString(
                string: text,
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
            
            let imageName = "Countdown 2.png"
            let image = UIImage(named: imageName)
            countdownImage.image = image
        }
        if countDownStartingNumber == 1 {
            
            text = "Count the \nchimes you hear."
            let countdown3 = NSMutableAttributedString(
                string: text,
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
            
            let imageName = "Countdown 1.png"
            let image = UIImage(named: imageName)
            countdownImage.image = image
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
