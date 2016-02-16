//
//  TwitterClient.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/15/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit

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
    
    func getUserTweets(number:Int, completion: (tweets:[Tweet]?, error:NSError?)->
()){
        self.GET("1.1/statuses/user_timeline.json?screen_name\(User.currentUser?.screenname)&count\(number)", parameters: nil,
            success: {(operation:NSURLSessionDataTask, response:AnyObject?)-> Void in
                
                print("Recieved \(number) Tweets")
                var tweets = [Tweet]()
                let rawTweets = response as! [NSDictionary]
                for tweet in rawTweets{
                    tweets.append(Tweet(dictionary: tweet))
                }
                completion(tweets: tweets, error:nil)
            }, failure: {(operation: NSURLSessionDataTask?, error: NSError)-> Void in
                print("Failed to get tweets")
                completion(tweets: nil, error: error)
        });
    }
    
    func reTweet(tweet:Tweet, completion: ()->()){
        self.GET("1.1/statuses/retweet/\(tweet.id).json", parameters: nil,
            success: {(operation:NSURLSessionDataTask, response:AnyObject?)-> Void in
                print("Retweet Sucess")
                completion()
            }, failure: {(operation: NSURLSessionDataTask?, error: NSError)-> Void in
                print("Failed to Retweet")
                completion()
        });
    }
    
    func favorite(tweet:Tweet, completion: ()->()){
        self.GET("1.1/favorites/create.json?id=\(tweet.id)", parameters: nil,
            success: {(operation:NSURLSessionDataTask, response:AnyObject?)-> Void in
                print("Favorite Sucess")
                completion()
            }, failure: {(operation: NSURLSessionDataTask?, error: NSError)-> Void in
                print("Failed to Favorite")
                completion()
        });
    }
    
    
    
    func openURL(url: NSURL){
        print("here")
       fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!)-> Void in
                print("Got the Access token! \(accessToken)")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil,
                    success: {(operation:NSURLSessionDataTask, response:AnyObject?)-> Void in
                        print("Got User")
                        User.currentUser = User(dictionary: response as! NSDictionary)
                        self.loginCompletion?(user:User.currentUser, error:nil)
                    }, failure: {(operation: NSURLSessionDataTask?, error: NSError)-> Void in
                        print("Failed to validate user: \(error)")
                        self.loginCompletion?(user:nil, error:error)
                });
            }, failure: {
                (error:NSError!)->Void in print("Failed to recieve access token")
                self.loginCompletion?(user:nil, error: error)
        })
        
    }
}
