//
//  TweetDetailViewController.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/21/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit
import AFNetworking

class TweetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var userBackgroundColorView: UIView!
    @IBOutlet weak var userBackgroundImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var replyText: UITextField!
    @IBOutlet weak var replyCountdown: UILabel!
    
    let replyTextLimit = 100
    var tweet : Tweet!{
        didSet{
            fillProfileView()
        }
    }
    var retweets : [Tweet] = []{
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        replyText.delegate = self
        fillProfileView()
        retweets = [Tweet]()
        fillTableView()
        // Do any additional setup after loading the view.
    }
    
    func fillTableView(){
        let id = tweet.id
        TwitterClient.sharedInstance.getRetweets(String(id)) { (tweets: [Tweet]?, error: NSError?) -> () in
            print("Here")
            if tweets != nil{
                self.retweets = tweets!
            }
        }
    }
    
    func fillProfileView(){
        print(tweet)
        let id = tweet.user!.id!
        TwitterClient.sharedInstance.getUserFromId(String(id)) { (user: User?, error: NSError?) -> () in
            if let user = user{
                //TODO implemnt userBackgroundColorView.backgroundColor = UIColor()
                self.userBackgroundImageView.setImageWithURL((user.profile_background_image)!)
                self.userProfileImageView.setImageWithURL(NSURL(string: (user.profileImageURL)!)!)
                self.tweetText.text = self.tweet.text
                self.userName.text = user.name
            }
        }
    }
    @IBAction func userTyping(sender: AnyObject) {
        print("User typing reply")
        
    }
    
    @IBAction func reply(sender: AnyObject) {
        if replyTextLimit - (replyText.text?.characters.count)! > 0{
            if replyText.text?.characters.count > 0{
                TwitterClient.sharedInstance.reply(replyText.text!, in_reply_to_status_id: String(tweet.id), completion: { (replyTweet, error) -> () in
                    if replyTweet != nil{
                        self.retweets.append(replyTweet!)
                        self.tableView.reloadData()
                    }else{
                        let alertController = UIAlertController(title: "Mini-Tweet", message:
                            "Failed To Reply", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let textLeft = replyTextLimit - (textField.text?.characters.count)!
        replyCountdown.text = String(textLeft)
        if textLeft > 0{
            return true
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RetweetCell", forIndexPath: indexPath) as! RetweetCell
        cell.tweet = retweets[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retweets.count
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
