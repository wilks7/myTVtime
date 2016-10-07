//
//  Show.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/10/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import Foundation
import UIKit

class Series {
    
    var aliases: [String]?
    var banner: String?
    var firstAired: String?
    var id: Int
    var network: String?
    var overview: String?
    var seriesName: String?
    var status: String?
    
    // details variables
    var runtime: String?
    var genre: [String]?
    var lastUpdated: Int?
    var airsDayOfWeek: String?
    var airsTime: String?
    var rating: String?
    var imdbId: String?
    var zap2itId: String?
    var added: String?
    var siteRating: Int?
    var siteRatingCount: Int?
    
    init(aliases: [String], banner: String, firstAired: String, id: Int, network: String, overview: String, seriesName: String, status: String){
        
        self.aliases = aliases
        self.banner = banner
        self.firstAired = firstAired
        self.id = id
        self.network = network
        self.overview = overview
        self.seriesName = seriesName
        self.status = status
    }
    
    init(dict: [String:AnyObject]){
        self.aliases = dict["aliases"] as? [String]
        self.banner = dict["banner"] as? String
        self.firstAired = dict["firstAired"] as? String
        self.id = dict["id"] as! Int
        self.network = dict["network"] as? String
        self.overview = dict["overview"] as? String
        self.seriesName = dict["seriesName"] as? String
        self.status = dict["status"] as? String
        self.airsTime = dict["airsTime"] as? String
    }
    
//    init(id: Int){
//        NetworkController.seriesByID(id) { (series, error) in
//                let showDict = series!
//        
//                self.aliases = showDict["aliases"] as? [String]
//                self.banner = showDict["banner"] as? String
//                self.firstAired = showDict["firstAired"] as? String
//                self.id = id
//                self.network = showDict["network"] as? String
//                self.overview = showDict["overview"] as? String
//                self.seriesName = showDict["seriesName"] as? String
//                self.status = showDict["status"] as? String
//            }
//        }
}


extension Series: Equatable {
     static func == (lhs: Series, rhs: Series) -> Bool {
        return lhs.id == rhs.id
    }
}

