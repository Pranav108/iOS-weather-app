//
//  ToggleSettingTableViewCell.swift
//  weatherApp
//
//  Created by Pranav Pratap on 30/12/23.
//

import UIKit

protocol SettingSwitchDelegateProtocol {
    func didSwitchTapped(for toggleType : ToggleType, changedTo isSwitchOn : Bool)
}

class ToggleSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var toggleSwitch: UISwitch!
    
    static let identifier = "ToggleSettingTableViewCell"
    static let nibName = UINib(nibName: "ToggleSettingTableViewCell", bundle: nil)
    var switchCallBackDelegate : SettingSwitchDelegateProtocol?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureToggelableCell(for toggleType : ToggleType, with isSwitchOn : Bool){
        settingLabel.text = toggleType.rawValue
        toggleSwitch.isOn = isSwitchOn
    }
    
    @IBAction func isSwitchButtonTapped() {
        let toggleType : ToggleType = ToggleType(rawValue: settingLabel.text!)!
        
        switchCallBackDelegate?.didSwitchTapped(for: toggleType, changedTo: toggleSwitch.isOn)
    }
}
