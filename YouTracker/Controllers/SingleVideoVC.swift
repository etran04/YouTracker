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
    var selectedVideo : SavedVideo?
    var searchedVideo : SearchedVideo?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = selectedVideo?.title {
            self.title = title
            if let button = self.navigationItem.rightBarButtonItem {
                button.isEnabled = false
                button.tintColor = UIColor.clear
            }
//            adjustLargeTitleSize()
        } else if let title = searchedVideo?.title {
            self.title = title
            if let button = self.navigationItem.rightBarButtonItem {
                button.isEnabled = true
            }
//            adjustLargeTitleSize()
        }
        
        // Load video from YouTube URL
        SVProgressHUD.show()
        
        if let videoId = selectedVideo?.videoId {
            videoPlayer.loadVideoID(videoId)
        } else if let videoId = searchedVideo?.videoId {
            videoPlayer.loadVideoID(videoId)
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
        if let startTimeString = selectedVideo?.startTime {
            if let startTimeFloat = NumberFormatter().number(from: startTimeString) {
                print("Starting at \(startTimeFloat)")
                 videoPlayer.seekTo(startTimeFloat.floatValue, seekAhead: true)
            }
        } else {
            videoPlayer.play()
        }
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        if playerState == .Paused {
            if selectedVideo != nil {
                saveCurrentTimeForSavedVideo()
            } else if searchedVideo != nil {
                searchedVideo?.startTime = videoPlayer.getCurrentTime()
            }
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
    
    // MARK: - Outlet methods
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        saveCurrentTimeForSearchVideo()
    }
    
    
    // MARK: - Extra Helper Methods
    
    func saveCurrentTimeForSavedVideo() {
        selectedVideo?.startTime = videoPlayer.getCurrentTime()
        saveData()
        notifyUserVideoSaved()
    }
    
    func saveCurrentTimeForSearchVideo() {
        let toSaveVideo = SavedVideo(context: context)
        toSaveVideo.title = searchedVideo?.title
        toSaveVideo.thumbnail = searchedVideo?.thumbnail
        toSaveVideo.videoId = searchedVideo?.videoId
        toSaveVideo.startTime = searchedVideo?.startTime
        saveData()
        notifyUserVideoSaved()
    }
    
    func notifyUserVideoSaved() {
        let alert = UIAlertController(title: "Current time video saved", message: "Video saved!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // https://stackoverflow.com/questions/47146606/my-navigation-bars-large-title-is-too-wide-how-to-fix-that
    func adjustLargeTitleSize() {
        guard let title = title, #available(iOS 11.0, *) else { return }
        
        let maxWidth = UIScreen.main.bounds.size.width - 60
        var fontSize = UIFont.preferredFont(forTextStyle: .largeTitle).pointSize
        var width = title.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)]).width
        
        while width > maxWidth {
            fontSize -= 1
            width = title.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize)]).width
        }
        
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: fontSize)
        ]
    }
}

