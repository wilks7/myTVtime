//
//  FirstOpenTableViewCell.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/18/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class FirstOpenTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet weak var titleOutlet: UILabel!


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(series: Series){
        
        if let img = SeriesController.sharedController.imageCache[series.id] {
            self.titleOutlet?.isHidden = true
            self.imageViewOutlet.image = img
        }
        else {
            if let bannerUrl = series.banner {
                if bannerUrl.characters.count > 5 {
                    self.titleOutlet?.isHidden = true
                    let urlString  = "http://thetvdb.com/banners/\(bannerUrl)"
                    self.imageViewOutlet.cacheImage(urlString: urlString, id: series.id)
                } else {
                    DispatchQueue.main.async(execute: {
                        self.imageViewOutlet.image = UIImage(named: "grayRect")
                        self.titleOutlet?.isHidden = false
                        self.titleOutlet?.text = series.seriesName
                    })                    
                }
            }
        }
    }
}
