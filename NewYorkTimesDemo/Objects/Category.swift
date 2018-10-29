//
//  Category.swift
//  NewYorkTimesDemo
//
//  Created by Ethan Chen on 10/27/18.
//  Copyright © 2018 Ethan Chen. All rights reserved.
//

import Foundation
import ObjectMapper

class CategoryList: Mappable{
    var num_results: Int?
    var results: [Category]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        num_results <- map["num_results"]
        results <- map["results"]
    }
    
}

class Category: Mappable{
    
    
    var list_name: String?
    var display_name: String?
    var list_name_encoded: String?
    var oldest_published_date: String?
    var newest_published_date: String?
    var updated: String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        list_name <- map["list_name"]
        display_name <- map["display_name"]
        list_name_encoded <- map["list_name_encoded"]
        oldest_published_date <- map["oldest_published_date"]
        newest_published_date <- map["newest_published_date"]
        updated <- map["updated"]
    }
    
}


