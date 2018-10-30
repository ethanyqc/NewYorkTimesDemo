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
    //define constants
    let apiKey = "50d2398ce01a45d89a6da1be6468772f"
    let urlCategories = "https://api.nytimes.com/svc/books/v3/lists/names.json"
    let urlBooks = "https://api.nytimes.com/svc/books/v3/lists.json"
    
    //cache url for cacheing the categories
    var categoriesCacheURL: URL?
    let categoriesCacheQueue = OperationQueue()
    
    //cache url for cacheing the books
    var booksCacheURL: URL?
    let booksCacheQueue = OperationQueue()
    
    //completion handler for fetch all the categories
    func fetchAllCategories(completion: @escaping (CategoryList) -> Void) {
        
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            categoriesCacheURL = cacheURL.appendingPathComponent("category.json")
        }
        
        guard let url = URL(string: urlCategories) else {
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: ["api-key" : apiKey
                                       ])
        .validate()
        .responseObject { (response: DataResponse<CategoryList>) in
            if let value = response.result.value {
                completion(value)
                //save the data to the cache when get response by output stream
                if (self.categoriesCacheURL != nil) {
                    self.categoriesCacheQueue.addOperation() {
                        if let stream = OutputStream(url: self.categoriesCacheURL!, append: false) {
                            stream.open()
                            JSONSerialization.writeJSONObject(value.toJSON(), to: stream, options: [.prettyPrinted], error: nil)
                            stream.close()
                        }
                    }
                }
            }
            else if (self.categoriesCacheURL != nil) {
                // retrive the data from the cache if no response
                self.categoriesCacheQueue.addOperation() {
                    if let stream = InputStream(url: self.categoriesCacheURL!) {
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
    
    //completion handler for fetch all the book of the chosen input of category
    func fetchBooksofCategory(category: String, completion: @escaping (BookList) -> Void) {
        if let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last {
            booksCacheURL = cacheURL.appendingPathComponent("\(category).json")
        }
        guard let url = URL(string: urlBooks) else {
            return
        }
        Alamofire.request(url,
                          method: .get,
                          parameters: ["api-key" : apiKey,
                                       "list" : category])
            .validate()
            .responseObject { (response: DataResponse<BookList>) in
                if let value = response.result.value {
                    completion(value)
                    //save the data to the cache when get response by output stream
                    if (self.booksCacheURL != nil) {
                        self.booksCacheQueue.addOperation() {
                            if let stream = OutputStream(url: self.booksCacheURL!, append: false) {
                                stream.open()
                                JSONSerialization.writeJSONObject(value.toJSON(), to: stream, options: [.prettyPrinted], error: nil)
                                stream.close()
                            }
                        }
                    }
                }
                else if (self.booksCacheURL != nil) {
                    // retrive the data from the cache if no response from input stream
                    self.booksCacheQueue.addOperation() {
                        if let stream = InputStream(url: self.booksCacheURL!) {
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

//extention for tableview to display empty data msg
extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        self.backgroundView = nil
        let emptMsg = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        emptMsg.text = message
        emptMsg.textColor = .black
        emptMsg.numberOfLines = 0
        emptMsg.textAlignment = .center
        emptMsg.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        emptMsg.sizeToFit()
        self.backgroundView = emptMsg
    }
    
    //remove the messge
    func removeMsg() {
        self.backgroundView = nil
    }
}
