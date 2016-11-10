//
//  WatchTableViewCell.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/19/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class WatchTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet weak var extendedViewOutlet: UIView!
    @IBOutlet weak var seasonEpisodeOutlet: UILabel!
    @IBOutlet weak var episodeNameOutlet: UILabel!
    
    
    @IBOutlet weak var overviewButtonOutlet: UIButton!
    @IBOutlet weak var watchedButtonOutlet: UIButton!
    
    var delegate:MyCustomCellDelegator!
    
    func watchedClicked(_ sender: UIButton){
        let id = sender.tag
                
        if id != 0 {
            SeriesController.sharedController.toWatchDict[id]!.removeFirst()
            
            
            // need to refesh somehow
            // self.delegate.reloadTableView()
        }
    }
    
    func overviewClicked(_ sender: UIButton){
        let episodeId = sender.tag
        
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callSegueFromCell(myData: episodeId as AnyObject)
        }
    }
    
    func setupCell(id: Int, seriesId: Int, path: Int) {
        
        self.watchedButtonOutlet.tag = seriesId
        self.watchedButtonOutlet.addTarget(self, action: #selector(WatchTableViewCell.watchedClicked(_:)), for: .touchUpInside)
        
        self.overviewButtonOutlet.tag = id
        self.overviewButtonOutlet.addTarget(self, action: #selector(WatchTableViewCell.overviewClicked(_:)), for: .touchUpInside)
        
        
        let episodeId = id
        
        if let img = SeriesController.sharedController.imageCache[seriesId] {
            self.imageViewOutlet.image = img
        }
        
        NetworkController.episodeByID(episodeId) { (episode, error) in
            if let episode = episode {
                let seasonEpisode = "S\(episode.airedSeason)E\(episode.airedEpisodeNumber)"

                self.seasonEpisodeOutlet.text = seasonEpisode
                self.episodeNameOutlet.text = episode.episodeName
            }
        }
    }
    
    var isObserving = false
    
    class var expandedHeight: CGFloat { get { return 150 } }
    class var defaultHeight: CGFloat  { get { return 80  } }
    
    func checkHeight() {
        extendedViewOutlet.isHidden = (frame.size.height < WatchTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}

