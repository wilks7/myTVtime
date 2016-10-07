//
//  ScheduleTableViewCell.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/22/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet weak var extendedViewOutlet: UIView!
    
    @IBOutlet weak var seasonEpisodeOutlet: UILabel!
    @IBOutlet weak var episodeTitleOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var networkOutlet: UILabel!
    
    @IBOutlet weak var overviewButtonOutlet: UIButton!
    
    var delegate:MyCustomCellDelegator!
    
    func setupCell(episode: Episode){
        
        self.overviewButtonOutlet.tag = episode.id
        self.overviewButtonOutlet.addTarget(self, action: #selector(WatchTableViewCell.overviewClicked(_:)), for: .touchUpInside)
        
        let seriesId = episode.seriesId
        if let img = SeriesController.sharedController.imageCache[seriesId] {
            self.imageViewOutlet.image = img
        } else {
            if episode.banner.characters.count > 5 {
                self.imageViewOutlet.cacheImage(urlString: episode.banner, id: seriesId)
            } else {
                self.imageViewOutlet.image = UIImage(named: "grayRect")
            }
        }
        let seasonEpisode = "S\(episode.airedSeason)E\(episode.airedEpisodeNumber)"
        self.seasonEpisodeOutlet.text = seasonEpisode
        self.episodeTitleOutlet.text = episode.episodeName
        self.timeOutlet.text = episode.airsTime
        self.networkOutlet.text = episode.network
    }
    
    func overviewClicked(_ sender: UIButton){
        let id = sender.tag
        self.delegate.callSegueFromCell(myData: id as AnyObject)
    }
    
    var isObserving = false
    
    class var expandedHeight: CGFloat { get { return 150 } }
    class var defaultHeight: CGFloat  { get { return 44  } }
    
    func checkHeight() {
        extendedViewOutlet.isHidden = (frame.size.height < ScheduleTableViewCell.expandedHeight)
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
