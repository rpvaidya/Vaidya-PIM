//
//  DBSync.swift
//  Vaidya PIM
//
//  Created by Vaidya, Raghavendra (GE Global Research) on 7/21/16.
//  Copyright © 2016 Vaidya, Raghavendra (GE Global Research). All rights reserved.
//

import Foundation
import UIKit


class DBSync: NSObject {
    
    
    let catURLString = NSString(format: "http://localhost:8080/getCategories")
    let getTagsForCatURL = "http://localhost:8080/getTagsForCategory?"
    let getDetailsForTagURL = "http://localhost:8080/getDetailsForTag?"
    var progressText: UILabel!
    
    
    
    func syncDataBAse() -> Bool {
        
        ModelManager.purgeDB()
        let cat : [String] = self.loadCategoryData()
        for category in cat {
            self.loadItemsForCategory(category)
            let tags : [String] = ModelManager.getTagsForCat(category)
            for tag in tags {
                let data : Dictionary<String,String> = self.getDataForTag(tag)
                ModelManager.updateTagData(tag,data: data)
                
            }
        }
        
        return true
    }
    
    
    func loadCategoryData() -> [String]{
        
        
        var categoryData : [String] = []
        let url: NSURL = NSURL(string: catURLString as String)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? [String] {
                    print("Synchronous\(jsonResult)")
                    categoryData = jsonResult
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        ModelManager.addCategories(categoryData)
        return categoryData
    }
    
    
    func loadItemsForCategory(cat: String) {
        let urlComponents = NSURLComponents(string: getTagsForCatURL)!
        urlComponents.queryItems = [
            NSURLQueryItem(name: "category", value: cat),
        ]
        let finalURL = urlComponents.URL?.absoluteString
        let url: NSURL = NSURL(string: finalURL! as String)!

        let request1: NSURLRequest = NSURLRequest(URL: url)

        var itemData : [String] = []
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? [String] {
                    print("Synchronous\(jsonResult)")
                    itemData = jsonResult
                    for i in 0..<itemData.count {
                        ModelManager.addTagsForCat(cat, tag: itemData[i])
                    }

                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        
    }
    

    
    
    func getDataForTag(item : String) -> Dictionary<String,String>{
        
        
        var itemDetails : Dictionary<String,String> = [:]
        let urlComponents = NSURLComponents(string: getDetailsForTagURL)!
        urlComponents.queryItems = [
            NSURLQueryItem(name: "tag", value: item),
        ]
        let finalURL = urlComponents.URL?.absoluteString
        let url: NSURL = NSURL(string: finalURL! as String)!
        
        let request1: NSURLRequest = NSURLRequest(URL: url)
        
        var itemData : [String] = []
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        
        
        do{
            
            let dataVal = try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            
            print(response)
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(dataVal, options: []) as? Dictionary <String,String> {
                    print("Synchronous\(jsonResult)")
                    itemDetails = jsonResult
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            
            
        }catch let error as NSError
        {
            print(error.localizedDescription)
        }
        return itemDetails
    }
    
}