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
    var tweets: [Tweet]?{
        didSet{
            tableView.reloadData()
        }
    }

    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var nameTextField: UILabel!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var shortNameHandle: UILabel!
    @IBOutlet weak var statusText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In Tweets View Controller")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.blueColor()
        // Do any additional setup after loading the view, typically from a nib.
        fillProfile()
        getData()
        print(User.currentUser)
    }
    
    func addTableCellBorder(){
        
    }
    
    func generateStatusText(){
        switch statusSegmentedControl.selectedSegmentIndex{
        case 0: //Num Tweets
            
            statusText.text = String(User.currentUser!.statuses_count!) + " Tweets? Go outside."
        case 1: //Num Followers
            statusText.text = "\(User.currentUser!.followers_count!) Followers? Good Job"
        case 2: //Num Friends
            statusText.text = "\(User.currentUser!.friends_count!) Friends? Ain't you popular"
        default:
            statusText.text = "Welcome to Mini-Tweets"
        }
    }
    
    func fillSegmentedControl(){
        let statuses_count = User.currentUser!.statuses_count!
        statusSegmentedControl.setTitle("\(statuses_count) Tweets", forSegmentAtIndex: 0)
        statusSegmentedControl.setTitle("\(User.currentUser!.followers_count!) Followers", forSegmentAtIndex: 1)
        statusSegmentedControl.setTitle("\(User.currentUser!.friends_count!) Friends", forSegmentAtIndex: 2)
    }
    
    func fillProfile(){
        backgroundImage.setImageWithURL((User.currentUser!.profile_background_image)!)
        profileImage.setImageWithURL(NSURL(string: (User.currentUser!.profileImageURL)!)!)
        nameTextField.text = User.currentUser!.name
        shortNameHandle.text =   "@\(User.currentUser!.screenname)"
        
        
        fillSegmentedControl()
        generateStatusText()
    }
    
    @IBAction func switchedSegmentedControl(sender: AnyObject) {
        generateStatusText()
    }
    func getData(){
        TwitterClient.sharedInstance.getUserTweets({(tweets:[Tweet]?, error:NSError?) in
            if (tweets != nil){
                self.tweets = tweets
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController
        if let dc = (vc as? TweetDetailViewController){
            print(tableView.indexPathForSelectedRow?.row)
            dc.tweet = tweets![(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}
