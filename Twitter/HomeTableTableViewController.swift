//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Angarag Gansukh on 9/26/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import AlamofireImage
import UIKit

class HomeTableTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]()
    var numOfTweets: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: UIControl.Event.valueChanged)
        self.loadTweet()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationIte   m.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        self.dismiss(animated: true)
    }
    
    @IBAction func createTweet(_ sender: Any) {
        performSegue(withIdentifier: "composeTweet", sender: self)
    }

    func loadTweet() {
        let timelineUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": 10]
        TwitterAPICaller.client?.getDictionariesRequest(url: timelineUrl, parameters: params, success: { (tweets: [NSDictionary]) in
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        }, failure: { Error in
            print(Error)
            print("Could not retrieve tweets.")
        })
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = self.tweetArray[indexPath.row]["user"] as! NSDictionary
        
        cell.tweetContent.text = self.tweetArray[indexPath.row]["text"] as? String
        cell.userNameLabel.text = user["name"] as? String
        
        cell.setFavorate(self.tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.setRetweet(self.tweetArray[indexPath.row]["retweeted"] as! Bool)
        cell.tweetId = self.tweetArray[indexPath.row]["id"] as! Int
        
        cell.setTimeSinceTweet(from: self.tweetArray[indexPath.row]["created_at"] as! String)
                
        let profileImageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        cell.profileImageView.af_setImage(withURL: profileImageUrl!)
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tweetArray.count
    }

    @objc func refresh(sender: AnyObject) {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
        
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

         // Configure the cell...

         return cell
     }
     */

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the specified item to be editable.
         return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             // Delete the row from the data source
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
         // Return false if you do not want the item to be re-orderable.
         return true
     }
     */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let cell = sender as! UITableViewCell
//        let indexPath = tableView.indexPath(for: cell)!
//        tableView.deselectRow(at: indexPath, animated: true )
//    }
}
