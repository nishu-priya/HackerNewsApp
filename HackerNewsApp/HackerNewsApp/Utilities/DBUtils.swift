//
//  DBUtils.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
import RealmSwift

struct DBUtils {
    // MARK: insert operations
    static func insertStory(story: Story) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(story, update: true)
        try! realm.commitWrite()
    }
    static func insertComment(comment: Comment) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(comment, update: true)
        try! realm.commitWrite()
    }
    
    // MARK: fetch operations
    static func getStoryFor(id: Int) -> Story? {
        guard let realm = try? Realm() else { return nil }
        realm.refresh()
        return realm.object(ofType: Story.self, forPrimaryKey: id)
    }
    
    static func getCommentFor(id: Int) -> Comment? {
        guard let realm = try? Realm() else { return nil }
        realm.refresh()
        return realm.object(ofType: Comment.self, forPrimaryKey: id)
    }
}
