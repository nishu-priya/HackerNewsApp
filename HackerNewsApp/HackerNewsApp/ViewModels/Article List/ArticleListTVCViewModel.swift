//
//  ArticleListTVCViewModel.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
protocol ArticleListTVCViewModelDelegate: class {
    func fetchCompletedWithError(error: Error)
    func articleFetchCompleted()
}
class ArticleListTVCViewModel {
    var articleId: Int = 0
    weak var delegate: ArticleListTVCViewModelDelegate?
    var taskId: Int?
    
    init(id: Int) {
        self.articleId = id
//        fetchArticle()
    }
    
//    func fetchArticle() {
//       taskId = ArticleDownloader.downloadArticle(id: articleId) { (error, story) in
//            if let error = error {
//                self.delegate?.fetchCompletedWithError(error: error)
//            }
//            if let story = story {
//                DBUtils.insertStory(story: story)
//                self.delegate?.articleFetchCompleted()
//            }
//        }
//    }
    func story() -> Story? {
        return DBUtils.getStoryFor(id: articleId)
    }
}
