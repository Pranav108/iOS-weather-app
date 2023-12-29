//
//  BlurViewExtension.swift
//  weatherApp
//
//  Created by Pranav Pratap on 31/08/23.
//

import Foundation
import UIKit

extension HomeViewController {
    func applyBlurEffect() {
        screen1TableView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView?.alpha = 0.7
        }
    }
    
    func blurViewSetup(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.lightGray .cgColor,UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.05, 1.0]
        
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView!.contentView.layer.addSublayer(gradientLayer)
        blurEffectView!.frame = outerBlurView.bounds
        outerBlurView.addSubview(blurEffectView!)
        blurEffectView?.alpha = 0
    }
    
    func removeBlurEffect() {
        UIView.animate(withDuration: 0.4) {
            self.blurEffectView?.alpha = 0
        } completion: { _ in
            self.screen1TableView.isUserInteractionEnabled = true
        }
    }
}
