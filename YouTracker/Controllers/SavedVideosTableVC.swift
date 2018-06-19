//
//  SavedVideosTableVC.swift
//  YouTracker
//
//  Created by Eric Tran on 6/14/18.
//  Copyright © 2018 Eric Tran. All rights reserved.
//

import UIKit
import CoreData

class SavedVideosTableVC: UITableViewController {

    var videos = [SavedVideo]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Refresh control add in tableview.
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

        loadData()
    }
    
    @objc func refresh(_ sender: Any) {
        loadData()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View Data Source Methods

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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(videos[indexPath.row])
            self.videos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    // MARK: - Outlet Methods
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Youtube Video", message: "Add Youtube Video", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Video", style: .default) { (action) in
            
            if textField.text!.isEmpty {
                return
            }
            
            let newVideo = SavedVideo(context: self.context)
            newVideo.title = textField.text!
            newVideo.videoId = textField.text!
            newVideo.startTime = "0"
            self.videos.append(newVideo)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a video url"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToVideo", sender: self)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! SingleVideoVC
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedVideo = videos[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try self.context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<SavedVideo> = SavedVideo.fetchRequest()
        do {
            videos = try context.fetch(request)
            
            if let refreshControl = self.refreshControl {
                refreshControl.endRefreshing()
            }
        } catch {
            print(error)
        }
    }
 

}
