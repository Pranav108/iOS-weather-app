//
//  SettingInfoTableViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 30/12/23.
//

import UIKit

protocol SettingMoreInfoDelegateProtocol {
    func openInfoScreenTapped(for nestedSettingType : NestedSettingType)
}

class SettingInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    static let nibName = UINib(nibName: "SettingInfoTableViewCell", bundle: nil)
    static let identifier = "SettingInfoTableViewCell"
    
    var settInfoCallBackDelegate : SettingMoreInfoDelegateProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureMoreInfoLableCell(for nestedSettingType : NestedSettingType){
        cellLabel.text = nestedSettingType.rawValue
    }
    
    @IBAction func moreInfoSettingtapped(){
        let nestedSettingType = NestedSettingType(rawValue: cellLabel.text!)!
        settInfoCallBackDelegate?.openInfoScreenTapped(for: nestedSettingType)
    }
}
