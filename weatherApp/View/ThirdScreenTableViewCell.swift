//
//  ThirdScreenTableViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 12/07/23.
//

import UIKit

class ThirdScreenTableViewCell: UITableViewCell {

    @IBOutlet weak var dayNameLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    

    @IBOutlet weak var humidityLabel: UILabel!
   
    @IBOutlet weak var weatherIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
