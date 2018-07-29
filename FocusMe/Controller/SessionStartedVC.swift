//
//  SessionStartedVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 03/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class SessionStartedVC: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var playPauseButtonOutlet: RectangleActionButton!
    @IBOutlet weak var headerText: UILabel!
    
    var music = MusicLogic()
    private var countdownTimer = Timer()
    private var textForHeader = "Focus session\nin progress."
    
    var managedObjectContext: NSManagedObjectContext?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.timerDuration = music.seconds
        progressView.start()
        
        self.setCustomDarkBackgroundImage()
        
        let updatedHeaderText = NSMutableAttributedString(
            string: textForHeader,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Avenir-Light",
                size: 32.0)!])
        updatedHeaderText.addAttribute(
            NSAttributedStringKey.font,
            value: UIFont(
                name: "Avenir-Medium",
                size: 32.0)!,
            range: NSRange(
                location: 14,
                length: 12))
        headerText.attributedText = updatedHeaderText
        headerText.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        countdown.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        music.playPause()
        playPauseButtonOutlet.setTitle("Pause", for: .normal)
        playPauseButtonOutlet.whiteBorder()
        headerText.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        runTimer()
        
        countdown.text = music.timeString(time: TimeInterval(music.seconds))
      
    }
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        //music.playPause()
        
        if music.playingState != true {
            music.playPause()
            progressView.start()
            
            playPauseButtonOutlet.setTitle("Pause", for: .normal)
            runTimer()
    
        } else {
            music.playPause()
            progressView.pause()
            
            playPauseButtonOutlet.setTitle("Play", for: .normal)
            countdownTimer.invalidate()
            
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        countdownTimer.invalidate()
        music.backgroundSoundPlayer.stop()
        music.timer.invalidate()
        saveToHK()
        Analytics.logEvent("session_cancelled", parameters: [
            "session_length" : music.backgroundSoundPlayer.currentTime
            ])
        
        performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
    
    func runTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateCountdown)), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        if music.seconds == 0 {
            countdownTimer.invalidate()
            performSegue(withIdentifier: "sessionToGuess", sender: nil)
        } else {
            music.seconds -= 1
            countdown.text = music.timeString(time: TimeInterval(music.seconds))
        }
    }
    
    private func authorizeHealthKit() {
        
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }
    }
    
    private func saveToHK() {
    
        let startTime = Date() - (music.backgroundSoundPlayer.currentTime)
        let endTime = Date()
        ProfileDataStore.saveMindfulSession(startDate: startTime, endDate: endTime)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bellCountActual = music.bellCount
        if let destinationViewController = segue.destination as? InputGuessVC {
            var eventCount = 0
            if eventCount < 1 {
                Analytics.logEvent("session_complete", parameters: nil)
                eventCount += 1
            }
            
            saveToHK()
            destinationViewController.bellCountActual = bellCountActual
            destinationViewController.managedObjectContext = managedObjectContext
        }
    }
}
