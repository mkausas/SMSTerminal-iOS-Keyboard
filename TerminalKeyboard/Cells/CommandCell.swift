//
//  CommandCell.swift
//  SMSTerminal Keyboard
//
//  Created by Martynas Kausas on 2/20/16.
//  Copyright © 2016 martykausas. All rights reserved.
//

import UIKit

let commandCellIdentifier = "CommandCell"

class CommandCell: UICollectionViewCell {

    @IBOutlet weak var commandButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: commandCellIdentifier, bundle: nil)
    }
}
