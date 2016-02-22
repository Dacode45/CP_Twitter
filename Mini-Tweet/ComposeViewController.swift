//
//  ComposeViewController.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/21/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var shortName: UIView!
    @IBOutlet weak var tweetField: UITextView!
    
    @IBOutlet weak var screenName: UILabel!
    
    @IBOutlet weak var tweetConter: UILabel!
    
    let tweetLimit = 240
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetField.delegate = self
        fillProfile()
        // Do any additional setup after loading the view.
    }
    
    func fillProfile(){
        profileImageView.setImageWithURL(NSURL(string:(User.currentUser?.profileImageURL)!)!)
        userName.text = User.currentUser!.name
        screenName.text = "@\(User.currentUser!.screenname!)"
        tweetConter.text = String(tweetLimit)
        tweetField.becomeFirstResponder()
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let textLeft = tweetLimit - (tweetField.text?.characters.count)!
        tweetConter.text = String(textLeft)
        if textLeft > 0{
            return true
        }
        return false
    }
    @IBAction func tweet(sender: AnyObject) {
        if tweetLimit - (tweetField.text?.characters.count)! > 0{
            if tweetField.text.characters.count > 0{
                TwitterClient.sharedInstance.reply(self.tweetField.text!, in_reply_to_status_id: "", completion: { (replyTweet, error) -> () in
                    if replyTweet == nil{
                        let alertController = UIAlertController(title: "Mini-Tweet", message:
                            "Failed To Retweet", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }else{
                        self.performSegueWithIdentifier("BackToMain", sender: self)
                    }
                })
            }
        }
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
