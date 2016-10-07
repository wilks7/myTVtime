//
//  EpisodeViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/19/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    @IBOutlet weak var episodeTitleOutlet: UILabel!
    
    @IBOutlet weak var overviewOutelt: UILabel!
    @IBOutlet weak var seasonEpisodeOutlet: UILabel!
    
    var episode: Episode?
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = id {
            NetworkController.episodeByID(id, completion: { (episode, error) in
                if let episode = episode {
                    DispatchQueue.main.async(execute: {
                        self.episode = episode
                        self.episodeTitleOutlet.text = episode.episodeName
                        self.overviewOutelt.text = episode.overview
                        let seasonEpisodeString = "Season \(episode.airedSeason) - Episode\(episode.airedEpisodeNumber)"
                        self.seasonEpisodeOutlet.text = seasonEpisodeString
                    })
                }
            })
        }
    }
}
