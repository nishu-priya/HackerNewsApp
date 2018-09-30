//
//  ArticleCommentCell.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

class ArticleCommentCell: UITableViewCell  {
    
    static let kReuseId = "ArticleCommentCell"
    var viewModel: ArticleCommentCellViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(commentId: Int) {
        viewModel = ArticleCommentCellViewModel(id: commentId)
        if let comment = self.viewModel?.comment() {
            let time = Utils.timeFromUnix(time: comment.time)
            self.titleLabel.text = "\(Utils.offsetFrom(time)) . \(comment.by)"
            self.subtitleLabel.text = comment.text
        }
        self.selectionStyle = .none
    }
}
