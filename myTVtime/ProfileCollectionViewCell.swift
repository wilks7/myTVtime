//
//  ProfileCollectionViewCell.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/18/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleText: UILabel!
    
    @IBOutlet weak var imageOutlet: UIImageView!
    
    func setupCell(series: Series){
        let base = "http://thetvdb.com/banners/"
        NetworkController.getPosterUrl(id: series.id) { (url, error) in
            let fullUrl = base + url
            self.imageOutlet.cacheImage(urlString: fullUrl, id: series.id)
        }
        
        self.titleText.text = series.seriesName
        
    }
    
}
