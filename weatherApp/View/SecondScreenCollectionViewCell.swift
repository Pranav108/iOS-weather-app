//
//  SecondScreenCollectionViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 23/07/23.
//

import UIKit

class SecondScreenCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func layoutSubviews() {
        layer.borderColor = CGColor(gray: 0.8, alpha: 0.6)
        layer.borderWidth = 3
    }
}
