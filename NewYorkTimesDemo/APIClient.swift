//
//  APIClient.swift
//  NewYorkTimesDemo
//
//  Created by Ethan Chen on 10/27/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class APIClient: NSObject {
    static let shared = APIClient()
    let apiKey = "50d2398ce01a45d89a6da1be6468772f"
    let url = "https://api.nytimes.com/svc/books/v3/lists/names.json"
    
    var userCacheURL: URL?
    let userCacheQueue = OperationQueue()
    
    var userCacheURL2: URL?
    let userCacheQueue2 = OperationQueue()
    
    func fetchAllCategories(completion: @escaping (CategoryList) -> Void) {
        
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            userCacheURL = cacheURL.appendingPathComponent("category.json")
        }
        
        guard let url = URL(string: url) else {
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: ["api-key" : "50d2398ce01a45d89a6da1be6468772f"
                                       ])
        .validate()
        .responseObject { (response: DataResponse<CategoryList>) in
            if let weatherResponse = response.result.value {
                completion(weatherResponse)
                if (self.userCacheURL != nil) {
                    self.userCacheQueue.addOperation() {
                        if let stream = OutputStream(url: self.userCacheURL!, append: false) {
                            stream.open()
                            JSONSerialization.writeJSONObject(weatherResponse.toJSON(), to: stream, options: [.prettyPrinted], error: nil)
                            stream.close()
                        }
                    }
                }
            }
            else if (self.userCacheURL != nil) {
                // Read the data from the cache
                self.userCacheQueue.addOperation() {
                    if let stream = InputStream(url: self.userCacheURL!) {
                        stream.open()
                        if let data = (try? JSONSerialization.jsonObject(with: stream, options: [])) as? [String: Any] {
                            completion(CategoryList(JSON: data)!)
                        }
                        stream.close()
                    }

                }
            }
        }
    }
    
    
    func fetchBooksofCategory(category: String, completion: @escaping (BookList) -> Void) {
        if let cacheURL2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            userCacheURL2 = cacheURL2.appendingPathComponent("\(category).json")
        }
        guard let url = URL(string: "https://api.nytimes.com/svc/books/v3/lists.json") else {
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: ["api-key" : "50d2398ce01a45d89a6da1be6468772f",
                                       "list" : category])
            .validate()
            .responseObject { (response: DataResponse<BookList>) in
                if let weatherResponse = response.result.value {
                    completion(weatherResponse)
                    if (self.userCacheURL2 != nil) {
                        self.userCacheQueue2.addOperation() {
                            if let stream = OutputStream(url: self.userCacheURL2!, append: false) {
                                stream.open()
                                JSONSerialization.writeJSONObject(weatherResponse.toJSON(), to: stream, options: [.prettyPrinted], error: nil)
                                stream.close()
                            }
                        }
                    }
                }
                else if (self.userCacheURL2 != nil) {
                    // Read the data from the cache
                    self.userCacheQueue2.addOperation() {
                        if let stream = InputStream(url: self.userCacheURL2!) {
                            stream.open()
                            if let data = (try? JSONSerialization.jsonObject(with: stream, options: [])) as? [String: Any] {
                                completion(BookList(JSON: data)!)
                            }
                            stream.close()
                        }
                        
                    }
                }
        }
 
        }
    
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
