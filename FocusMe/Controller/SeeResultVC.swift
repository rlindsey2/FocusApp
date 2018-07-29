//
//  SeeResultVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 08/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class SeeResultVC: UIViewController {

    @IBOutlet weak var guessOutOfLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var doneButton: RectangleActionButton!
    @IBOutlet weak var niceWorkLabel: UILabel!
    
    private let levelOfSession = "Beginner"
    var bellCountGuess: Int?
    var bellCountActual: Int?
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCustomLightBackgroundImage()
        print(AccuracyLogic(guess: bellCountGuess!, actual: bellCountActual!))
        doneButton.whiteBorder()
        guessOutOfLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        accuracyLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        niceWorkLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        guessOutOfLabel.text = "\(bellCountGuess!) of \(bellCountActual!) dings"
        accuracyLabel.text = "\(AccuracyLogic(guess: bellCountGuess!, actual: bellCountActual!))% accuracy."
        Analytics.logEvent("result_received", parameters:
            ["result" : AccuracyLogic(guess: bellCountGuess!, actual: bellCountActual!)
        ])
    }
    
    @IBAction func saveSession(_ sender: UIButton) {
        Analytics.logEvent("session_saved", parameters: nil)
        
        guard let managedObjectContext = managedObjectContext else { return }
        let result = SavedSession(context: managedObjectContext)
        
        result.date = Date()
        result.level = levelOfSession
        result.bellCountGuess = Int16(bellCountGuess!)
        result.bellCountActual = Int16(bellCountActual!)
        result.score = Int16(AccuracyLogic(guess: bellCountGuess!, actual: bellCountActual!))
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Unable to Save Changes")
            print("\(error), \(error.localizedDescription)")
        }
        
    }
}
