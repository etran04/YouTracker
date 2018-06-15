//
//  SingleVideoVC.swift
//  YouTracker
//
//  Created by Eric Tran on 6/14/18.
//  Copyright © 2018 Eric Tran. All rights reserved.
//

import UIKit
import YouTubePlayer
import SVProgressHUD
import CoreData

class SingleVideoVC: UIViewController, YouTubePlayerDelegate {

    @IBOutlet var videoPlayer: YouTubePlayerView!
    var selectedVideo : Video? {
        didSet {
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load video from YouTube URL
        SVProgressHUD.show()
        
        if let url = selectedVideo?.url {
            let myVideoURL = NSURL(string: url)
            videoPlayer.loadVideoURL(myVideoURL! as URL)
        }
        
        self.videoPlayer.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.navigationController?.viewControllers.index(of: self) == nil {
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
        }
        super.viewWillDisappear(animated)
    }

    // MARK: - YouTubePlayerDelegate Methods
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        SVProgressHUD.dismiss()
        if let startTimeString = selectedVideo?.starttime {
            if let startTimeFloat = NumberFormatter().number(from: startTimeString) {
                print("Starting at \(startTimeFloat)")
                 videoPlayer.seekTo(startTimeFloat.floatValue, seekAhead: true)
            }
        }
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Paused {
            selectedVideo?.starttime = videoPlayer.getCurrentTime()
            saveData()
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print (error)
        }
    }
}

