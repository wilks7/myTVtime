//
//  SeasonListViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/20/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class SeasonListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var series: Series?
    var episodes: [Episode]?
    var episodesDict: [Int:[Episode]]?
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countSeasons()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath)
        
        let episodePack = episodesDict![indexPath.row + 1]!.map({$0.id})

        let myWatchedSet = Set(SeriesController.sharedController.watchedDict[series!.id]!)
        let episodePackSet = Set(episodePack)
        
        let allElemsContained = episodePackSet.isSubset(of: myWatchedSet)
        
        if allElemsContained {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = "Season \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let episodesDict = episodesDict else {return;}
        let path = indexPath.row + 1
        let season: Int = path
        let episodePack = episodesDict[season]!.map({$0.id})

        let myWatchedSet = Set(SeriesController.sharedController.watchedDict[series!.id]!)
        let episodePackSet = Set(episodePack)
        
        let allElemsContained = episodePackSet.isSubset(of: myWatchedSet)
        
        if allElemsContained {
            for id in episodePack {
                guard let index = SeriesController.sharedController.watchedDict[series!.id]!.index(of: id) else {return;}
                SeriesController.sharedController.watchedDict[series!.id]!.remove(at: index)
                
                let theDict = SeriesController.sharedController.watchedDict
                let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
                UserDefaults.standard.set(data, forKey: "watchedDict")
            }
        } else {
            for id in episodePack {
                
                if let index = SeriesController.sharedController.watchedDict[series!.id]!.index(of: id) {
                    SeriesController.sharedController.watchedDict[series!.id]!.remove(at: index)
                    
                    let theDict = SeriesController.sharedController.watchedDict
                    let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
                    UserDefaults.standard.set(data, forKey: "watchedDict")
                }
                
                SeriesController.sharedController.watchedDict[series!.id]!.append(id)
                let theDict = SeriesController.sharedController.watchedDict
                let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
                UserDefaults.standard.set(data, forKey: "watchedDict")
            }
        }
        self.tableViewOutlet.reloadData()
    }
}
