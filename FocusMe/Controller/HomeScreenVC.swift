//
//  HomeScreenVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 22/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class HomeScreenVC: UIViewController {
    
    var level = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    lazy var context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var header: SpacedString!
    @IBOutlet weak var subHeader: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var upArrow: UIImageView!
    
    
    override func viewDidLoad() {        
        setCustomLightBackgroundImage()
        coreDataSetup()
        setupView()
        header.kern = 2.0
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        coreDataSetup()
        setupView()
        header.kern = 2.0
    }
    
    
    private func durationToTime(duration: Int) -> String {
        if level == 0 {
            return /*"\(duration) seconds"*/ ""
        } else {
            return "\(duration / 60) mins"
        }
    }
    
    
    private func setupView() {
        let listOfLevels = ListOfLevels()
        
        if level < listOfLevels.allLevels.count {
            iconImage.image = UIImage(named: listOfLevels.allLevels[level].image)
            header.text = listOfLevels.allLevels[level].name
            subHeader.text = listOfLevels.allLevels[level].subHeader
            duration.text = durationToTime(duration: listOfLevels.allLevels[level].duration)
        } else {
            iconImage.image = UIImage(named: listOfLevels.allLevels[listOfLevels.allLevels.count - 1].image)
            header.text = listOfLevels.allLevels[listOfLevels.allLevels.count - 1].name
            subHeader.text = listOfLevels.allLevels[listOfLevels.allLevels.count - 1].subHeader
            duration.text = durationToTime(duration: listOfLevels.allLevels[listOfLevels.allLevels.count - 1].duration)
        }
        
        if level < 2 {
            upArrow.isHidden = true
        } else {
            upArrow.isHidden = false
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
            swipeUp.direction = .up
            self.view.addGestureRecognizer(swipeUp)
        }
    }
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.up {
            performSegue(withIdentifier: "swipeUpSegue", sender: self)
        }
    }
    
    
    private func coreDataSetup() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")

        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            level = result.count < ListOfLevels.sharedInstance.allLevels.count ? result.count : ListOfLevels.sharedInstance.allLevels.count - 1

        } catch {
            print("Failed")
        }
    }
    
    
    @IBAction func ctaButton(_ sender: UIButton) {
        Analytics.logEvent("session_started", parameters: nil)
//
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedSessionV2")
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(batchDeleteRequest)
//            print("deleted")
//        } catch {
//            print(error)
//        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToCountdown" {
            if let destinationViewController = segue.destination as? CountdownVC {
                destinationViewController.level = level
            }
        }
        if let destinationViewController = segue.destination as? ScoreboardVC {
            destinationViewController.fromHomeScreen = true
        }
    }
    
    
    @IBAction func unwindToNewMain(segue: UIStoryboardSegue) {
    }
}
