//
//  APIArticle.swift
//  MVVMApp
//
//  Created by Abhinav Singh on 10/1/18.
//  Copyright © 2018 Abhinav. All rights reserved.
//

import Foundation

class APIArticle:NSObject{
    
    /**
     getFacilities
     
     - parameter completionHandler:        (AnyObject response, NSError)
     */
    func getArticle(_ parameters:[String:AnyObject]?,_ completionHandler:@escaping ((AnyObject?,NSError?)->Void)){
        
        var page = 1;
        if let para = parameters {
            if let pg = para["page"] as? Int
            {
                page = pg;
            }
            
        }
        
        APIHelper.makeRequest(urlString: "https://newsapi.org/v2/everything?q=apple&pageSize=10&page=\(page)&sortBy=popularity&apiKey=3363a374df9f4660a260a187915f0937", verb: .GET, parameters: nil, headers: nil,type:"JSON",completionHandler: completionHandler)
        
    }
    
}
