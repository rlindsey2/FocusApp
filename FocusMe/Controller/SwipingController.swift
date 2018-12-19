//
//  SwipingController.swift
//  FocusMe
//
//  Created by ryan lindsey on 19/03/2018.
//  Copyright © 2018 Focus me. All rights reserved.
//

import UIKit

protocol CollectionViewCellAnimationDelegate: NSObjectProtocol {
    func startAnimation()
}

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    func segue() {
        print("this works")
    }
    
    weak var delegate: CollectionViewCellAnimationDelegate?
    
    let pages = [
        OnboardingPage(headerText1: "Prime your mind", headerText2: "\nConquer the world", imageName: "icon_shield", optionOne: nil),
        OnboardingPage(headerText1: "Dynamic meditations", headerText2: "\nCount the beacons", imageName: "icon_meditation", optionOne: nil),
        OnboardingPage(headerText1: "For best results", headerText2: "\nUse headphones", imageName: "icon_headphones", optionOne: nil),
        OnboardingPage(headerText1: "How can primr", headerText2: "\nhelp you?", imageName: nil, optionOne: "n")
    ]
    
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = .green
        pc.pageIndicatorTintColor = .white
        return pc
    }()
    
    
    let upArrow = UIImageView()
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.y
        pageControl.currentPage = Int(x / view.frame.height)
        if pageControl.currentPage == (pages.count - 1) {
            upArrow.isHidden = true
        } else {
            upArrow.isHidden = false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImageView()
        bgImage.image = UIImage(named: "background_gradient_light")
        bgImage.contentMode = .scaleToFill
        collectionView?.backgroundView = bgImage
        
        upArrow.image = UIImage(named: "icon_arrows_up")
        upArrow.contentMode = .scaleAspectFit
        view.addSubview(upArrow)
        upArrow.translatesAutoresizingMaskIntoConstraints = false
        upArrow.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint(item: upArrow, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.9, constant: 0.0).isActive = true
        
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView?.isPagingEnabled = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath == [0,(pages.count-1)] {
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

extension SwipingController: CollectionViewCellDelegate {
    func collectionViewCell(_ cell: UICollectionViewCell) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeScreenVC")
        self.present(nextViewController, animated:true, completion:nil)
    }
}
