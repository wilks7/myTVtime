//
//  FirstOpenViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/18/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import Foundation
import UIKit

class FirstOpenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var tableviewOutlet: UITableView!
    
    var data: [Series] = []
    
    var seriesList: [Series] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Tableview Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! FirstOpenTableViewCell
        let series = data[indexPath.row]
                
        cell.setupCell(series: series)
        
        cell.tintColor = .white
        
        
        let showsArray = Array(SeriesController.sharedController.watchedDict.keys) 
        
        if showsArray.contains(series.id){
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = indexPath.row
        let show = data[path]
        let showsArray = Array(SeriesController.sharedController.watchedDict.keys)
        
        if showsArray.contains(show.id) {
            
            SeriesController.sharedController.watchedDict[show.id] = nil
            
            if let listIndex = seriesList.index(of:show){
                    seriesList.remove(at: listIndex)
            }
            
            let theDict = SeriesController.sharedController.watchedDict
            let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
            UserDefaults.standard.set(data, forKey: "watchedDict")
        } else {
            seriesList.append(show)
            SeriesController.sharedController.watchedDict[show.id] = []
            let theDict = SeriesController.sharedController.watchedDict
            let data = NSKeyedArchiver.archivedData(withRootObject: theDict)
            UserDefaults.standard.set(data, forKey: "watchedDict")
        }
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")

        DispatchQueue.main.async(execute: {
            self.tableviewOutlet.reloadData()
        })
    }
    
    // SeachBar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let searchText = searchBar.text!
        
        NetworkController.searchSeries(searchText) { (shows, error) in
            if let shows = shows {
                self.data = []
                for show in shows {
                    self.data.append(show)
                }
            }
            DispatchQueue.main.async(execute: {
                self.tableviewOutlet.reloadData()
            })
        }
    }
    
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toList"{
            let list = self.seriesList
            let targetViewController = segue.destination as! FirstListViewController
            targetViewController.seriesList = list
        }
    }
}

extension UIImageView {
    func cacheImage(urlString: String, id: Int){
        if let imgURL = URL(string: urlString){
            let request = URLRequest(url: imgURL)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                if error == nil {
                    if let image = UIImage(data: data!){
                        if !urlString.contains("posters"){
                            SeriesController.sharedController.imageCache[id] = image
                        } else {
                            // handle poster cache
                        }

                        DispatchQueue.main.async(execute: {
                            self.image = image
                        })
                    } else {
                        DispatchQueue.main.async(execute: {
                            //self.backgroundColor = .gray
                            print("couldnt find image bad url")
                        })
                    }
                }
                else {
                    print("Error: \(error!.localizedDescription)")
                }
            }); task.resume()
        }
    }
}

