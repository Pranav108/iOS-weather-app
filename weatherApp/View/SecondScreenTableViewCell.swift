//
//  SecondScreenTableViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 23/07/23.
//

import UIKit

class SecondScreenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
     
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
    }
    
    
    func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.contentView.layoutIfNeeded()
        })
    }
    
}
extension SecondScreenTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return innerWeatherDataList[collectionView.tag].count
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SecondScreenCollectionViewCell", for: indexPath) as! SecondScreenCollectionViewCell
        let hourlyData = screen2DataForBinding?[collectionView.tag].hourlyData
        
        cell.tempLabel.text = hourlyData?[indexPath.item].temperature ?? "TEMP"
        cell.timeLabel.text = hourlyData?[indexPath.item].time ?? "TIME"

        return cell
    }

    
}
