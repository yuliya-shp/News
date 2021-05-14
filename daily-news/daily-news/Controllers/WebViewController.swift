//
//  WebViewController.swift
//  daily-news
//
//
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var articleUrl: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: URL(string: articleUrl)!))
    }

}
