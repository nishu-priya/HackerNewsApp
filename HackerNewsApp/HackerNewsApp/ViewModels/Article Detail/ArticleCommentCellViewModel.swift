//
//  ArticleCommentCellViewModel.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation

class ArticleCommentCellViewModel {
    var commentId: Int = 0
    var taskId: Int?
    
    init(id: Int) {
        self.commentId = id
    }
    func comment() -> Comment? {
        return DBUtils.getCommentFor(id: commentId)
    }
}
