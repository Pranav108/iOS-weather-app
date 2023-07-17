//
//  Screen1TableViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 10/07/23.
//

import UIKit

class Screen1TableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var tmpLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var tempRangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
