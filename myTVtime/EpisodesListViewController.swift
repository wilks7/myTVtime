//
//  EpisodesViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/19/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class EpisodesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewOutlet: UITableView!

    var series: Series?
    var episodes: [Episode]?
    var episodesDict: [Int:[Episode]]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func isEpisodeWatch(id: Int)->(Bool,Int){
        guard let dict = SeriesController.sharedController.watchedDict[series!.id] else {return (false,0);}
        if dict.contains(id) {
            let myIndex: Int = dict.index(of: id)!
            return (true,myIndex)
        } else {
            return (false,0)
        }
        
    }
    
    func countSeasons()->Int{
        var count = 0
        for sode in episodes! {
            if sode.airedSeason > count {
                count = sode.airedSeason
            }
        }
        return count
    }
    
    func countEpisodesPerSeason(season: Int)->Int{
        var count = 0
        for sode in episodes! {
            if sode.airedSeason == season {
                count += 1
            }
        }
        return count
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as! EpisodeListTableViewCell
        
        let myEpisode = episodes![indexPath.row]
        
        if isEpisodeWatch(id: myEpisode.id).0 {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.setupCell(episode: myEpisode)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = indexPath.row
        let id = episodes![path].id
        let cellToUpdate = tableView.cellForRow(at: indexPath)
        //let seriesId = SeriesController.sharedController.watchedDict[series!.id]
        
        let isWatched = isEpisodeWatch(id: id)
        
        if isWatched.0{
            let index = isWatched.1
            SeriesController.sharedController.watchedDict[series!.id]?.remove(at: index)
            
            let theDict = SeriesController.sharedController.watchedDict
            let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
            UserDefaults.standard.set(data, forKey: "watchedDict")
            
        } else {
            if SeriesController.sharedController.watchedDict[series!.id] != nil{
                SeriesController.sharedController.watchedDict[series!.id]!.append(id)
                
                let theDict = SeriesController.sharedController.watchedDict
                let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
                UserDefaults.standard.set(data, forKey: "watchedDict")
            } else {
                SeriesController.sharedController.watchedDict[series!.id] = []
                SeriesController.sharedController.watchedDict[series!.id]!.append(id)
                
                let theDict = SeriesController.sharedController.watchedDict
                let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
                UserDefaults.standard.set(data, forKey: "watchedDict")
            }
        }
        self.tableViewOutlet.reloadData()
    }
    
    
}
