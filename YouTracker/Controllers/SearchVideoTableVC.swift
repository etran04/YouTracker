//
//  SearchVideoTableVC
//  YouTracker
//
//  Created by Eric Tran on 6/14/18.
//  Copyright © 2018 Eric Tran. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import SwiftyJSON

class SearchVideoTableVC: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var videosArray: Array<Dictionary<NSObject, AnyObject>> = []
    var searchedVideos = [SearchedVideo]()
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchVideoCell", for: indexPath)
        cell.textLabel?.text = searchedVideos[indexPath.row].title
        return cell
    }
    
    // MARK: - Table view delegate
}

// MARK: - Search bar delegate
extension SearchVideoTableVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: Query Youtube API for videos
        
        if !searchBar.text!.isEmpty {
            if let searchText = searchBar.text {
                // Form the request URL string.
                let urlString = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchText)&type=video&key=\(self.apiKey)"
                
                SVProgressHUD.show()
                Alamofire.request(urlString).responseJSON(completionHandler: { (response) in
//                    print("Request: \(String(describing: response.request))")   // original url request
//                    print("Response: \(String(describing: response.response))") // http url response
//                    print("Result: \(response.result)")                         // response serialization result
                    
                    if let json = response.result.value {
                        let convertedJSON = JSON(json)
                        let fetchedVideos = convertedJSON["items"]
                        for i in 0...fetchedVideos.count {
                            
                            let tempVideo = SearchedVideo()
                            let iterVideo = fetchedVideos[i]
                            
                            if let videoId = iterVideo["id"]["videoId"].string {
                                tempVideo.videoId = videoId
                            }
                            
                            if let title = iterVideo["snippet"]["title"].string {
                                tempVideo.title = title
                            }
                            
                            if let thumbnail = iterVideo["snippet"]["thumbnails"]["default"]["url"].string {
                                tempVideo.thumbnail = thumbnail
                            }
                            
                            self.searchedVideos.append(tempVideo)
                        }
                    }
                    
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                })
            }
        }
    }
}
