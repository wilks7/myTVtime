//
//  ScheduleTableViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/22/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController, MyCustomCellDelegator {
    
    var weekList:[[Episode]] = [[],[],[],[],[],[],[]]
    
    var unsorted: [Episode]?
    
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMyList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkFirstLaunch()
        self.tableView.reloadData()
    }

    func loadMyList(){
        let outData = UserDefaults.standard.data(forKey: "watchedDict")
        if let outData = outData {
            if let dict = NSKeyedUnarchiver.unarchiveObject(with: outData) as? [Int:[Int]] {
                SeriesController.sharedController.watchedDict = dict
                let showArray = Array(SeriesController.sharedController.watchedDict.keys)
                NetworkController.cacheAllBanners(series: showArray, completion: { (done, error) in
                    // TODO: Find a way to combine cacheAllBanners and seriesByID
                    if done {
                        for id in showArray {
                            
                            NetworkController.seriesByID(id, completion: { (series, error) in
                                guard let series = series else {return;}
                                SeriesController.sharedController.myList.append(series)
                                
                                if series.status == "Continuing"{ //  && series.airsDayOfWeek == today
                                    for i in 0...6 {
                                        let now = Date()
                                        let myCalen = NSCalendar.current
                                        let dateStringFormatter = DateFormatter()
                                        dateStringFormatter.dateFormat = "yyyy-MM-dd"
                                        var dayComp = DateComponents()
                                        dayComp.day = i
                                        let nextDay = myCalen.date(byAdding: dayComp, to: now)!
                                        let dateString = dateStringFormatter.string(from: nextDay)
                                        print(dateString)
                                        
                                        NetworkController.getCurrentEpisode(id: series.id, day:dateString, completion: { (episodes, error) in
                                            for episodeDict in episodes {
                                                let episode = Episode(dict: episodeDict)
                                                episode.banner = series.banner!
                                                episode.seriesId = id
                                                episode.network = series.network
                                                episode.airsTime = series.airsTime
                                                
                                                
                                                if !self.weekList[i].contains(episode){
                                                    self.weekList[i].append(episode)
                                                }
                                            }
                                            DispatchQueue.main.async(execute: {
                                                self.tableView.reloadData()
                                            })
                                        })
                                    }
                                }
                                DispatchQueue.main.async(execute: {
                                    self.tableView.reloadData()
                                })
                            })
                        }// for
                    }// if
                })//cacheAllBanners
            }
        }
        
    }
    
    func checkFirstLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore {
            self.performSegue(withIdentifier: "firstTime", sender: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weekList[section].count < 1 {
            return 1
        } else {
            return weekList[section].count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let now = Date()
        let myCalen = NSCalendar.current
        let todayFormatter = DateFormatter()
        todayFormatter.dateFormat = "EEEE"
        
        var dayComp = DateComponents()
        dayComp.day = section
        let nextDay = myCalen.date(byAdding: dayComp, to: now)!
        return todayFormatter.string(from: nextDay)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day0", for: indexPath) as! ScheduleTableViewCell
        
        cell.delegate = self
        
        if weekList[indexPath.section].count < 1 {
            cell.imageViewOutlet.image = UIImage(named: "grayRect")
            cell.episodeTitleOutlet.text = "No episodes in section\(indexPath.section)"
        } else {
            let episode = weekList[indexPath.section][indexPath.row]
            cell.setupCell(episode: episode)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if weekList[indexPath.section].count > 0 {
        
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
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ScheduleTableViewCell).watchFrameChanges()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! ScheduleTableViewCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [ScheduleTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return ScheduleTableViewCell.expandedHeight
        } else {
            return ScheduleTableViewCell.defaultHeight
        }
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    // Navigation
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        self.performSegue(withIdentifier: "toEpisode", sender:dataobject)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEpisode"{
            let dVC = segue.destination as! EpisodeViewController
            guard let id = sender as? Int else {return;}
            dVC.id = id
        }
    }

}
