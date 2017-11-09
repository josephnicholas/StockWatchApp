//
//  ViewController.swift
//  WatchApp
//
//  Created by Joseph Nicholas R. Alcantara on 26/03/2017.
//  Copyright © 2017 Joseph Nicholas R. Alcantara. All rights reserved.
//

import UIKit

class StocksAndCurrencyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Sample Stocks
    private var sampleStocks: [(String, Double)] = [("GOOG", +2.2), ("YHOO", +3.22), ("AAPL", -4.1), ("WFC", 0.0), ("BAC", 0.0), ("JPM", 0.0)];

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(self.stocksUpdated(notification:)), name: NSNotification.Name(rawValue: constantNotifUpdate), object: nil)
        self.updateStocks()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Start UI Table Code.
    //UITableDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sampleStocks.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cellId");
        cell.textLabel?.text = sampleStocks[indexPath.row].0;
        cell.detailTextLabel?.text = "\(sampleStocks[indexPath.row].1)" + "%";
        
        return cell;
    }
    
        //UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let _:StocksAndCurrencySingleton = StocksAndCurrencySingleton.sharedInstance;
        //managerSingleton.printTest();
    }
    //Customize UI for Tables
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        switch sampleStocks[indexPath.row].1 {
        case let x where x < 0.0:
            cell.backgroundColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0);
        case let x where x > 0.0:
            cell.backgroundColor = UIColor(red: 76.0/255.0, green: 217.0/255.0, blue: 100.0/255.0, alpha: 1.0);
        case let _:
            cell.backgroundColor = UIColor(red: 44.0/255.0, green: 186.0/255.0, blue: 231.0/255.0, alpha: 1.0);
        }
        
        //Cell by Cell coloring
        cell.textLabel?.textColor = UIColor.darkGray;
        cell.detailTextLabel?.textColor = UIColor.darkGray;
        cell.textLabel?.font = UIFont(name: "San Francisco", size: 48);
        cell.detailTextLabel?.font = UIFont(name: "San Francisco", size: 48);
        cell.textLabel?.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25);
        cell.textLabel?.shadowOffset = CGSize(width: 0, height: 1);
        cell.detailTextLabel?.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25);
        cell.detailTextLabel?.shadowOffset = CGSize(width: 0, height: 1);
        
    }
    
    //Change table height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95;
    }
    
    func updateStocks() {
        let stockAndCurrManager: StocksAndCurrencySingleton = StocksAndCurrencySingleton.sharedInstance;
        stockAndCurrManager.updateListOfSymbols(stocks: sampleStocks);
        
        //Execute update every 5 seconds.
        DispatchQueue.main.asyncAfter(deadline:  DispatchTime.now() + 0.10
            , execute:{
               self.updateStocks()
        });

        }
    
    func stocksUpdated(notification: NSNotification) {
        
        let values = (notification.userInfo as! Dictionary<String,NSArray>)
        let stocksReceived:NSArray = values[constantNotifUpdate]!;
        sampleStocks.removeAll();
        for quote in stocksReceived {
            let quoteDict:NSDictionary = quote as! NSDictionary;
            var changeInPercentString = quoteDict["ChangeinPercent"] as! String;
            let changeInPercentStringClean: String = changeInPercentString.substring(to: changeInPercentString.index(before: changeInPercentString.endIndex));
            var me: (String,Double) = (quoteDict["symbol"] as! String, Double(changeInPercentStringClean)!);
            sampleStocks.append(me);
            
        }
        tableView.reloadData()
        NSLog("Symbols Values updated :)")
    }

}

