//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Angarag Gansukh on 9/26/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var tweetContent: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    var tweetId = -1
    var favorited = false
    var retweeted = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setRetweet(true)
        }, failure: { error in
            print("Error retweeting: \(error)")
        })
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        
        if toBeFavorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorate(true)
            }, failure: { error
                in
                print("Error favoriting tweet: \(error)")
            })
        }
        
        else {
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorate(false)
            }, failure: { error in
                print("Error unfavoriting tweet: \(error)")
            })
        }
    }
    
    func setFavorate(_ isFavorited: Bool) {
        favorited = isFavorited
        if favorited {
            favoriteButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favoriteButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
  
    func setRetweet(_ isRetweeted: Bool) {
        retweeted = isRetweeted
        if retweeted {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    func setTimeSinceTweet(from tweetTime: String) {
        let today = Date()
        let metadata = DateFormatter()
        metadata.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        
        guard let tweetDate = metadata.date(from: tweetTime) else {
            timeLabel.text = "Loading.."
            return
        }
        let timeInterval = Int(today.timeIntervalSince(tweetDate))
        
        if timeInterval < 60 {
            timeLabel.text = String(timeInterval) + " sec ago"
        }
        
        else if timeInterval < 3600, timeInterval > 60 {
            timeLabel.text = String(timeInterval/60) + " min ago"
        }
        
        else if timeInterval < 84600 {
            timeLabel.text = String(timeInterval/(60 * 60)) + " hrs ago"
        }
        
        else {
            timeLabel.text = String(timeInterval/(60 * 60 * 24)) + " days ago"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
