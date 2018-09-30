//
//  ArticleContentCell.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//
import WebKit
import UIKit

class ArticleContentCell: UITableViewCell {

    static let kReuseId = "ArticleContentCell"
    @IBOutlet weak var webview: WKWebView!
    var url: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func loadUrl() {
        if url != "" {
            webview.load(URLRequest(url: URL(string: url)!))
        }
    }

}
