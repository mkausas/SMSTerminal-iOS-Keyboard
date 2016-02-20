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

