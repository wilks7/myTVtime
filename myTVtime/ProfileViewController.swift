//
//  ProfileViewController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/18/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionViewOutlet: UICollectionView!
    
    @IBAction func refreshButtonTapped(_ sender: AnyObject) {
        collectionViewOutlet.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if SeriesController.sharedController.myList.count >= 1 {
            return SeriesController.sharedController.myList.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCell", for: indexPath) as! ProfileCollectionViewCell
        
        if SeriesController.sharedController.myList.count >= 1 {
            let mySeries = SeriesController.sharedController.myList[indexPath.row]
            cell.setupCell(series: mySeries)
            return cell
        } else {
            cell.titleText.text = "Please Add Series"
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if SeriesController.sharedController.myList.count < 1 {
            
        } else {
            let series = SeriesController.sharedController.myList[indexPath.row]
            performSegue(withIdentifier: "toSeries", sender: series)
        }
        
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSeries"{
            let series = sender as! Series
            let targetViewController = segue.destination as! SeriesViewController
            targetViewController.series = series
        }
    }
}
extension UIImageView {
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
}
