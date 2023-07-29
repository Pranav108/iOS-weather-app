//
//  Screen1TableViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 10/07/23.
//

import UIKit

protocol TableReloaderDelegate{
    func reloadTableView()
}


class Screen1TableViewCell: UITableViewCell {
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var tmpLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var tempRangeLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    weak var tableView: UITableView?
    
    var favClickedCallback: (() -> Void)?
    
    var delegate : TableReloaderDelegate?
    
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
        print("BEFORE : ",sender.imageView?.image ?? "BEFORE IMAGE")
        
        if let indexPath = tableView?.indexPath(for: self) {
            let cardIndex = indexPath.row
            
            print("Cell's indexPath: \(String(describing: cardIndex))")
            
            if sender.currentImage == UIImage(systemName: "heart") {
                
                print("image name is HEART")
                
                favouriteWeatherList.selectFavourite(havingIndex: cardIndex)
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
            }
            else {
                print("image name is HEART.FILL")
                
                favouriteWeatherList.deselectFavourite(havingIndex: cardIndex)
                
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        
        print("AFTER : ",sender.imageView?.image! ?? "AFTER IMAGE")
        print(favouriteWeatherList.getFavouriteList())
        delegate?.reloadTableView()
    }
}
