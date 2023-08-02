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
    
    
    @IBOutlet weak var outerView: UIView!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var tmpLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var tempRangeLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    
    private var selectedRow : Int? // why I'm able to recover this , even after reloading tableView
    
    static var selectedIndexSet : IndexSet = []
    
    weak var tableView: UITableView?
    
    var delegate : TableReloaderDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: frame.width, height: frame.height).insetBy(dx: 5, dy: 5)
        self.layer.mask = maskLayer
        
        print(#function)
        
        if let selectedRow = selectedRow {
            print("index path found ", selectedRow)
            
            if Screen1TableViewCell.selectedIndexSet.contains(selectedRow) {
                layer.borderColor = CGColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
                layer.borderWidth = 10
            }else{
                layer.borderWidth = 0
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func togggleSelection(for rowIndex : Int){
        
        selectedRow = rowIndex
        Screen1TableViewCell.selectedIndexSet.removeAll()
        Screen1TableViewCell.selectedIndexSet.insert(rowIndex)
    }
    
    @IBAction func favClicked(_ sender: UIButton) {
        
        if let indexPath = tableView?.indexPath(for: self) {
            let cardIndex = indexPath.row
            
            print("Cell's indexPath: \(String(describing: cardIndex))")
            
            if sender.currentImage == UIImage(systemName: "heart") {
                favouriteWeatherList.selectFavourite(havingIndex: cardIndex)
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                
            }
            else {
                favouriteWeatherList.deselectFavourite(havingIndex: cardIndex)
                
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        print(favouriteWeatherList.getFavouriteList())
        delegate?.reloadTableView()
    }
}
