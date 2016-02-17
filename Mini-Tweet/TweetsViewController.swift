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
        print("In Tweets View Controller")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view, typically from a nib.
        
        getData()
    }
    
    func addTableCellBorder(){
        
    }
    
    func getData(){
        TwitterClient.sharedInstance.getUserTweets({(tweets:[Tweet]?, error:NSError?) in
            if (tweets != nil){
                self.tweets = tweets
                self.tableView.reloadData()
            }})
    }
    
    func reloadData(){
        getData()
    }
    
    @IBAction func signOut(sender: AnyObject) {
        User.currentUser?.logout()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets![indexPath.row]
        
        if(indexPath.row == 0){
            let topLineView = UIView(frame: CGRectMake(0,0,self.view.bounds.size.width, 1))
            topLineView.backgroundColor = UIColor.grayColor()
            cell.contentView.addSubview(topLineView)
        }
        
        let frame = CGRectMake(0, cell.bounds.size.height, self.view.bounds.size.width,1);
        let bottomLineView = UIView(frame: frame)
        bottomLineView.backgroundColor = UIColor.grayColor()
        cell.contentView.addSubview(bottomLineView)
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
