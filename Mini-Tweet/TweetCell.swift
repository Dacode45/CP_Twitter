//
//  TweetCell.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/16/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    
    var tweet : Tweet!{
        didSet{
            userName.text = tweet.user!.name
            screenName.text = "@\(tweet.user!.screenname!)"
            tweetText.text = tweet.text
            profileImage.setImageWithURL(NSURL(string: tweet.user!.profileImageURL!)!)
            
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Month, .Day, .Year], fromDate: tweet.createdAt!)
            
            timestamp.text = "\(comp.month)/\(comp.day)/\(comp.year)"
            
            retweetCount.text = String("\(tweet.retweets!) Retweets")
            if tweet.retweets > 0 {
                retweetCount.hidden = false
            } else {
                retweetCount.hidden = true
            }
            
            favoriteCount.text = String("\(tweet.favorites!) Favorites")
            if tweet.favorites > 0 {
                favoriteCount.hidden = false
            } else {
                favoriteCount.hidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        tweetText.preferredMaxLayoutWidth = tweetText.frame.size.width
    }
    @IBAction func retweet(sender: AnyObject) {
        if (tweet.isRetweeted != nil && !tweet.isRetweeted!) {
            TwitterClient.sharedInstance.retweet(tweet.id!)
            retweetCount.text = String("\(tweet.retweets!+1) Retweets")
            retweetCount.textColor = UIColor.greenColor()
            retweetCount.hidden = false
            tweet.isRetweeted = true
        }
    }
    @IBOutlet weak var favorite: UIButton!
    @IBAction func callFavorite(sender: AnyObject) {
        if (tweet.isFavorited != nil && !tweet.isFavorited!) {
            TwitterClient.sharedInstance.favorite(tweet.id!)
            favoriteCount.text = String("\(tweet.favorites!+1) Favorites")
            favoriteCount.textColor = UIColor.redColor()
            favoriteCount.hidden = false
            tweet.isFavorited = true
        }
    }

    
}
