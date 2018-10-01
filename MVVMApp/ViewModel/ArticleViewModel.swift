//
//  ArticleViewModel.swift
//  MVVMApp
//
//  Created by Abhinav Singh on 10/1/18.
//  Copyright © 2018 Abhinav. All rights reserved.
//

import Foundation
import CoreData

class ArticleViewModel {
    
    var articles:[Articles] = []
    var totalResults = 0;
    
    func getArticlesFromAPI(_ page:Int,completionHandler:@escaping (Bool) -> Void){
        
        let api = APIArticle()
        articles = []
        let parameters = ["page":page as AnyObject];
        api.getArticle(parameters) {[weak self](data:AnyObject?,error:NSError?) in
            print(data)
            if error == nil {
                if let jsonData = data as? [String:AnyObject] {
                    if let total = jsonData["totalResults"] as? Int{
                        self?.totalResults = total
                    }
                    
                    if let articles = jsonData["articles"] as? [[String:AnyObject]]{
                        for article in articles{
                            let art = Articles.mapJsonToModel(json: article)
                            if let _ = art.publishedAt {
                               self?.articles.append(art)
                            }
                        }
                    }
                    
                    completionHandler(true)
                }else {
                    completionHandler(false)
                }
                
            }else {
                completionHandler(false)
            }
        }
    }
    
}

