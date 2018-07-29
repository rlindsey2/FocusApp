//
//  NewInputScoreVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 30/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class NewInputScoreVC: UIViewController {

    @IBOutlet weak var xOutlet: UIButton!
    @IBOutlet weak var tickOutlet: UIButton!
    @IBOutlet weak var secondDigit: UILabel!
    @IBOutlet weak var firstDigit: UILabel!
    
    var level = 0
    var inputGuess = ""
    var bellCountActual: Int?

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView() {
        setCustomLightBackgroundImage()
        xOutlet.isHidden = true
        tickOutlet.isHidden = true
    }
    
    
    @IBAction func xButton(_ sender: UIButton) {
        if inputGuess.count > 0 {
            inputGuess.removeLast()
        }
        
        updateLabels()
    }
    
    
    @IBAction func tickButton(_ sender: UIButton) {
        if inputGuess.count > 0 {
        performSegue(withIdentifier: "SegueToResult", sender: self)
        }
    }
    
    
    @IBAction func addNumber(_ sender: UIButton) {
        
        if (sender.tag == 0 && inputGuess.count < 1) {
            return
        }
        
        xOutlet.isHidden = false
        tickOutlet.isHidden = false
        
        if inputGuess.count < 2 {
            inputGuess.append(String(sender.tag))
        }
        
        updateLabels()
    }
    
    
    private func updateLabels() {
        
        if inputGuess.count < 1 {
            xOutlet.isHidden = true
            tickOutlet.isHidden = true
            firstDigit.text = ""
            secondDigit.text = ""
        }
        
        guard let unwrappedFirst = inputGuess.first else { return }
        guard let unwrappedSecond = inputGuess.last else { return }
        
        if inputGuess.count == 1 {
            firstDigit.text = String(unwrappedFirst)
            secondDigit.text = ""
        }
        
        if inputGuess.count == 2 {
            firstDigit.text = String(unwrappedSecond)
            secondDigit.text = String(unwrappedFirst)
        }
    }
    
    
    private func saveCoreData() {
        let entity = NSEntityDescription.entity(forEntityName: "SavedSessionV2", in: context)
        let newSession = NSManagedObject(entity: entity!, insertInto: context)
        
        let bellCountGuess = Int(inputGuess)
        let score = AccuracyLogic(guess: bellCountGuess!, actual: bellCountActual!)
        
        newSession.setValue(Date(), forKey: "date")
        newSession.setValue(ListOfLevels.sharedInstance.allLevels[level].name, forKey: "level")
        newSession.setValue(bellCountActual, forKey: "bellCountActual")
        newSession.setValue(bellCountGuess, forKey: "bellCountGuess")
        newSession.setValue(score, forKey: "score")
        
        do {
            try context.save()
        } catch {
            print("failed saving")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let bellCountGuess = Int(inputGuess)
        saveCoreData()
        
        if let destinationViewController = segue.destination as? ReceiveScoreVC {
            Analytics.logEvent("entered_dings", parameters: nil)
            destinationViewController.bellCountGuess = bellCountGuess
            destinationViewController.bellCountActual = bellCountActual
            destinationViewController.level = level
        }
    }
}
