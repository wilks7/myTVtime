//
//  EpisodeListTableViewCell.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/20/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class EpisodeListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(episode: Episode){
        
        var seasonNumber: String = ""
        if episode.airedSeason < 10 {
            seasonNumber = "S0\(episode.airedSeason)"
        } else {
            seasonNumber = "S\(episode.airedSeason)"
        }
        
        var episodeNumber: String = ""
        if episode.airedEpisodeNumber < 10 {
            episodeNumber = "E0\(episode.airedEpisodeNumber)"
        } else {
            episodeNumber = "E\(episode.airedEpisodeNumber)"
        }
        
        let seasonEpisode = seasonNumber + episodeNumber
        
        self.titleOutlet.text = "\(seasonEpisode) - \(episode.episodeName)"
    }
}
