//
//  PageCell.swift
//  FocusMe
//
//  Created by ryan lindsey on 18/03/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page: OnboardingPage? {
        didSet {
            
            guard let unwrappedPage = page else { return }
            headerImage.image = UIImage(named: unwrappedPage.imageName)
            
            let attributedText = NSMutableAttributedString(string: unwrappedPage.headerText1, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Light", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedStringKey.foregroundColor: UIColor.white])
            
            attributedText.append(NSAttributedString(string: unwrappedPage.headerText2, attributes: [NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 27) ?? UIFont.boldSystemFont(ofSize: 27), NSAttributedStringKey.foregroundColor: UIColor.white]))

            descriptionTextView.attributedText = attributedText
            descriptionTextView.textAlignment = .center
        }
    }
    
    let headerImage: UIImageView = {

        let imageView = UIImageView()
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayoutView()
    }
    
    
    private func setupLayoutView() {
        
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
        NSLayoutConstraint(item: descriptionTextView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.33, constant: 0.0).isActive = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
