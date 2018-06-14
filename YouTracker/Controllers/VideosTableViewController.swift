//
//  VideosTableViewController.swift
//  YouTracker
//
//  Created by Eric Tran on 6/14/18.
//  Copyright © 2018 Eric Tran. All rights reserved.
//

import UIKit
import CoreData

class VideosTableViewController: UITableViewController {

    var videos = [Video]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let wreckItRalphURL = "https://www.youtube.com/watch?v=_BcYBFC6zfY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let temp = Video(context: context)
        temp.title = "Wreck It Ralph 2 Trailer"
        temp.url = wreckItRalphURL
        temp.startlocation = 0
        videos.append(temp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoTableCell", for: indexPath)
        cell.textLabel?.text = videos[indexPath.row].title
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToVideo", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SingleVideoViewController
    }
 

}
