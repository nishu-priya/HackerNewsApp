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
    var taskIds:[Int] = []
    var commentIds: [Int] = [] {
        didSet {
            self.taskIds = Array(repeating: 0, count: commentIds.count)
        }
    }
    var commentSelected: Bool = true
    
    init(id: Int) {
        self.articleId = id
    }
    
    func fetchComment(row: Int) {
        if DBUtils.getCommentFor(id: commentIds[row]) != nil {
            self.delegate?.commentFetchCompleted(row: row)
            return
        }
        let taskId = ArticleDownloader.downloadComment(id: commentIds[row]) { (error, comment) in
            if let error = error {
                self.delegate?.fetchCompletedWithError(error: error)
            }
            if let comment = comment {
                DBUtils.insertComment(comment: comment)
                self.delegate?.commentFetchCompleted(row: row)
            }
        }
        self.taskIds[row] = taskId ?? 0
    }
    func cancelTaskIfAnyForRow(row: Int) {
        let taskid = self.taskIds[row]
        if taskid == 0 {
            return
        }
        ArticleDownloader.cancelTaskWith(identifier: taskid)
        self.taskIds[row] = 0
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
