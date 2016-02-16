//
//  User.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/15/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit

var _currentUser: User?
let _currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"
class User: NSObject {
    var name: String?
    var screenname:String?
    var profileImageURL: String?
    var tagline: String?
    var dictionary: NSDictionary
    
    init(dictionary:NSDictionary){
        print(dictionary)
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    
    class var currentUser: User?{
        get{
        /*
        if _currentUser == nil{
        if let data = NSUserDefaults.standardUserDefaults().dataForKey(_currentUserKey){
        do{
        let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers )
        _currentUser = User(dictionary: dictionary as! NSDictionary)
    }catch let dataError{
        print("Failed to get current user from file \(dataError)")
        }
        }
        }*/
        return _currentUser
        }
        set(user){
            _currentUser = user
            
            if _currentUser != nil{
                do{
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: .PrettyPrinted)
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: _currentUserKey)
                } catch let dataError{
                    print("Error: \(dataError)")
                }
                
            }else{
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: _currentUserKey)
            }
        }
    }
}
