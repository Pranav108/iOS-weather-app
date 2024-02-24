//
//  CommonWebViewController.swift
//  weatherApp
//
//  Created by Pranav Pratap on 23/02/24.
//

import UIKit
import WebKit

enum WebViewType: String {
    case autherGithubInfo = "https://github.com/Pranav108"
    case sourceCodeRepo = "https://github.com/Pranav108/iOS-weather-app/"
    case autherPortfolio = "https://pranav108.github.io/portfolio"
    case none
}

class CommonWebViewController: UIViewController {
    var webViewType: WebViewType = .none
    
    @IBOutlet weak var commonWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWebView(for: webViewType)
    }
    
    private func loadWebView(for webViewType: WebViewType){
        let urlStr = URL(string: webViewType.rawValue)!
        let request = URLRequest(url: urlStr)
        self.commonWebView.load(request)
    }
}
