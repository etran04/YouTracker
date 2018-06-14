//
//  ViewController.swift
//  YouTracker
//
//  Created by Eric Tran on 6/14/18.
//  Copyright © 2018 Eric Tran. All rights reserved.
//

import UIKit
import YouTubePlayer
import SVProgressHUD

class SingleVideoViewController: UIViewController, YouTubePlayerDelegate {

    @IBOutlet var videoPlayer: YouTubePlayerView!
    
    let wreckItRalphURL = "https://www.youtube.com/watch?v=_BcYBFC6zfY"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load video from YouTube URL
        SVProgressHUD.show()
        let myVideoURL = NSURL(string: wreckItRalphURL)
        videoPlayer.loadVideoURL(myVideoURL! as URL)
        
        self.videoPlayer.delegate = self
    }

    func playerReady(_ videoPlayer: YouTubePlayerView) {
        SVProgressHUD.dismiss()
    }

}

