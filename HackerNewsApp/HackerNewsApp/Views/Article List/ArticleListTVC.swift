//
//  ArticleListTVC.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/29/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

class ArticleListTVC: UITableViewCell, ArticleListTVCViewModelDelegate {
    static let reuseID: String = "ArticleListTVC"
    var viewModel: ArticleListTVCViewModel?
    
    // MARK: IBOutlets
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var sourceUrlLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    func configure(articleId: Int) {
        viewModel = ArticleListTVCViewModel(id: articleId)
        viewModel?.delegate = self
        if let story = self.viewModel?.story() {
            self.voteCountLabel.text = "\(story.score)"
            self.commentCountLabel.text = "\(story.descendants)"
            self.articleTitleLabel.text = story.title
            self.sourceUrlLabel.text = story.url
            self.userLabel.text = ". \(story.by)"
            let time = Utils.timeFromUnix(time: story.time)
            self.timeLabel.text = Utils.offsetFrom(time)
        }
        self.selectionStyle = .none
    }
    
    // MARK: ArticleListTVCViewModelDelegate
    func fetchCompletedWithError(error: Error) {
        // print error
    }
    func articleFetchCompleted() {
        DispatchQueue.main.async {
            if let story = self.viewModel?.story() {
                self.voteCountLabel.text = "\(story.score)"
                self.commentCountLabel.text = "\(story.descendants)"
                self.articleTitleLabel.text = story.title
                self.sourceUrlLabel.text = story.url
                self.userLabel.text = ". \(story.by)"
                let time = Utils.timeFromUnix(time: story.time)
                self.timeLabel.text = Utils.offsetFrom(time)
                self.setNeedsDisplay()
                self.setNeedsLayout()
            }
        }
    }
}
