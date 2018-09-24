//
//  InformationVC.swift
//  FocusMe
//
//  Created by ryan lindsey on 30/05/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import HealthKit
import SafariServices

protocol InformationVCDelegate: NSObjectProtocol {
    func informationModalDismissed()
}

class InformationVC: UIViewController, SFSafariViewControllerDelegate {

    weak var delegate: InformationVCDelegate?
    
    var fromScoreboard = false
    
    lazy var healthStore = HKHealthStore()
    
    @IBOutlet weak var appleHealthOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    private func setupView() {
        setCustomLightBackgroundImage()
        
        if HKHealthStore.isHealthDataAvailable() {
            appleHealthOutlet.layer.borderWidth = 1
            appleHealthOutlet.layer.borderColor = UIColor.white.cgColor
            
            if healthStore.authorizationStatus(for: HKCategoryType.categoryType(forIdentifier: .mindfulSession)!) == .sharingAuthorized || healthStore.authorizationStatus(for: HKCategoryType.categoryType(forIdentifier: .mindfulSession)!) == .sharingDenied {
                appleHealthOutlet.isHidden = true
            } else {
                appleHealthOutlet.isHidden = !HKHealthStore.isHealthDataAvailable()
            }
        }
    }
    
    
    @IBAction func connectWithHK(_ sender: UIButton) {
        authorizeHealthKit()
    }
    
    
    private func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
    
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
    
    
    @IBAction func giveFeeddback(_ sender: UIButton) {
        let urlString = "https://ryan1306.typeform.com/to/QPkQeo"
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        }
    
    
    @IBAction func closeVC(_ sender: UIButton) {
        
        if fromScoreboard {
            delegate?.informationModalDismissed()
            dismiss(animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindToMainFromInformation", sender: self)
        }
    }
    
}
