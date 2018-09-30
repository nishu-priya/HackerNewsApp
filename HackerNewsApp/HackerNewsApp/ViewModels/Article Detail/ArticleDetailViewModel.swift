//
//  ArticleDetailViewModel.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
protocol ArticleDetailViewModelDelegate: class {
    func fetchCompletedWithError(error: Error)
    func commentFetchCompleted(row: Int)
}
class ArticleDetailViewModel {
    var articleId: Int = 0
    weak var delegate: ArticleDetailViewModelDelegate?
    var taskId: Int?
    var commentIds: [Int] = []
    var commentSelected: Bool = true
    
    init(id: Int) {
        self.articleId = id
    }
    
    func fetchComment(row: Int) {
        if let comment = DBUtils.getCommentFor(id: commentIds[row]) {
            self.delegate?.commentFetchCompleted(row: row)
            return
        }
        taskId = ArticleDownloader.downloadComment(id: commentIds[row]) { (error, comment) in
            if let error = error {
                self.delegate?.fetchCompletedWithError(error: error)
            }
            if let comment = comment {
                DBUtils.insertComment(comment: comment)
                self.delegate?.commentFetchCompleted(row: row)
            }
        }
    }
    func comment(row: Int) -> Comment? {
        return DBUtils.getCommentFor(id: commentIds[row])
    }
    
    func getUrl() -> String {
        if let story = DBUtils.getStoryFor(id: articleId) {
            return story.url
        }
        return ""
    }
}
