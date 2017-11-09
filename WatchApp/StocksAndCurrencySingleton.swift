//
//  StocksAndCurrencySingleton.swift
//  WatchApp
//      Design for Singleton pattern for project (reference : https://github.com/hpique/SwiftSingleton)
//
//  Created by Joseph Nicholas R. Alcantara on 26/03/2017.
//  Copyright © 2017 Joseph Nicholas R. Alcantara. All rights reserved.
//

import Foundation
let constantNotifUpdate = "stocksUpdate";
class StocksAndCurrencySingleton{
    
    //Initialize Singleton pattern
    class var sharedInstance: StocksAndCurrencySingleton {
        struct Static{
            static let instance : StocksAndCurrencySingleton = StocksAndCurrencySingleton();
        }
        return Static.instance;
    }
    func updateListOfSymbols(stocks:Array<(String, Double)>) -> () {
        //construct query for yahoo API.
        var quotesString = "(";
        for quoteTable in stocks
        {
            quotesString += "\""+quoteTable.0+"\",";
        }
        quotesString = quotesString.substring(to: quotesString.index(before: quotesString.endIndex));
        quotesString += ")";
        
        let stringURL:String = ("http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.quotes where symbol in "+quotesString+"&format=json&env=store://datatables.org/alltableswithkeys").addingPercentEscapes(using: String.Encoding.utf8)!;
        
        print("REST URL + \(stringURL)");
        
        var cURL: URL = URL(string: stringURL)!;
        
        var stringRequest:URLRequest = URLRequest(url: cURL);
        let configSession = URLSessionConfiguration.default;
        let urlSession = URLSession(configuration: configSession);
        
        //Close url for URL Session.
        let sessionTask : URLSessionDataTask = urlSession.dataTask(with: stringRequest) { (data, response, error) -> Void in
            if(error != nil)
            {
                print(error?.localizedDescription);
            }
                var err: Error?;
                do{
                var jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary;
                    
                    var quotes:NSArray = ((jsonDict.object(forKey: "query") as! NSDictionary).object(forKey: "results") as! NSDictionary).object(forKey: "quote") as! NSArray;
                    
                    DispatchQueue.main.async(execute:{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: constantNotifUpdate), object: nil, userInfo: [constantNotifUpdate:quotes]);
                    
                        })
                }
                catch{
                    print("JSON Error + \(err?.localizedDescription)");
                }
        }
        sessionTask.resume();
        
    }
}
