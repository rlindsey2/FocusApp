//
//  NewAudioPlayer.swift
//  FocusMe
//
//  Created by ryan lindsey on 13/06/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import AVFoundation

class MyAudioPlayer {
    
    var backgroundSoundPlayer = AVAudioPlayer()
    var bellSoundPlayer = AVAudioPlayer()
    
    var timer = Timer()
    var bellCount = 0
    var playingState = true
    var trainingSession = true
    
    private let backgroundResource: String
    private let dingResource: String?
    private let randomUpperNumberDifficulty: UInt32
    private let randomLowerNumberDifficulty: UInt32
    private let duration: Int
    
    var seconds = Int()
    var countdownTimer = Timer()
    var countdownNumber = String()
    
    private var randomNumberInReset: Int?
    private var timerStartTime: Date?
    private var newTimerDuration = 0.0
    private var totalPauseTimePeriod = 0.0
    
    
    init(randomUpperNumberDifficulty: UInt32, randomLowerNumberDifficulty: UInt32, backgroundResource: String, dingResource: String?, duration: Int) {
        
        self.randomLowerNumberDifficulty = randomLowerNumberDifficulty
        self.randomUpperNumberDifficulty = randomUpperNumberDifficulty
        self.backgroundResource = backgroundResource
        self.dingResource = dingResource
        self.duration = duration
        
        
        let backgroundSoundURL = Bundle.main.url(forResource: backgroundResource, withExtension: "mp3")!
        let bellSoundURL = Bundle.main.url(forResource: dingResource, withExtension: "wav") ?? nil
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
            backgroundSoundPlayer = try AVAudioPlayer(contentsOf: backgroundSoundURL)
            
            if bellSoundURL != nil {
                bellSoundPlayer = try AVAudioPlayer(contentsOf: bellSoundURL!)
                bellSoundPlayer.volume = 0.8
                trainingSession = false
            }

            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
                
            } catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
        
        backgroundSoundPlayer.currentTime = backgroundSoundPlayer.duration - TimeInterval(duration)
        backgroundSoundPlayer.volume = 0
        //set countdown timer as duration of music minus the current time of the audio.
        seconds = Int(backgroundSoundPlayer.duration - backgroundSoundPlayer.currentTime)
    }
    
    
    @objc func playBellSound() {
        
        bellSoundPlayer.play()
        bellCount += 1
        
        totalPauseTimePeriod = 0
        print("Bell has sounded " + String(bellCount) + " times.")
        print("Bell sounded at " + String(describing: Date()))
        randomBellTimer()
    }
    
    
    func randomBellTimer() {
        randomNumberInReset = Int(arc4random_uniform(randomUpperNumberDifficulty) + randomLowerNumberDifficulty)
        
        let currentTimePlusRandomNumber = (Int(backgroundSoundPlayer.currentTime) + randomNumberInReset!)
        
        //Only make the bell sound if the total time is less than the background sound is still playing.
        if currentTimePlusRandomNumber < Int(backgroundSoundPlayer.duration) {
            
            print("Random number is:" + String(describing: randomNumberInReset!))
            self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(randomNumberInReset!), target: self, selector: #selector(playBellSound), userInfo: nil, repeats: false)
            timerStartTime = Date()
        } else {
            print("time has ended. Time to guess")
        }
    }
    
    func play() {
        
            //if new timer equals 0 play as normal. Else it's previously played and has been paused so set new time period to play.
            if newTimerDuration == 0 {
                backgroundSoundPlayer.play()
                backgroundSoundPlayer.setVolume(1, fadeDuration: 20)
                playingState = true
                if trainingSession == false {
                timerStartTime = Date()
                
                
                    randomBellTimer()
                }
            } else {
                backgroundSoundPlayer.play()
                //create new timer with the time left.
                
                if trainingSession == false {
                    self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(newTimerDuration), target: self, selector: #selector(playBellSound), userInfo: nil, repeats: false)
                    timerStartTime = Date()
                }

                playingState = true
                newTimerDuration = 0
            }
        }
    
    func pause() {
        
            backgroundSoundPlayer.pause()
        
            if trainingSession == false {
                timer.invalidate()
                //time difference between timer started and pause button
                let timeInterval = Date().timeIntervalSince(timerStartTime!)
                totalPauseTimePeriod = totalPauseTimePeriod + timeInterval
                
                
                print(totalPauseTimePeriod)
                newTimerDuration = Double(randomNumberInReset!) - totalPauseTimePeriod
                print("set new timer for: " + String(newTimerDuration))
                
                countdownTimer.invalidate()
            }
            playingState = false
        }

    
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}
