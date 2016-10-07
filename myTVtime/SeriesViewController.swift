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
        
        let sorted: [Episode] = allEpisodes
        var mySort: [Episode]
        
        if sorted[0].absoluteNumber < 0 {
            mySort = sorted.sorted { t1, t2 in
                if t1.airedSeason == t2.airedSeason {
                    return t1.airedEpisodeNumber < t2.airedEpisodeNumber
                }
                return t1.airedSeason < t2.airedSeason
            }
        } else {
            mySort = sorted.sorted(by: { $0.absoluteNumber < $1.absoluteNumber })
        }
        var seasonDict: [Int:[Episode]] = [1:[]]
        
        var season = 1
        for sode in mySort {
            let mySeason = sode.airedSeason
            if season == mySeason {
                seasonDict[season]!.append(sode)
            } else {
                seasonDict[mySeason] = []
                season = mySeason
                seasonDict[mySeason]!.append(sode)
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
