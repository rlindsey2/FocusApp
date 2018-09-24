//
//  ScoreboardVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 31/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData

class ScoreboardVC: UIViewController, CongratulationsDelegate, InformationVCDelegate {
    
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
    @IBOutlet weak var sessionText: UILabel!
    
    var level = 0
    
    var newLevelUnlocked = false
    var fromHomeScreen = false
    
    lazy var countingPercentage = CountingLabel(startValue: 0.0, endValue: percentageEndValue(), animationDuration: 2, percentage: true)
    
    let lockImage = UIImage(named: "icon_lock")
    let lockLabel = "locked"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    
    func modalDismissed() {
        newLevelUnlocked = false
        fetchCoreData()
        countingPercentage.text = "0%"
        progressBar.frame.size.width = 0
    }
    
    
    func informationModalDismissed() {
        
        fromHomeScreen = true
        print("called it \(fromHomeScreen)")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchCoreData()
        view.addSubview(countingPercentage)
        countingPercentage.frame = view.frame
        countingPercentage.font = UIFont(name: "Avenir-Heavy", size: 16)
        countingPercentage.addCharacterSpacing(kernValue: 2)
        
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
        print("home screen variable is \(fromHomeScreen)")
        progressBarAnimation()
//        levelImage2.animation(height: 200)
    }
    
    
    private func progressBarAnimation() {
        
        let percentage = percentageEndValue()
        progressBar.animation(width: Int(Double(backgroundBar.frame.width) * percentage), unlocked: newLevelUnlocked) {
            self.performSegue(withIdentifier: "CongratulationsSegue", sender: nil)
        }
    }
    
    
    private func percentageEndValue() -> Double {
        var countOfSessions = CoreDataModel.sharedInstance.countOfCompletedLevels() - 1 < ListOfLevels.sharedInstance.allLevels.count ? (CoreDataModel.sharedInstance.countOfCompletedLevels() - 1) : ListOfLevels.sharedInstance.allLevels.count - 1

            if fromHomeScreen == true && (countOfSessions == 1 || countOfSessions == 3) {
                countOfSessions = 0
            }
        
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
        
        level = result.count

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
            level -= 1
        }
        
        if level >= 2 {
            levelImage2.image = UIImage(named: "icon_helm")
            levelLabel2.text = "helm"
        }
        
        if level >= 4 {
            levelImage3.image = UIImage(named: "icon_submarine")
            levelLabel3.text = "submarine"
        }
        
        if level >= 2 && level < 4 {
            mainLevelImage.image = UIImage(named: "icon_helm")
        } else if level >= 4 {
            mainLevelImage.image = UIImage(named: "icon_submarine")
        }
    }

    
    @IBAction func informationButton(_ sender: UIButton) {
        performSegue(withIdentifier: "scoreboardToInformation", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? InformationVC {
            destinationViewController.delegate = self
            destinationViewController.fromScoreboard = true
        }
        if let destinationViewController = segue.destination as? CongratulationsPopupVC {
            destinationViewController.delegate = self
            destinationViewController.level = level
        }
    }
}
