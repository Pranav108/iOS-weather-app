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
        super.layoutSubviews()
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: 16, dy: 10)
        layer.mask = maskLayer

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = CGColor(gray: 0.8, alpha: 0.6)
        layer.borderWidth = 3
    }
}
