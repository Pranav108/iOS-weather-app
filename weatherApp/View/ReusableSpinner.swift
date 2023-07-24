//
//  ReusableSpinner.swift
//  weatherApp
//
//  Created by Pranav Pratap on 24/07/23.
//

import UIKit

//class ReusableSpinner: UIActivityIndicatorView {
//
//    /*
//     // Only override draw() if you perform custom drawing.
//     // An empty implementation adversely affects performance during animation.
//     override func draw(_ rect: CGRect) {
//     // Drawing code
//     }
//     */
//
//    private let innerSpinner : UIActivityIndicatorView = {
//        let spinner = UIActivityIndicatorView(style: .large)
//        spinner.color = .darkGray
//        spinner.translatesAutoresizingMaskIntoConstraints = false
//        //        spinner.frame.size = CGSize(width: 200, height: 200)
//        return spinner
//    }()
//
//    override func didMoveToSuperview() {
//
//        guard let superview = superview else {
//            print("SuperView doesn't exist")
//            return
//        }
//
//        NSLayoutConstraint.activate([
//            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
//
//            widthAnchor.constraint(equalTo: superview.widthAnchor , multiplier: 0.4),
//            heightAnchor.constraint(equalTo: superview.widthAnchor , multiplier: 0.4),
//        ])
//    }
//    func startSpinning(){
//        innerSpinner.startAnimating()
//    }
//    func stopSpinning(){
//        innerSpinner.stopAnimating()
//    }
//
//}

import UIKit

class CustomSpinnerView: UIView {
    private var spinner: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpinner()
    }
  
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSpinner()
    }

    private func setupSpinner() {
        // Create the spinner instance and set its style
        spinner = UIActivityIndicatorView(style: .large)

        // Customize the spinner's properties as needed
        spinner.color = .blue // Change the color to blue
        spinner.hidesWhenStopped = true // Hide the spinner when it's not animating

        // Calculate the desired size for the spinner
        let spinnerSize: CGFloat = 200.0

        // Set the frame of the spinner to be in the center of the view
        spinner.frame = CGRect(x: (bounds.width - spinnerSize) / 2,
                               y: (bounds.height - spinnerSize) / 2,
                               width: spinnerSize,
                               height: spinnerSize)

        addSubview(spinner)
    }

    func startASpinning() {
        spinner.startAnimating()
    }

    func stopSpinning() {
        spinner.stopAnimating()
    }
}
