//
//  RetweetCell.swift
//  Mini-Tweet
//
//  Created by Labuser on 2/21/16.
//  Copyright © 2016 David Ayeke. All rights reserved.
//

import UIKit

class RetweetCell: UITableViewCell {
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var userHandle: UILabel!
    
    var tweet : Tweet!{
        didSet{
            reset()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func reset(){
        tweetText.text = tweet!.text
        userName.text = tweet!.user?.name
        timePosted.text = String(tweet!.createdAt!)
        self.userProfilePic.setImageWithURL(NSURL(string: (tweet.user?.profileImageURL)!)!)
        userHandle.text = "@\(tweet.user!.screenname!)"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
