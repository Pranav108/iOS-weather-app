//
//  placeholderImage.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/07/23.
//

import Foundation

import UIKit

class BackgroundView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.image = UIImage(named: "no-weather-data")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        setupUI()
    }
    
    func imageWithName(as imageName : String){
        if let tempImage = UIImage(named: imageName){
            imageView.image = tempImage
        }
    }

    override func didMoveToSuperview() {
        guard let superview = superview else{
            print("SuperView doesn't exist")
            return
        }
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: superview.centerYAnchor),

        ])
    }
}
