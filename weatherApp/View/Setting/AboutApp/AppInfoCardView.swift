//
//  AppInfoCardView.swift
//  weatherApp
//
//  Created by Pranav Pratap on 02/02/24.
//

import UIKit

class AppInfoCardView: UIView {
    
    // MARK: IB-Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var appInfoLabel: UILabel!
    @IBOutlet weak var authorInfoButton: UIButton!
    @IBOutlet weak var sourceCodeLabel: UIButton!
    
    // MARK: class properties
    var crossedCallBack : (() -> Void)?
    private var blurViewHideCallBack : (() -> Void)?
    private var contentViewFrame : CGRect {
        let width: CGFloat  = 340
        let height: CGFloat = 420
        let horizontalMargin = (frame.width - width ) / 2
        let verticalMargin = (frame.height - height ) / 2
        return CGRect(x: horizontalMargin, y: verticalMargin, width: width, height: height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private setup methods
    private func loadXib(){
        Bundle.main.loadNibNamed("AppInfoCardView", owner: self)
        blurViewSetup()
        contentViewSetup()
        setupOtherViews()
    }

    private func contentViewSetup() {
        contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = .identity
        }
        addSubview(contentView)
        contentView.frame = contentViewFrame
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func blurViewSetup() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = frame
        addSubview(blurView)
        blurViewHideCallBack = {
            blurView.removeFromSuperview()
        }
    }
    
    private func setupOtherViews(){
        // ImageView
        imageView.image = UIImage(named: "weather-app-with-shadow.png")
        
        // AppNameLabel
        appNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        appNameLabel.text = "Weather-App"
        
        // AppVersionLabel
        appVersionLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .light)
        appVersionLabel.text = "Version 2.0"
        appVersionLabel.textColor = .darkGray
        
        // AppInfoLabel
        appInfoLabel.text = "A simple weather app to fetch weather update of given/current city."
        
        // AuthorInfoButton
        authorInfoButton.setTitleColor(.systemPink, for: .normal)
        authorInfoButton.setTitle("AUTHOR-INFO", for: .normal)
        
        // SourceCodeLabel
        sourceCodeLabel.backgroundColor = .blue
        sourceCodeLabel.setTitle("BUY-SOURCE-CODE", for: .normal)
    }
    
    // MARK: IB-Actions
    @IBAction func closePopupTapped(_ sender: UIButton) {
        blurViewHideCallBack?()
        contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        } completion: { _ in
            self.contentView.removeFromSuperview()
        }
        crossedCallBack?()
        print(#function)
    }
    
    @IBAction func openSourceCode(_ sender: UIButton) {
        print(#function)
    }
    
    
}
