//
//  Book.swift
//  NewYorkTimesDemo
//
//  Created by Ethan Chen on 10/27/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
import ObjectMapper
class BookList: Mappable{
    
    var num_results: Int?
    var results: [Book]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        num_results <- map["num_results"]
        results <- map["results"]
    }
    
}
class Book: Mappable{
    
    var amazon_product_url: String?
    var weeks_on_list: Int?
    var rank_last_week: Int?
    var rank: Int?
    var book_details: [BookDetail]?
    var reviews: [Review]?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        amazon_product_url <- map["amazon_product_url"]
        weeks_on_list <- map["weeks_on_list"]
        rank_last_week <- map["rank_last_week"]
        rank <- map["rank"]
        book_details <- map["book_details"]
        reviews <- map["reviews"]
    }
    
}

class BookDetail: Mappable{
    
    var title: String?
    var description: String?
    var contributor: String?
    var author: String?
    var price: Int?
    var publisher: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        description <- map["description"]
        contributor <- map["contributor"]
        author <- map["author"]
        price <- map["price"]
        publisher <- map["publisher"]
    }
    
}

class Review: Mappable{
    
    var book_review_link: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        book_review_link <- map["book_review_link"]
    }
    
}
