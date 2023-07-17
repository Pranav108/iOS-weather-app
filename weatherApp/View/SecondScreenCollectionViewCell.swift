//
//  SecondScreenCollectionViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 11/07/23.
//

import UIKit

class SecondScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var forecastingTime: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
    }


}
