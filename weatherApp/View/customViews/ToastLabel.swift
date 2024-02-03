//
//  ToastLabel.swift
//  weatherApp
//
//  Created by Pranav Pratap on 19/07/23.
//

import Foundation
import UIKit

class ToastLabel : UILabel {
    
    let padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let height = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
