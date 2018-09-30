//
//  FetchArticleListService.swift
//  HackerNewsApp
//
//  Created by Nishu Priya on 9/29/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation

protocol FetchArticleListProtocol {
    func fetchTopStory(completionHandler: ((Error?, [Int]?) -> Void)?)
}
class FetchArticleListService: FetchArticleListProtocol {
    
    let urlString = "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
    
    func fetchTopStory(completionHandler: ((Error?, [Int]?) -> Void)?) {
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                completionHandler?(error, nil)
                return
            }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode([Int].self, from:
                    data!) //Decode JSON Response Data
                print("model = \(model)")
                completionHandler?(nil, model)
            } catch let parsingError {
                completionHandler?(parsingError, nil)
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
