//
//  PhotosViewController.swift
//  myApp
//
//  Created by Suraj Upreti on 1/31/17.
//  Copyright © 2017 Suraj Upreti. All rights reserved.
//

import UIKit
import AFNetworking

class PhotosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var posts: [NSDictionary] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 140
        tableView.insertSubview(refreshControl, at: 0)
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        requestNetwork()
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        requestNetwork()
        refreshControl.endRefreshing()
    }
    
    func requestNetwork() {
        let url = URL(string:"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                if let data = data {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        //print("responseDictionary: \(responseDictionary)")
                        
                        // Recall there are two fields in the response dictionary, 'meta' and 'response'.
                        // This is how we get the 'response' field
                        let responseFieldDictionary = responseDictionary["response"] as! NSDictionary
                        
                        // This is where you will store the returned array of posts in your posts property
                        self.posts = responseFieldDictionary["posts"] as! [NSDictionary]
                        self.tableView.reloadData()
                        //print(self.posts[0])
                    }
                }
        });
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        let index = indexPath?.row
        let controller = segue.destination as! PhotoDetailsViewController
        controller.imageText = getImageCaption(indexForRow: index!)
        let imageUrl = getImagePosterURL(indexForRow: (indexPath?.row)!)
        controller.pictureUrlString = imageUrl
    }
    
    func getImageCaption(indexForRow: Int) -> String {
        let captionDict = posts[indexForRow]["reblog"] as! NSDictionary
        var postCaption = captionDict["comment"] as! String
        postCaption = postCaption.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return postCaption
    }
    
    func getImagePosterURL(indexForRow: Int) -> String {
        let post = posts[indexForRow]
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        return photos![0].value(forKeyPath: "original_size.url") as! String
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! postCell
        let post = posts[indexPath.row]
        let summary = post["summary"] as! String
        cell.postLabel.text = summary
        let photos = post.value(forKeyPath: "photos") as? [NSDictionary]
        let photoURL = photos?[0].value(forKeyPath: "original_size.url") as! String
        let imageUrl = URL(string: photoURL)
        cell.myImageView.setImageWith(imageUrl!)
        return cell
    }

}
