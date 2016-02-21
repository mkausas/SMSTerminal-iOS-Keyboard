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
    
    @IBOutlet weak var nextKeyboardButton: UIButton!
    
    var commands: [String: [String]] =
    [
        "ls": ["-l", "-a"],
        "pwd": [],
        "cd": [".."]
    ]
    
    var commandKeys = [String]()
//    var currentCommands = [String]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(CommandCell.nib(), forCellWithReuseIdentifier: commandCellIdentifier)
        
        nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        print("did happen")
        
        // grab key list
        for key in commands.keys {
            commandKeys.append(key)
            print("Key = \(key)")
        }
        
        print(commandKeys)
    }
    
    
    
}

extension TerminalViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commandKeys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(commandCellIdentifier, forIndexPath: indexPath) as! CommandCell
        
        cell.commandButton.setTitle(commandKeys[indexPath.row], forState: .Normal)
        cell.commandButton.addTarget(self, action: "pressedKey:", forControlEvents: .TouchDown)
        
        return cell
    }
    
    @IBAction func pressedKey(sender: AnyObject) {
//        print("pressed button!")
        let button = sender as! UIButton
        let title = button.titleLabel?.text
        print("pressed \(title!)")
        
        self.textDocumentProxy.insertText("\(title!) ")
    }
    
}

extension TerminalViewController: UICollectionViewDelegate {
    
    internal func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("pressed collectioncell")
        
    }

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

