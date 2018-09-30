//
//  Story.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/29/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import RealmSwift

class Story: Object, Decodable {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var by: String = "" // userName
    @objc dynamic var time: Int = 0 //in Unix Time.
    var kids: List<Int> = List<Int>() //comments ids
    @objc dynamic var url: String = "" //The URL of the story.
    @objc dynamic var title: String = ""
    @objc dynamic var score: Int = 0
    @objc dynamic var descendants: Int = 0 //comments counts.
    
    private enum CodingKeys: String, CodingKey {
        case  id
        case  by
        case  time
        case  kids
        case  url
        case  title
        case  score
        case  descendants
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()

        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        by = try container.decode(String.self, forKey: .by)
        time = try container.decode(Int.self, forKey: .time)
        score = try container.decode(Int.self, forKey: .score)
        descendants = try container.decode(Int.self, forKey: .descendants)
        do {
            url = try container.decode(String.self, forKey: .url)
        } catch let parsingError {
            url = ""
            print("Error", parsingError)
        }
        title = try container.decode(String.self, forKey: .title)
        let pictures = try container.decodeIfPresent([Int].self, forKey: .kids) ?? []
        kids.append(objectsIn: pictures)
    }
    override class func primaryKey() -> String {
        return "id"
    }

}
