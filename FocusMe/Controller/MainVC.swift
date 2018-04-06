//
//  MainVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 03/02/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics
import Firebase

class MainVC: UIViewController {
    
    var navbar : UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var buttonAction: RectangleActionButton!
    
    private let headerLabelNew = "Hello there,\nWelcome to\nfocus app."
    private let headerLabelReturning = "Welcome back. \nHere is your focus \nscore history"
    
    private var myText = Array("")
    private var typingAnimationCounter = 0
    private var typingAnimationTimer: Timer?
    
    func fireTimer() {
    
        typingAnimationTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(typeLetter), userInfo: nil, repeats: true)
    }
    
    @objc func typeLetter() {
        
        if typingAnimationCounter < myText.count {
            headerLabel.text = headerLabel.text! + String(myText[typingAnimationCounter])
        } else {
            typingAnimationTimer?.invalidate()
            
        }
        typingAnimationCounter += 1
    }
    
    private let persistentContainer = NSPersistentContainer(name: "FocusMe")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<SavedSession> = {
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<SavedSession> = SavedSession.fetchRequest()
        
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCustomLightBackgroundImage()
    
        buttonAction.whiteBorder()
        headerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("Unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
                
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
 
        let newHeaderMutableString = NSMutableAttributedString(
            string: headerLabelNew,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Avenir-Light",
                size: 32.0)!])
        newHeaderMutableString.addAttribute(
            NSAttributedStringKey.font,
            value: UIFont(
                name: "Avenir-Medium",
                size: 32.0)!,
            range: NSRange(
                location: 24,
                length: 9))
        
        let returningHeaderMutableString = NSMutableAttributedString(
            string: headerLabelReturning,
            attributes: [NSAttributedStringKey.font:UIFont(
                name: "Avenir-Light",
                size: 32.0)!])
        returningHeaderMutableString.addAttribute(
            NSAttributedStringKey.font,
            value: UIFont(
                name: "Avenir-Medium",
                size: 32.0)!,
            range: NSRange(
                location: 0,
                length: 12))
        
         guard let results = fetchedResultsController.fetchedObjects else {
         return print("error fetching core data")
         }
         
        if results.count < 1 {
            myText = Array(headerLabelNew)
            fireTimer()
            
        } else {
            myText = Array(headerLabelReturning)
            fireTimer()
        }
        
    }
    
    func reloadView() {
        tableView.reloadData()
        print("tableview reloaded")
    }
    
    @IBAction func startSession(_ sender: UIButton) {
        Analytics.logEvent("start_session", parameters: nil)
    }

    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindFromResultToMain(segue: UIStoryboardSegue) {
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToCount" {
            if let destinationViewController = segue.destination as? CountdownVC {
                destinationViewController.managedObjectContext = persistentContainer.viewContext
                //Crashlytics.sharedInstance().crash()
            }
        }
    }
}

extension MainVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        reloadView()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                tableView.reloadRows(at: [indexPath!], with: .fade)
            case .move:
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
}
 

extension MainVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let results = fetchedResultsController.fetchedObjects else { return 0 }
        
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainVCResultCell.reuseIdentifier, for: indexPath) as? MainVCResultCell else {
            fatalError("Unexpected Index Path")
        }
        let result = fetchedResultsController.object(at: indexPath)
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let screenSizeMinusConstraints = screenWidth - 40
        
        let standardWidth = screenSizeMinusConstraints
        let score = ((Double(result.score)) / 100.0)
        let width = Double(standardWidth) * score
        
        let widthContraints = NSLayoutConstraint(item: cell.movingView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(width))
        NSLayoutConstraint.activate([widthContraints])
        
        cell.percentageLabel.text = "\(result.score)%"
        cell.trainingNumberLabel.text = "Training \(indexPath.row + 1)"
        
        return cell
    }
}
