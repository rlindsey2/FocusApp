//
//  ReceiveScoreVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 31/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import Firebase

class ReceiveScoreVC: UIViewController {
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var guessScore: UILabel!
    
    lazy var countingNumber = CountingLabel(startValue: 0.0, endValue: Double(bellCountActual!), animationDuration: 2, percentage: false)
    
    var level: Int?
    var bellCountGuess: Int?
    var bellCountActual: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isHidden = true
        setupView()
    }
    
    
    private func setupView() {
        setCustomLightBackgroundImage()
        
        guard let unwrappedBellCountGuess = bellCountGuess else { return }
        guessScore.text = "\(unwrappedBellCountGuess) of"
        countingNumber.font = UIFont(name: "Avenir-Heavy", size: 112)
        
        Timer.scheduledTimer(withTimeInterval: 2.2, repeats: false) { (timer) in
            self.nextButton.isHidden = false
        }
        view.addSubview(countingNumber)
        countingNumber.frame = view.frame
        setupConstraints()
    }
    
    
    private func setupConstraints() {
        countingNumber.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: countingNumber, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: countingNumber, attribute: .top, relatedBy: .equal, toItem: guessScore, attribute: .top, multiplier: 1.0, constant: 30)
            ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ScoreboardVC  {
            let completedLevelEqual = [2,4,7]
            guard let unwrappedLevel = level else { return }
            Analytics.logEvent("session_saved", parameters: [
                "level" : unwrappedLevel
                ])
            if completedLevelEqual.contains(unwrappedLevel + 1) {
                destinationViewController.newLevelUnlocked = true
            }
        }
    }
}
