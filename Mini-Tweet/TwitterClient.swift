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
    print("here1 \(User.currentUser?.dictionary["screen_name"])")
    let request = NSURLRequest(URL: NSURL(string: "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name\(User.currentUser?.dictionary["screen_name"])&count\(number)")!)
    var task = self.dataTaskWithRequest(request, completionHandler: {(response: NSURLResponse, thing: AnyObject?, error: NSError?) -> Void in
        var tweets = [Tweet]()
     
        print("here2") 
        if error == nil{
            print("Recieved \(number) Tweets")
            
            if let rawTweets =  try! NSJSONSerialization.JSONObjectWithData(thing as! NSData, options: []) as? [NSDictionary]{
                for tweet in rawTweets{
                    tweets.append(Tweet(dictionary: tweet ))
                }
            }
            
            completion(tweets: tweets, error:error)
        }
        });
    task.resume()
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
       fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query),
            success: {(accessToken: BDBOAuth1Credential!)-> Void in
                print("Got the Access token! \(accessToken)")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                let request = NSURLRequest(URL: NSURL(string: "https://api.twitter.com/1.1/account/verify_credentials.json")!)
                var task = self.dataTaskWithRequest(request, completionHandler: {(response: NSURLResponse, thing: AnyObject?, error: NSError?) -> Void in
                    if error == nil{
                        print("Got User")
                        let data = try! NSJSONSerialization.JSONObjectWithData(thing as! NSData, options: []) as! NSDictionary
                        User.currentUser = User(dictionary: data )
                        self.loginCompletion?(user:User.currentUser, error:nil)

                    }else{
                        print("Error \(error)")
                    }
                    
                });
                task.resume()
                print("Here")
        },failure: {
            (error:NSError!)->Void in print("Failed to get user")
            self.loginCompletion?(user: nil, error: error)
       })
        
    }
}
