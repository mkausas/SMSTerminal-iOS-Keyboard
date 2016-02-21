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
    
    @IBOutlet weak var recentCommandButton: UIButton!
    
    var fullArgs: [String] = ["-a", "-b", "-c", "-d", "-e", "-f", "-g", "-h", "-i", "-j", "-k", "-l", "-m", "-n", "-o", "-p", "-q", "-r", "-s", "-t", "-u", "-v", "-w", "-x", "-y", "-z"]
    
    var commands: [String: [String]] =
    [
        "ls": ["-l", "-a"],
        "pwd": [],
        "cd": [".."],
        "git": ["config", "init", "clone", "add", "status", "diff", "commit", "reset", "rm", "mv", "branch",  "checkout" ,"merge" ,"mergetool" ,"log" ,"stash" ,"tag", "fetch", "pull", "push", "remote", "submodule", "show", "log", "diff", "shortlog", "describe", "apply", "cherry-pick", "diff", "rebase", "revert", "bisect", "blame", "grep", "am", "apply", "format-patch", "send-email", "request-pull", "svn", "fast-import", "clean", "gc", "fsck", "reflog", "filter-branch", "instaweb", "archive", "bundle", "daemon", "update-server-info", "cat-file", "commit-tree", "count-objects", "diff-index", "for-each-ref", "hash-object", "ls-files", "merge-base", "read-tree", "rev-list", "rev-parse", "show-ref", "symbolic-ref", "update-index", "update-ref", "verify-pack", "write-tree"],
        "mkdir": [],
        "rmdir": ["-r"],
        "cp": [],
        "mv": [],
        "rm": ["-r"],
        "|": [],
        "<": [],
        ">": [],
        "&": [],
        "man": [],
        "cat": [],
        "make": []
    ]
    
    
    var typeState: Int = 0
    let TYPE_STATE_COMMAND = 0
    let TYPE_STATE_FLAG = 1
    let TYPE_STATE_FREEFORM = 2
    
    var commandKeys = [String]()
    var argKeys = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.registerNib(CommandCell.nib(), forCellWithReuseIdentifier: commandCellIdentifier)
        
        nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        
        recentCommandButton.setTitle("", forState: .Normal)
        
        // grab key list
        for key in commands.keys {
            commandKeys.append(key)
            print("Key = \(key)")
        }
        
        setState(TYPE_STATE_COMMAND)
    }
    
    var lastAddedCommand = ""
    @IBAction func pressedKey(sender: AnyObject) {
        let button = sender as! UIButton
        let title = button.titleLabel?.text
        print("pressed \(title!)")
        
        // add to textfield
        lastAddedCommand = "\(title!) "
        self.textDocumentProxy.insertText("\(title!) ")
        
        // change commandkeys
        if typeState == TYPE_STATE_COMMAND {
            argKeys = commands[title!]!
            if argKeys.count > 0 {
                setState(TYPE_STATE_FLAG)
            }
        }
    }
    
    @IBAction func deleteAction(sender: AnyObject) {
        for var i = 0; i < stringLength(lastAddedCommand); i++ {
            self.textDocumentProxy.deleteBackward()
        }
    }
    
    var sentCommands = [String]()
    var currentHistoryCommand = 0
    override func textWillChange(textInput: UITextInput?) {
        let proxy = textDocumentProxy
        let beforeText = proxy.documentContextBeforeInput
        let afterText = proxy.documentContextAfterInput
        print("before text = \(beforeText) after text = \(afterText)")
        
        if afterText == nil {
            if let beforeText = beforeText {
                sentCommands.append(beforeText)
                print("sent commands \(sentCommands)")
                recentCommandButton.setTitle(beforeText, forState: .Normal)
                currentHistoryCommand += 1
                
                setState(TYPE_STATE_COMMAND)
            }
        }
    }
    
    @IBAction func setPreviousCommandAction(sender: AnyObject) {
        print("prev")
        if currentHistoryCommand > 0 {
            currentHistoryCommand -= 1
            recentCommandButton.setTitle(sentCommands[currentHistoryCommand], forState: .Normal)
        }
    }
    
    @IBAction func setNextCommandAction(sender: AnyObject) {
        print("next")
        if currentHistoryCommand < sentCommands.count - 1 {
            currentHistoryCommand += 1
            recentCommandButton.setTitle(sentCommands[currentHistoryCommand], forState: .Normal)
        }
    }
    
    
    @IBAction func sendHistoryCommandAction(sender: AnyObject) {
        self.textDocumentProxy.insertText((recentCommandButton.titleLabel?.text)!)
    }
    
    @IBAction func setCommandStateAction(sender: AnyObject) {
        setState(TYPE_STATE_COMMAND)
    }
    
    
    @IBAction func setArgStateAction(sender: AnyObject) {
        argKeys = fullArgs
        setState(TYPE_STATE_FLAG)
    }
    

    // helper functions
    func stringLength(string: String) -> Int {
        return string.characters.count
    }
    
    func setState(state: Int) {
        typeState = state
        collectionView.reloadData()
    }
}



extension TerminalViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var keys: [String]
        switch typeState {
        case TYPE_STATE_COMMAND:
            keys = commandKeys
            break
        case TYPE_STATE_FLAG:
            keys = argKeys
            break
        default:
            keys = commandKeys
            break
        }
        
        return keys.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var keys: [String]
        switch typeState {
        case TYPE_STATE_COMMAND:
            keys = commandKeys
            break
        case TYPE_STATE_FLAG:
            keys = argKeys
            break
        default:
            keys = commandKeys
            break
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(commandCellIdentifier, forIndexPath: indexPath) as! CommandCell
        
        cell.commandButton.setTitle(keys[indexPath.row], forState: .Normal)
        cell.commandButton.addTarget(self, action: "pressedKey:", forControlEvents: .TouchDown)
        
//        cell.frame.size = CGSizeMake(cell.frame.width, cell.frame.height)
        
        return cell
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

