//
//  NewSessionInProgressVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 30/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class SessionInProgressVC: UIViewController {

    @IBOutlet weak var progressView: ProgressView!
    @IBOutlet weak var durationLeft: UILabel!
    @IBOutlet weak var ctaButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    
    var level = 0
    var session = ListOfLevels.sharedInstance.allLevels[0]
    private var timer = Timer()
    
    lazy var audio = MyAudioPlayer(randomUpperNumberDifficulty: self.session.randomUpperNumberDifficulty, randomLowerNumberDifficulty: self.session.randomLowerNumberDifficulty, backgroundResource: self.session.backgroundSound, dingResource: self.session.dingSound, duration: self.session.duration)
    
    
    lazy var audioDuration = audio.backgroundSoundPlayer.duration
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        audio.play()
        runTimer()
    }
    
    
    @objc func longPressHappened(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let secretAlert = UIAlertController(title: "Secret popup", message: "To test functionality you can skip the session.", preferredStyle: UIAlertController.Style.alert)
            let skipAhead = UIAlertAction(title: "Skip ahead", style: UIAlertAction.Style.default) { (alert) in
                self.timer.invalidate()
                self.audio.pause()
                self.segueNowSessionIsOver()
            }
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) { (alert) in
                print("Cancel pressed")
            }
            
            secretAlert.addAction(skipAhead)
            secretAlert.addAction(cancel)
            self.present(secretAlert, animated: true, completion: nil)
        }
    }
    
    
    private func setupView() {
        setCustomLightBackgroundImage()
        //long hold to skip session for testing
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressHappened(_:)))
        recognizer.minimumPressDuration = 4
        view.addGestureRecognizer(recognizer)
        
        //show or hide skip button
        if level != 0 {
            skipButton.isHidden = true
        }
        
        progressView.timerDuration = audio.seconds
        progressView.start()
    }
    
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateDurationLeft), userInfo: nil, repeats: true)
        durationLeft.text = audio.timeString(time:  audio.backgroundSoundPlayer.duration - audio.backgroundSoundPlayer.currentTime)
    }
    
    
    @objc private func updateDurationLeft() {
        
        if (audioDuration - audio.backgroundSoundPlayer.currentTime) > 1 {
            durationLeft.text = audio.timeString(time:  audio.backgroundSoundPlayer.duration - audio.backgroundSoundPlayer.currentTime)
            
        } else {
            durationLeft.text = audio.timeString(time: 0)
            timer.invalidate()
            audio.pause()
            segueNowSessionIsOver()
        }
    }
    
    
    private func segueNowSessionIsOver() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            if result.count == 0 {
                
                let entity = NSEntityDescription.entity(forEntityName: "SavedSessionV2", in: context)
                let newSession = NSManagedObject(entity: entity!, insertInto: context)
                
                newSession.setValue(Date(), forKey: "date")
                newSession.setValue(ListOfLevels.sharedInstance.allLevels[level].name, forKey: "level")
                
                do {
                    try context.save()
                } catch {
                    print("failed saving")
                }
                
                performSegue(withIdentifier: "unwindToHomeScreen", sender: self)
                
            } else {
                
                performSegue(withIdentifier: "sessionToScoreInput", sender: self)
            }
        } catch {
            print("Failed")
        }
    }
            
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        
        if audio.playingState == true {
            ctaButton.setImage(UIImage(named: "btn_play"), for: .normal)
            audio.pause()
            progressView.pause()
            timer.invalidate()
        } else {
            ctaButton.setImage(UIImage(named: "btn_pause"), for: .normal)
            audio.play()
            progressView.start()
            runTimer()
        }
    }
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        Analytics.logEvent("session_cancelled", parameters: [
            "session_length" : audio.backgroundSoundPlayer.currentTime
            ])
        timer.invalidate()
        audio.pause()
    }
    
    @IBAction func skipButton(_ sender: UIButton) {
        segueNowSessionIsOver()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sessionToScoreInput" {
            if let destinationViewController = segue.destination as? InputScoreVC {
                Analytics.logEvent("session_completed", parameters: nil)
                timer.invalidate()
                destinationViewController.level = level
                destinationViewController.bellCountActual = audio.bellCount
            }
        }
    }
}
