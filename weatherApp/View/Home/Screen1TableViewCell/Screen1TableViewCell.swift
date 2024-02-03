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
    
    weak var tableView: UITableView?
    var favClickedCallback: (() -> Void)?
    var delegate : TableReloaderDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectionStyle = .none
        self.animate()
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: 10, dy: 10)
        layer.mask = maskLayer
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func favClicked(_ sender: UIButton) {
        if let indexPath = tableView?.indexPath(for: self) {
            let cardIndex = indexPath.row
            if sender.currentImage == UIImage(systemName: "heart") {
                favouriteWeatherList.selectFavourite(havingIndex: cardIndex)
                sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            else {
                favouriteWeatherList.deselectFavourite(havingIndex: cardIndex)
                sender.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
        delegate?.reloadTableView()
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
}
