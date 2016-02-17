//
//  TwitterClient.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/15/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "9TTS7N7z1pvtkyiNNTmYdKKHQ"
let twitterConsumerSecret = "ixQScUVtjH7hMmSJ1eAu9rcmcblw2mPs351EbZAlTZBsaTRNiF"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?)->Void)?
    class var sharedInstance: TwitterClient{
        struct Static{
            static let instance = TwitterClient(baseURL: twitterBaseURL,
                consumerKey: twitterConsumerKey,
                consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?)->Void){
        loginCompletion = completion
        // Fetch Request Token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil,  success: {(requestToken:BDBOAuth1Credential!)-> Void in
            print("Got the request token: \(requestToken.token)")
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            },failure: {
                (error:NSError!)->Void in print("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        })
        
    }
    
    func getUserTweets(completion: (tweets:[Tweet]?, error:NSError?)->
()){
    let screenName : [String: String] = ["screen_name": (User.currentUser?.screenname)!]
    GET("1.1/statuses/home_timeline.json", parameters: screenName, progress: { (progress) -> Void in
            print("Progress made on getTweets")
        }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
        var tweets = [Tweet]()
        for tweet in response as! [NSDictionary]{
            tweets.append(Tweet(dictionary: tweet))
        }
        completion(tweets: tweets, error: nil)
        
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
        print("error getting home")
        completion(tweets: nil, error: nil)
        })
    }
    
    func retweet(id: Int) {
        POST("1.1/statuses/retweet/\(String(id)).json", parameters: nil, progress: { (progress) -> Void in
            print("Progress made on retweet")
            }, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("successful retweet")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("failed retweet")
        })
    }
    
    func favorite(id: Int) {
        POST("1.1/favorites/create.json?id=\(String(id))", parameters: nil, progress: { (progress) -> Void in
            print("Progress made on favorite")
            }, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("successful favorite")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("failed favorite")
        })
    }
    
    
    func openURL(url: NSURL) {
        print("Getting URL")
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
           
            self.GET("1.1/account/verify_credentials.json", parameters: nil, progress: { (progress) -> Void in
                print("progress made on verify credentials")
                }, success: { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    let user = User(dictionary:response as! NSDictionary)
                    User.currentUser = user
                    print("user: \(user.name)")
                    self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
           
        
            }) { (error: NSError!) -> Void in
                print("Can't receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
}
