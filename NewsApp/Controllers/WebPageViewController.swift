//
//  WebPageViewController.swift
//  NewsApp
//
//  
//

import UIKit
import WebKit

class WebPageViewController: UIViewController {

    var articleUrl: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: URL(string: articleUrl)!))
    }
    

}
