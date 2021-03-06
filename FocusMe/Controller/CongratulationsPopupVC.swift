//
//  CongratulationsPopupViewController.swift
//  FocusMe
//
//  Created by ryan lindsey on 24/07/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import SafariServices

protocol CongratulationsDelegate: NSObjectProtocol {
    func modalDismissed()
}

class CongratulationsPopupVC: UIViewController, SFSafariViewControllerDelegate {
    
    weak var delegate: CongratulationsDelegate?
    private let urlString = "https://ryan1306.typeform.com/to/QPkQeo"
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    var level = 0
    let icon = ""
    let header = ""
    let text = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        headerLabel.addCharacterSpacing(kernValue: 2)
        mainView.layer.cornerRadius = 8
        feedbackButton.layer.borderWidth = 1
        feedbackButton.layer.borderColor = UIColor.black.cgColor
    }
    
    
    private func setupLabels() {
        switch level {
        case 1:
            iconImage.image = UIImage(named: CongratulationsText.shared.levelStudent.image)
            headerLabel.text = CongratulationsText.shared.levelStudent.unlockedLevel
            textLabel.text = CongratulationsText.shared.levelStudent.text
        case 3:
            iconImage.image = UIImage(named: CongratulationsText.shared.levelMaster.image)
            headerLabel.text = CongratulationsText.shared.levelMaster.unlockedLevel
            textLabel.text = CongratulationsText.shared.levelMaster.text
        case 6:
            iconImage.image = UIImage(named: CongratulationsText.shared.levelGuru.image)
            headerLabel.text = CongratulationsText.shared.levelGuru.unlockedLevel
            textLabel.text = CongratulationsText.shared.levelGuru.text
        default:
            print("error with level popup.")
        }
    }
    
    
    @IBAction func giveFeeback(_ sender: UIButton) {
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            
            present(vc, animated: true)
        }
    }
    
    
    @IBAction func dismissVC(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.modalDismissed()
        }
    }
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? ScoreboardVC {
            destinationViewController.fromHomeScreen = true
        }
    }
}
