//
//  WatchTableViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/19/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class WatchTableViewController: UITableViewController, MyCustomCellDelegator {
    
    @IBOutlet weak var seasonEpisodeOutlet: UILabel!
    @IBOutlet weak var episodeNameOutlet: UILabel!
    
    var selectedIndexPath : IndexPath?
    
    @IBOutlet var tableViewOutlet: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showsToWatch(idArray: Array(SeriesController.sharedController.watchedDict.keys)) { (dict) in
            SeriesController.sharedController.toWatchDict = dict
            SeriesController.sharedController.toWatchDict[0] = nil
            
            DispatchQueue.main.async(execute: {
                self.tableViewOutlet.reloadData()
            })
        }
    }
    
    @IBAction func buttonTapped(_ sender: AnyObject) {
        self.tableViewOutlet.reloadData()
    }
    
    
    func showsToWatch(idArray: [Int], completion:@escaping(_ dict: [Int:[Int]])->Void){
        var toWatch:[Int:[Int]] = [0:[]]
        
        let groupDispatch = DispatchGroup()

        for id in idArray {
            guard let watchedId = SeriesController.sharedController.watchedDict[id] else {return;}
            
            groupDispatch.enter()
            
            NetworkController.getEpisodes(id) { (episodes, error) in
                if let episodes = episodes {
                    let episodesId = episodes.map({$0.id})
                    
                    let difference = episodesId.filter { !watchedId.contains($0) }
                    toWatch[id] = difference
                    
                    groupDispatch.leave()
            }
            }
        }
        groupDispatch.notify(queue: DispatchQueue.main, execute: { () -> Void in
            completion(toWatch)
        })
    }
    
    // MARK: - TableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SeriesController.sharedController.toWatchDict.keys.count > 1 {
            return SeriesController.sharedController.toWatchDict.keys.count - 1
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "watchCell", for: indexPath) as! WatchTableViewCell
        
        cell.delegate = self
        
        if SeriesController.sharedController.toWatchDict.keys.count > 1 {
            let seriesArray = Array(SeriesController.sharedController.toWatchDict.keys)
            
            let seriesId = seriesArray[indexPath.row]
            
            if seriesId != 0 {
                SeriesController.sharedController.toWatchDict[seriesId]! = SeriesController.sharedController.toWatchDict[seriesId]!.sorted(by: { $0 < $1 })
                let episodeId = SeriesController.sharedController.toWatchDict[seriesId]!.first
                cell.setupCell(id: episodeId!, seriesId: seriesId, path: indexPath.row)
                return cell
            } else {
                return cell
            }
        } else {
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths = [IndexPath]()
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! WatchTableViewCell).watchFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! WatchTableViewCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [WatchTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return WatchTableViewCell.expandedHeight
        } else {
            return WatchTableViewCell.defaultHeight
        }
    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        self.performSegue(withIdentifier: "toEpisode", sender:dataobject)
    }
    
    func reloadTableView() {
        
        DispatchQueue.main.async(execute: {
            self.tableViewOutlet.reloadData()
        })
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEpisode"{
            let dVC = segue.destination as! EpisodeViewController
            guard let id = sender as? Int else {return;}
            dVC.id = id
        }
    }
}
protocol MyCustomCellDelegator {
    func callSegueFromCell(myData dataobject: AnyObject)
    func reloadTableView()
}

