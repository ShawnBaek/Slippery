//
//  CalendarCell.swift
//  Slippery_Example
//
//  Created by BaekSungwook on 1/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class NumberCell: UICollectionViewCell {
    
    @IBOutlet weak var number: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        number.text = ""
        number.textColor = .black
    }
    
}
