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
    
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        layoutMargins = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func favClicked(_ sender: UIButton) {
        print("BEFORE : ",sender.imageView?.image!)
        
        if let tableView = self.superview as? UITableView {
            
            let indexPath = tableView.indexPath(for: self)
            
            if let cardIndex = indexPath?.row {
                print("Cell's indexPath: \(String(describing: cardIndex))")
                if sender.currentImage == UIImage(systemName: "heart") {
                    print("IMAGE NAME IS heart")
                    
                    if let indexToDeselect = favouriteWeatherList.selectFavourite(havingIndex: cardIndex) {
                        print("indexToDeselect : ",indexToDeselect)
                        let cellToBeUnselected = tableView.cellForRow(at: indexPath!) as! Screen1TableViewCell
                        cellToBeUnselected.favButton.setImage(UIImage(systemName: "heart"), for: .normal)
                    }
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                else {
                    // make fav
                    print("IMAGE NAME IS NOT heart")
                    favouriteWeatherList.deselectFavourite(havingIndex: cardIndex)
                    sender.setImage(UIImage(systemName: "heart"), for: .normal)
                }
               
                print("AFTER : ",sender.imageView?.image!)
            }else{
                print("CANNOT get cardIndex")
            }
            
        }
    }
}
