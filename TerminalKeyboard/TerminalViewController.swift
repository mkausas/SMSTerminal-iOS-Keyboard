//
//  TerminalViewController.swift
//  SMSTerminalKeyboard
//
//  Created by Martynas Kausas on 2/20/16.
//  Copyright © 2016 martykausas. All rights reserved.
//

import UIKit

class TerminalViewController: UIInputViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var insets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(CommandCell.nib(), forCellWithReuseIdentifier: commandCellIdentifier)
    }
}

extension TerminalViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(commandCellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
}

extension TerminalViewController: UICollectionViewDelegate {
    
}


extension TerminalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = 100
        let height = 42
        return CGSize(width: width, height: height)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return insets
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 3
    }
}

