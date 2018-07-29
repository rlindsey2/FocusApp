//
//  ScoreboardVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 31/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData

class NewLevel {
    
/*
     TODO: Work out how to load scoreboard depending on if they have just completed a new level or not and should go through the congrats page. Potential solution:
     
If newLevel is false, go through core data setup as normal.
Else if newLevel is true,
     1. load the icons like the last session.
     2. When progressBar animation has completed, call popup to let them know they have unlocked the next level.
     3. Then go through the core data setup.
 
*/
}


class ScoreboardVC: UIViewController, CongratulationsDelegate {
    
    @IBOutlet weak var mainLevelImage: UIImageView!
    @IBOutlet weak var accuracy: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var sessionCount: UILabel!
    @IBOutlet weak var levelImage2: fadeInImage!
    @IBOutlet weak var levelImage3: UIImageView!
    @IBOutlet weak var levelLabel2: UILabel!
    @IBOutlet weak var levelLabel3: UILabel!
    @IBOutlet weak var progressBar: ProgressBar!
    @IBOutlet weak var backgroundBar: UILabel!
    
    var newLevelUnlocked = false
    
    lazy var countingPercentage = CountingLabel(startValue: 0.0, endValue: percentageEndValue(), animationDuration: 2)
    
    let lockImage = UIImage(named: "icon_lock")
    let lockLabel = "locked"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    
    func modalDismissed() {
        newLevelUnlocked = false
        fetchCoreData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchCoreData()
        view.addSubview(countingPercentage)
        countingPercentage.frame = view.frame
        setupConstraints()
    }
    
    private func setupConstraints() {
        countingPercentage.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: countingPercentage, attribute: .centerX, relatedBy: .equal, toItem: backgroundBar, attribute: .centerX, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: countingPercentage, attribute: .centerY, relatedBy: .equal, toItem: backgroundBar, attribute: .centerY, multiplier: 1.0, constant: 0),
            ])
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        progressBarAnimation()
//        levelImage2.animation(height: 200)
        
    }
    
    private func progressBarAnimation() {
        
        let percentage = percentageEndValue()
        progressBar.animation(width: Int(Double(backgroundBar.frame.width) * percentage), superViewWidth: Int(backgroundBar.frame.size.width)) {
            self.performSegue(withIdentifier: "CongratulationsSegue", sender: nil)
        }
    }
    
    
    private func percentageEndValue() -> Double {
        let countOfSessions = CoreDataModel.sharedInstance.countLevels() - 1 < ListOfLevels.sharedInstance.allLevels.count ? (CoreDataModel.sharedInstance.countLevels() - 1) : ListOfLevels.sharedInstance.allLevels.count - 1
        return ListOfLevels.sharedInstance.allLevels[countOfSessions].percentageComplete
    }
    
    
    private func setupView() {
        setCustomLightBackgroundImage()
        backgroundBar.layer.cornerRadius = 8
    }
    
    private func fetchCoreData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            coreDataSetup(result: result)
        } catch {
            print("Failed")
        }
    }
    
    
    private func coreDataSetup(result: [Any]) {
        
        var level = result.count
        
        //sessionCount.text = "0" + String(result.count - 1)
        sessionCount.text = "0" + String(level - 1)
        let sumOfBellCountGuess = result.reduce(0) { $0 + (($1 as AnyObject).value(forKey: "bellCountGuess") as? Int16 ?? 0) }
        let sumOfBellCountActual = result.reduce(0) { $0 + (($1 as AnyObject).value(forKey: "bellCountActual") as? Int16 ?? 0) }
        
        var resultOfStatement: Int {
            
            if sumOfBellCountGuess <= sumOfBellCountActual {
                return Int(sumOfBellCountGuess)
            } else {
                let overguess = sumOfBellCountActual - (sumOfBellCountGuess - sumOfBellCountActual)
                return Int(overguess)
            }
        }
        
        score.text = String(resultOfStatement)
        accuracy.text = String(AccuracyLogic(guess: Int(sumOfBellCountGuess), actual: Int(sumOfBellCountActual))) + "%"
        
        if newLevelUnlocked == true && level > 1 {
            //minus the level by 1
            level -= 1
        }
        print("level number is \(level)")
        
        //if result.count >= 2 {
        if level >= 2 {
            
            levelImage2.image = UIImage(named: "icon_helm")
            levelLabel2.text = "helm"
        }
        
        //if result.count >= 4 {
        if level >= 4 {
            
            levelImage3.image = UIImage(named: "icon_submarine")
            levelLabel3.text = "submarine"
        }
        
        //if result.count >= 2 && result.count < 4 {
        if level >= 2 && level < 4 {
            
            mainLevelImage.image = UIImage(named: "icon_helm")
        //} else if result.count >= 4 {
        } else if level >= 4 {
            mainLevelImage.image = UIImage(named: "icon_submarine")
        }
    }

    
    @IBAction func informationButton(_ sender: UIButton) {
        performSegue(withIdentifier: "scoreboardToInformation", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? InformationVC {
            destinationViewController.fromScoreboard = true
        }
        if let destinationViewController = segue.destination as? CongratulationsPopupViewController {
            destinationViewController.delegate = self
        }
    }
}
