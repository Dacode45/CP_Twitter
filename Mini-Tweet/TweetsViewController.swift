//
//  TweetsViewController.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/15/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view, typically from a nib.
        
        getData()
    }
    
    func getData(){
        TwitterClient.sharedInstance.getUserTweets(20, completion: {(tweets:[Tweet]?, error: NSError?) in
            if (tweets != nil){
                self.tweets = tweets
                self.tableView.reloadData()
            }})
    }
    
    func reloadData(){
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath)
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets{
            return tweets.count
        }else{
            return 0;
        }
    }
}
