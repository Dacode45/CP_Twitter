//
//  Tweet.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/15/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary?
    var isRetweeted: Bool?
    var retweets: Int?
    var isFavorited: Bool?
    var favorites: Int?
    
    
    init(dictionary: NSDictionary){
        //print(dictionary)
        self.dictionary = dictionary
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        id = (dictionary["id"] as? Int?)!
        retweets = (dictionary["retweet_count"] as? Int?)!
        isRetweeted = (dictionary["retweeted"] as? Bool?)!
        isFavorited = (dictionary["favorited"] as? Bool?)!
        favorites = (dictionary["favorite_count"] as? Int?)!
        let formatter = NSDateFormatter()
        //Very expensive should make this static
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in array{
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets;
    }
}
