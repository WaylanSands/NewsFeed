//
//  WebViewController.swift
//  NewsFeed
//
//  Created by Waylan Sands on 18/5/2023.
//

import WebKit
import UIKit

/// A simple UIViewController that contains a WKWebView and loads url on viewDidLoad.
final class WebViewController: UIViewController {
    
    private lazy var webView: WKWebView? = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        loadArticle()
    }
    
    private func configureSubviews() {
        view.addSubview(webView!)
        webView!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView!.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
    
    private func loadArticle() {
        let request = URLRequest(url: url)
        webView?.load(request)
    }
}
