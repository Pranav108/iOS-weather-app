//
//  SecondScreenTableViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 23/07/23.
//

import UIKit

class SecondScreenTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherLogo: UIImageView!
    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.selectionStyle = .none
        self.animate()
        self.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 5
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width, height: bounds.height).insetBy(dx: 16, dy: 10)
        self.layer.mask = maskLayer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "SecondScreenCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SecondScreenCollectionViewCell")
       
        collectionView.layer.borderColor = CGColor(gray: 0.32, alpha: 1)
        collectionView.layer.borderWidth = 3
        collectionView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        

        // Configure the view for the selected state
    }
    
    private func animate() {
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
        
        let hourlyData = screen2DataForBinding[collectionView.tag].hourlyData
        
        print("CELL is created : ", collectionView.tag, indexPath.item)
        
        cell.tempLabel.text = hourlyData[indexPath.item].temperature
        cell.timeLabel.text = hourlyData[indexPath.item].time

        return cell
    }

    
}
