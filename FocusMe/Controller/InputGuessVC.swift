//
//  InputGuessVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 07/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class InputGuessVC: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var inputNumberLabel: UILabel!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var buttons: calculatorButton!
    
    private var startingNo = "000"
    private var countOfDigits = 0
    var guess = ""
    
    private var music = MusicLogic()
    var bellCountActual = 0
    var managedObjectContext: NSManagedObjectContext?
    
    @IBAction func addNumber(_ sender: UIButton) {
        
        let numberPressed = sender.tag - 1
        if guess == "" && numberPressed == 0 {
            return
        }
        if startingNo.count > 0 && guess.count <= 3 {
            
            guess += String(sender.tag - 1)
            startingNo.removeLast()
            inputNumberLabel.text = startingNo + guess
        }
    }
    
    @IBAction func deleteNumber(_ sender: UIButton) {
        if guess.count > 0 {
            
            guess.removeLast()
            startingNo.append("0")
            inputNumberLabel.text = startingNo + guess
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.setCustomDarkBackgroundImage()
        let text = "How many dings\ndid you hear?"
        let editedText = NSMutableAttributedString(
            string: text,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Avenir-Light",
                size: 32.0)!])
        editedText.addAttribute(
            NSAttributedStringKey.font,
            value: UIFont(
                name: "Avenir-Medium",
                size: 32.0)!,
            range: NSRange(
                location: 15,
                length: 13))
        header.attributedText = editedText
        header.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    @IBAction func doneButton(_ sender: UIButton) {
        
            if guess == "" {
            //can add popup later on if needed
            print("enter number")
        } else {
        
            print("it sounded " + String(bellCountActual))
            Analytics.logEvent("session_complete", parameters: nil)
            performSegue(withIdentifier: "InputGuesssToResult", sender: nil)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bellCountGuess = Int(inputNumberLabel.text!)
        let bellCountActual = self.bellCountActual
        
        if let destinationViewController = segue.destination as? SeeResultVC {
            Analytics.logEvent("entered_dings", parameters: nil)
            destinationViewController.bellCountGuess = bellCountGuess
            destinationViewController.bellCountActual = bellCountActual
            
            destinationViewController.managedObjectContext = managedObjectContext
        }
    }
}
