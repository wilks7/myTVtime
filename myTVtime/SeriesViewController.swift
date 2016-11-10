//
//  SeriesViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/19/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class SeriesViewController: UIViewController {
    
    var series: Series?
    var episodes: [Episode]?
    
    @IBOutlet weak var imageViewOutlet: UIImageView!
    @IBOutlet weak var textViewOutlet: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = series?.seriesName
        textViewOutlet.text = series?.overview
        let id = series!.id
        let fullString = "http://thetvdb.com/banners/\(series!.banner!)"
        imageViewOutlet.cacheImage(urlString: fullString, id: id)
        NetworkController.getEpisodes(id) { (episodes, error) in
            guard let episodes = episodes else {return;}
            self.episodes = episodes
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let allEpisodes = episodes else {return;}
        
        let unsorted: [Episode] = allEpisodes
        var mySort: [Episode]
        
        mySort = unsorted.sorted { t1, t2 in
            if t1.airedSeason == t2.airedSeason {
                return t1.airedEpisodeNumber < t2.airedEpisodeNumber
            }
            return t1.airedSeason < t2.airedSeason
        }
    
        var seasonDict: [Int:[Episode]] = [:]
        
        for sode in mySort {
            let season = sode.airedSeason
            
            if seasonDict[season] != nil {
                seasonDict[season]!.append(sode)
            } else {
                seasonDict[season] = [sode]
            }
        }

        if segue.identifier == "toEpisodes" {
            let targetViewController = segue.destination as! EpisodesListViewController
            targetViewController.series = series
            targetViewController.episodes = mySort
            //targetViewController.episodesDict = seasonDict
        } else if segue.identifier == "seasonList" {
            let targetViewController = segue.destination as! SeasonListViewController
            targetViewController.series = series
            targetViewController.episodes = mySort
            targetViewController.episodesDict = seasonDict
        }
    }
    
    
}
