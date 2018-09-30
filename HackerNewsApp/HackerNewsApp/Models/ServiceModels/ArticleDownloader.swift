//
//  ArticleDownloader.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/30/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation

class ArticleDownloader {
    static var ongoingTasks: [URLSessionTask] = []
    class func cancelTaskWith(identifier: Int) {
        let tasks =  ongoingTasks.filter({task in
            if task.taskIdentifier == identifier {
                return true
            } else {
                return false
            }
        })
        for task in tasks {
            print("cancelling task with id = \(task.taskIdentifier)")
            task.cancel()
        }
    }
    class func downloadArticle(id: Int, completion: ((Error?, Story?)-> Void)?) -> Int? {
        let urlString = "https://hacker-news.firebaseio.com/v0/item/\(id).json?print=pretty"
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                completion?(error, nil)
                return
            }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(Story.self, from:
                    data!) //Decode JSON Response Data
                print("model = \(model)")
                completion?(nil, model)
            } catch let parsingError {
                completion?(parsingError, nil)
                print("Error", parsingError)
            }
        }
        task.resume()
        ongoingTasks.append(task)
        print("\(task.taskIdentifier)")
        return task.taskIdentifier
    }
    
    class func downloadComment(id: Int, completion: ((Error?, Comment?)-> Void)?) -> Int? {
        let urlString = "https://hacker-news.firebaseio.com/v0/item/\(id).json?print=pretty"
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                completion?(error, nil)
                return
            }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(Comment.self, from:
                    data!) //Decode JSON Response Data
                print("model = \(model)")
                completion?(nil, model)
            } catch let parsingError {
                completion?(parsingError, nil)
                print("Error", parsingError)
            }
        }
        task.resume()
        ongoingTasks.append(task)
        print("\(task.taskIdentifier)")
        return task.taskIdentifier
    }
}

