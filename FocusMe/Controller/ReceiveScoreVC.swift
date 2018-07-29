//
//  ReceiveScoreVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 31/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class ReceiveScoreVC: UIViewController {

    @IBOutlet weak var guessLabel: UILabel!
    @IBOutlet weak var actualLabel: UILabel!
    
    var level: Int?
    var bellCountGuess: Int?
    var bellCountActual: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    
    private func setupView() {
        setCustomLightBackgroundImage()
        
        guard let unwrappedGuess = bellCountGuess else { return }
        guard let unwrappedActual = bellCountActual else { return }
        
        guessLabel.text = String(unwrappedGuess)
        actualLabel.text = "/\(unwrappedActual)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ScoreboardVC  {
            let completedLevelEqual = [2,4,7]
            guard let unwrappedLevel = level else { return }
            print("unwrapped level is \(unwrappedLevel)")
            if completedLevelEqual.contains(unwrappedLevel + 1) {
                destinationViewController.newLevelUnlocked = true
            }
        }
    }
}
