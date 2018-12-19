//
//  PageCell.swift
//  FocusMe
//
//  Created by ryan lindsey on 18/03/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit
import Gifu
import Firebase

protocol CollectionViewCellDelegate: class {
    func collectionViewCell(_ cell: UICollectionViewCell)
}

class PageCell: UICollectionViewCell, CollectionViewCellAnimationDelegate {
    func startAnimation() {
        UIView.animate(withDuration: 2.4, animations: { () -> Void in
            print("animating")
            self.descriptionTextView.alpha = 1
        })
    }
    
    weak var delegate: CollectionViewCellDelegate?
    
    let categories = ["Focus", "Stress", "Anxiety", "Depression", "Sleep"]
    
    var page: OnboardingPage? {
        didSet {
            guard let unwrappedPage = page else { return }
            if let unwrappedImage = unwrappedPage.imageName {
                headerImage.animate(withGIFNamed: unwrappedImage, loopCount: 1)
            }
            let attributedText = NSMutableAttributedString(string: unwrappedPage.headerText1, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            attributedText.append(NSAttributedString(string: unwrappedPage.headerText2 ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.white]))
            descriptionTextView.attributedText = attributedText
            descriptionTextView.textAlignment = .center
            if (unwrappedPage.optionOne != nil) {
                createLastScreen(headerText1: unwrappedPage.headerText1, headerText2: unwrappedPage.headerText2 ?? "")
            } else {
                normalScreens()
            }
        }
    }
    
    
    let headerImage: GIFImageView = {
        let imageView = GIFImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let lastPageHeaderImage: GIFImageView = {
        let imageView = GIFImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let lastPageTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    var bottomText: UIButton = {
        let button = UIButton(/*type: .system*/)
        
        button.layer.borderWidth = 2
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayoutView()
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        normalScreens()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let useCase = sender.currentTitle ?? "No title"
        print(useCase)
        Analytics.logEvent("use_case", parameters: ["type": useCase])
        //send event, animate and segue
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            let alpha = CGFloat(0.2)
            for number in 1...(self.categories.count) {
                if let button = self.viewWithTag(number) as? UIButton
                {
                    button.alpha = alpha
                    button.isEnabled = false
                    if sender.tag == number {
                        button.alpha = 1
                    }
                }
            }
            self.lastPageHeaderImage.alpha = 0
            self.lastPageTextView.alpha = 0
        }, completion: { (finished: Bool) in
            self.animateBackIn()
        })
    }
    
    private func animateBackIn() {
        let attributedText = NSMutableAttributedString(string: "Ok, lets begin with", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: "\na quick tutorial", attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.white]))
        self.lastPageTextView.attributedText = attributedText
        self.lastPageTextView.textAlignment = .center
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.lastPageTextView.alpha = 1
            
        }, completion: { (finished: Bool) in
            
            self.fadeAndSeque()
        })
    }
    
    private func fadeAndSeque() {
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.lastPageTextView.alpha = 0
            for number in 1...(self.categories.count) {
                if let button = self.viewWithTag(number) as? UIButton
                {
                    button.alpha = 0
                }
            }
        }, completion: { (finished: Bool) in
            self.delegate?.collectionViewCell(self)
        })
    }
    
    private func normalScreens() {
        headerImage.isHidden = false
        descriptionTextView.isHidden = false
        hideButtons(true)
        lastPageTextView.isHidden = true
        lastPageHeaderImage.isHidden = true
    }
    
    
    private func setupLayoutView() {
        //        setup normal pages
        addSubview(headerImage)
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        headerImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        headerImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
        headerImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        NSLayoutConstraint(item: headerImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.9, constant: 0.0).isActive = true
        
        addSubview(descriptionTextView)
        descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        descriptionTextView.backgroundColor = .clear
        NSLayoutConstraint(item: descriptionTextView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.4, constant: 0.0).isActive = true
        
        //        setup last screen
        addSubview(lastPageHeaderImage)
        lastPageHeaderImage.translatesAutoresizingMaskIntoConstraints = false
        lastPageHeaderImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80).isActive = true
        lastPageHeaderImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80).isActive = true
        NSLayoutConstraint(item: lastPageHeaderImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.3, constant: 0.0).isActive = true
        
        addSubview(lastPageTextView)
        lastPageTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        lastPageTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        lastPageTextView.backgroundColor = .clear
        NSLayoutConstraint(item: lastPageTextView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.6, constant: 0.0).isActive = true
        
        let multiple = CGFloat(1.0)
        var constant = CGFloat(0.0)
        for i in 1...(categories.count) {
            bottomText = UIButton(/*type: .system*/)
            bottomText.layer.borderWidth = 2
            bottomText.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            bottomText.setTitleColor(.white, for: .normal)
            bottomText.setTitle(categories[i - 1], for: .normal)
            bottomText.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            bottomText.tag = i
            self.addSubview(bottomText)
            bottomText.translatesAutoresizingMaskIntoConstraints = false
            bottomText.heightAnchor.constraint(equalToConstant: 50).isActive = true
            bottomText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
            bottomText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40).isActive = true
            bottomText.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            NSLayoutConstraint(item: bottomText, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: multiple, constant: constant).isActive = true
            constant += 60
        }
    }
    
    private func hideButtons(_ state: Bool) {
        for number in 1...(categories.count) {
            if let button = viewWithTag(number) as? UIButton
            {
                button.isHidden = state
            }
        }
    }
    
    private func createLastScreen(headerText1: String, headerText2: String) {
        headerImage.isHidden = true
        descriptionTextView.isHidden = true
        lastPageHeaderImage.animate(withGIFNamed: "icon_head_question", loopCount: 1)
        lastPageTextView.isHidden = false
        lastPageHeaderImage.isHidden = false
        let attributedText = NSMutableAttributedString(string: headerText1, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Light", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: headerText2, attributes: [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedString.Key.foregroundColor: UIColor.white]))
        lastPageTextView.attributedText = attributedText
        lastPageTextView.textAlignment = .center
        hideButtons(false)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
