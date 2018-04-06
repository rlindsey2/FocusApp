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
    
    @IBOutlet weak var countdown: UILabel!
    @IBOutlet weak var playPauseButtonOutlet: RectangleActionButton!
    @IBOutlet weak var headerText: UILabel!
    
    var music = MusicLogic()
    private var countdownTimer = Timer()
    private var textForHeader = "Focus session\nin progress."
    
    var managedObjectContext: NSManagedObjectContext?
    
    private let circularPath = UIBezierPath(arcCenter: .zero, radius: 75, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
    private let trackLayer = CAShapeLayer()
    private let shapeLayer = CAShapeLayer()
    private let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    private let startValue = 0.02
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCustomDarkBackgroundImage()
        
        createCircle()
        createCircleOverlay()
        animateCircle()
        
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
    
    
    private func createCircle() {
        
        //create underlay circle
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.white.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
    }
    
    private func createCircleOverlay() {
        
        //set over the top circle
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = #colorLiteral(red: 0.1607843137, green: 0.6274509804, blue: 0.4274509804, alpha: 1)
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.position = view.center
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
    }
    
    @objc private func animateCircle() {
        
        let songDuration = CFTimeInterval(music.backgroundSoundPlayer.duration - music.backgroundSoundPlayer.currentTime)
        
        basicAnimation.fromValue = startValue
        basicAnimation.toValue = 1
        basicAnimation.duration = songDuration
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    @IBAction func playPauseButton(_ sender: UIButton) {
        music.playPause()
        
        if music.playingState == true {
            playPauseButtonOutlet.setTitle("Pause", for: .normal)
            runTimer()
            
            //start up the animcation from the current position to the end
            let songDuration = CFTimeInterval(music.backgroundSoundPlayer.duration - music.backgroundSoundPlayer.currentTime)
            let currentTime = music.backgroundSoundPlayer.currentTime
            let totalTime = music.backgroundSoundPlayer.duration
            let percentage = currentTime / totalTime
            basicAnimation.fromValue = percentage + startValue
            basicAnimation.toValue = 1
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.duration = songDuration
            shapeLayer.add(basicAnimation, forKey: "urSoBasic")
            
        } else {
            playPauseButtonOutlet.setTitle("Play", for: .normal)
            countdownTimer.invalidate()
            
            //pause animation
            let currentTime = music.backgroundSoundPlayer.currentTime
            let totalTime = music.backgroundSoundPlayer.duration
            let percentage = currentTime / totalTime
            basicAnimation.fromValue = percentage + startValue
            basicAnimation.toValue = percentage + startValue
            basicAnimation.isRemovedOnCompletion = false
            basicAnimation.duration = 0
            shapeLayer.add(basicAnimation, forKey: "urSoBasic")
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        countdownTimer.invalidate()
        
        music.backgroundSoundPlayer.stop()
        music.timer.invalidate()
        Analytics.logEvent("session_cancelled", parameters: [
            "time_left" : music.backgroundSoundPlayer.currentTime
            ])
        
        performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
    
    func runTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateCountdown)), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        
        //If countdown gets to zero, cancel countdown timer and segue to input their guess. Else keep counting down the timer and update the label.
        if music.seconds == 0 {
            
            countdownTimer.invalidate()
            performSegue(withIdentifier: "sessionToGuess", sender: nil)
            
        } else {
            music.seconds -= 1
            countdown.text = music.timeString(time: TimeInterval(music.seconds))
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bellCountActual = music.bellCount
        if let destinationViewController = segue.destination as? InputGuessVC {
            Analytics.logEvent("session_complete", parameters: nil)
            destinationViewController.bellCountActual = bellCountActual
            destinationViewController.managedObjectContext = managedObjectContext
        }
    }
}
