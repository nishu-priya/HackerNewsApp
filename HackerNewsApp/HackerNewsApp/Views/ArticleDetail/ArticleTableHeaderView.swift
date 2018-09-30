//
//  ArticleTableHeaderView.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

protocol ArticleTableHeaderViewDelagate: class {
    func articleViewTapped()
    func commentsViewTapped()
}
class ArticleTableHeaderView: UIView {
    // MARK: Constants
    static let kHeaderHeight: CGFloat = 173.0
    weak var delegate: ArticleTableHeaderViewDelagate?
    
    // MARK: IBOUtlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentSeparatorView: UIView!
    @IBOutlet weak var articleView: UIView!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var articleSeparatorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ArticleTableHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let commentViewTap = UITapGestureRecognizer(target: self, action: #selector(handleCommentViewTap(_:)))
        commentView.addGestureRecognizer(commentViewTap)
        let articleViewTap = UITapGestureRecognizer(target: self, action: #selector(handleArticleViewTap(_:)))
        articleView.addGestureRecognizer(articleViewTap)
    }
    
    func selectCommentsView() {
        commentSeparatorView.isHidden = false
        articleSeparatorView.isHidden = true
    }
    func selectArticleView() {
        commentSeparatorView.isHidden = true
        articleSeparatorView.isHidden = false
    }
    func hideCommentArticleView() {
        articleView.isHidden = true
    }
    
    func configureFromStoryId(id: Int ) {
        if let story = DBUtils.getStoryFor(id: id) {
            titleLabel.text = story.title
            urlLabel.text = story.url
            userNameLabel.text = ". \(story.by)"
            let time = Utils.timeFromUnix(time: story.time)
            self.timeLabel.text = Utils.offsetFrom(time)
            self.commentLabel.text = "\(story.descendants) Comments"
            if story.url == "" {
                hideCommentArticleView()
            }
            selectCommentsView()
        }
    }
    
    @objc func handleCommentViewTap(_ gestureRecog: UIGestureRecognizer) {
        if commentSeparatorView.isHidden {
            selectCommentsView()
            delegate?.commentsViewTapped()
        }
        print("comment view tap")
    }
    @objc func handleArticleViewTap(_ gestureRecog: UIGestureRecognizer) {
        if articleSeparatorView.isHidden {
            selectArticleView()
            delegate?.articleViewTapped()
        }
        print("article view tap")
    }
}
