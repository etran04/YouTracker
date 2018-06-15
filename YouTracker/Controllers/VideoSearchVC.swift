//
//  VideoSearchVC.swift
//  YouTracker
//
//  Created by Eric Tran on 6/14/18.
//  Copyright © 2018 Eric Tran. All rights reserved.
//

import UIKit
import SVProgressHUD

class VideoSearchVC: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
    var searchedVideos = [Video]()
    let apiKey = (UIApplication.shared.delegate as! AppDelegate).youtubeAPIKey
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedVideos.count
    }
}

// MARK: - REST API methods

func performGetRequest(targetURL: NSURL!, completion: @escaping (_ data: NSData?, _ HTTPStatusCode: Int, _ error: NSError?) -> Void) {
//    let request = NSMutableURLRequest(url: targetURL as URL)
//    request.httpMethod = "GET"
//
//    let sessionConfiguration = URLSessionConfiguration.default
//
//    let session = URLSession(configuration: sessionConfiguration)
//
//    let task = session.dataTaskWithRequest(request as URLRequest, completionHandler: { (data: NSData!, response: URLResponse!, error: NSError!) -> Void in
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            completion(data! as NSData, (response as! HTTPURLResponse).statusCode, error)
//        })
//    })
//
//    task.resume()
}

// MARK: - Search bar delegate
extension VideoSearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Query Youtube API for videos
        
        if !searchBar.text!.isEmpty {
            if let searchText = searchBar.text {
                // Form the request URL string.
                let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchText)&type=video&key=\(self.apiKey)"
                if let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                    // Create a NSURL object based on the above string.
                    let targetURL = NSURL(string: encodedUrl)
                    print(targetURL!)
                }
            }
        }
    }
    
    
}
