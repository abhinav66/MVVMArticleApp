//
//  Articles.swift
//  MVVMApp
//
//  Created by Abhinav Singh on 10/1/18.
//  Copyright © 2018 Abhinav. All rights reserved.
//

import UIKit

class Articles: NSObject {
    var author = ""
    var title = ""
    var desc = ""
    var url = ""
    var urlToImage = ""
    var publishedAt:Date?
    var content = ""
    
    class func mapJsonToModel(json:[String:AnyObject])->Articles{
        let article = Articles()
        
        if let author = json["author"] as? String {
            article.author = author;
        }
        
        if let title = json["title"] as? String {
            article.title = title;
        }
        
        if let desc = json["description"] as? String {
            article.desc = desc;
        }
        
        if let url = json["url"] as? String {
            article.url = url;
        }
        
        if let urlToImage = json["urlToImage"] as? String {
            article.urlToImage = urlToImage;
        }
        
        if let publishedAt = json["publishedAt"] as? String {
            article.publishedAt = getDateFromString(publishedAt);
        }
        
        if let content = json["content"] as? String {
            article.content = content;
        }
        
        return article;
    }
    
    
    class func getDateFromString(_ dateString:String)->Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let date = dateFormatter.date(from: dateString){
            return date
        }else{
            return nil
        }
    }

}
