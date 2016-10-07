//
//  FirstListViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/18/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class FirstListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var seriesDict = [Int:String]()
    var seriesList: [Series] = []
    
    @IBAction func navbarDoneTapped(_ sender: AnyObject) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seriesList.count > 0 {
            return seriesList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! FirstOpenTableViewCell
        
        
        if seriesList.count > 0 {
            let series = seriesList[indexPath.row]
            cell.setupCell(series: series)
        } else {
            cell.imageViewOutlet.backgroundColor = .blue
        }
        
        return cell
    }
}
