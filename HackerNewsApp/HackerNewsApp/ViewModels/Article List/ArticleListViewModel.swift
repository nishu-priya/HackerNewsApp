//
//  ArticleListViewModel.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
protocol ArticleListViewModelDelegate: class {
    func articleListFetched()
    func fetchCompletedWithError(error: Error)
    func articleFetchCompleted(row: Int)
}

class ArticleListViewModel {
    
    var articleIds: [Int] = []
    weak var delegate: ArticleListViewModelDelegate?
    var taskIds:[Int] = []
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
       return articleIds.count
    }
    
    func fetchTopArticles() {
        FetchArticleListService().fetchTopStory { (error, list) in
            if let error = error {
                self.delegate?.fetchCompletedWithError(error: error)
            }
            if let list = list {
                self.articleIds = list
                self.taskIds = Array(repeating: 0, count: list.count)
                self.delegate?.articleListFetched()
            }
        }
    }
    
    func fetchArticle(row: Int) {
        if let _ = DBUtils.getStoryFor(id: articleIds[row]) {
            self.delegate?.articleFetchCompleted(row: row)
            return
        }
        let taskId = ArticleDownloader.downloadArticle(id: articleIds[row]) { (error, story) in
            if let error = error {
                self.delegate?.fetchCompletedWithError(error: error)
            }
            if let story = story {
                DBUtils.insertStory(story: story)
                self.delegate?.articleFetchCompleted(row: row)
            }
        }
        self.taskIds[row] = taskId ?? 0
    }
    func story(row: Int) -> Story? {
        return DBUtils.getStoryFor(id: articleIds[row])
    }
    
    func cancelTaskIfAnyForRow(row: Int) {
        let taskid = self.taskIds[row]
        if taskid == 0 {
            return
        }
        ArticleDownloader.cancelTaskWith(identifier: taskid)
        self.taskIds[row] = 0
    }
    func commentIds(row: Int) -> [Int] {
        if let story = DBUtils.getStoryFor(id: articleIds[row]) {
            return Array(story.kids)
        }
        return []
    }
}
