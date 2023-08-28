//
//  ReusableHeader.swift
//  weatherApp
//
//  Created by Pranav Pratap on 15/07/23.
//

import UIKit

class ReusableHeader: UIView  {
    
    private let placeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .opaqueSeparator
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Weather App"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        basicInit()
    }
    
    private func basicInit(){
        addSubview(placeLabel)
        layer.cornerRadius = 8.0
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .opaqueSeparator
        //        print(#function)
        
    }
    
    func setHeaderColor(color : UIColor){
        placeLabel.backgroundColor = color
        backgroundColor = color
    }
    
    override func didMoveToSuperview() {
        //        print(#function)
        guard let superview = superview else{
            print("SuperView doesn't exist")
            return
        }
        
        NSLayoutConstraint.activate([
            
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            
            heightAnchor.constraint(equalToConstant: 40),
            widthAnchor.constraint(equalTo: superview.widthAnchor , multiplier: 0.85),
            
            placeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            placeLabel.widthAnchor.constraint(equalToConstant: 50),
            placeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            placeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
        ])
    }
    
    func binddataToCard(withText textToShow: String){
        print(#function)
        DispatchQueue.main.async {
            self.placeLabel.text = textToShow
        }
    }
    
}
