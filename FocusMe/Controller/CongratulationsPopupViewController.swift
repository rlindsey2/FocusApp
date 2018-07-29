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

class CongratulationsPopupViewController: UIViewController, SFSafariViewControllerDelegate {
    
    weak var delegate: CongratulationsDelegate?
    private let urlString = "https://ryan1306.typeform.com/to/QPkQeo"
    
    @IBOutlet weak var mainView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 8
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
}
