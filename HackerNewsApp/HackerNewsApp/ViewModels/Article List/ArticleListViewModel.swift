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
    var taskId: Int?
    
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
                self.delegate?.articleListFetched()
            }
        }
    }
    
    func fetchArticle(row: Int) {
        if let _ = DBUtils.getStoryFor(id: articleIds[row]) {
            self.delegate?.articleFetchCompleted(row: row)
            return
        }
        taskId = ArticleDownloader.downloadArticle(id: articleIds[row]) { (error, story) in
            if let error = error {
                self.delegate?.fetchCompletedWithError(error: error)
            }
            if let story = story {
                DBUtils.insertStory(story: story)
                self.delegate?.articleFetchCompleted(row: row)
            }
        }
    }
    func story(row: Int) -> Story? {
        return DBUtils.getStoryFor(id: articleIds[row])
    }
    
    func commentIds(row: Int) -> [Int] {
        if let story = DBUtils.getStoryFor(id: articleIds[row]) {
            return Array(story.kids)
        }
        return []
    }
}
