//
//  PhotoCell.swift
//  Slippery_Example
//
//  Created by BaekSungwook on 1/28/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var photo: UIImageView!
    override func prepareForReuse() {
        super.prepareForReuse()
        photo.image = UIImage()
    }
}
