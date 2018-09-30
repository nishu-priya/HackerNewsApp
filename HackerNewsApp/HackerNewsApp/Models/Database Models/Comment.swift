//
//  Comment.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/29/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
import RealmSwift

class Comment: Object, Codable {
    @objc dynamic var id: Int = 0
    @objc dynamic var text: String = "" // userName
    @objc dynamic var time: Int = 0 //in Unix Time.
    @objc dynamic var by: String = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
}


