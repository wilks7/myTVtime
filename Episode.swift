//
//  Episode.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/17/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import Foundation

class Episode {
    
    // basic pull stats
    var absoluteNumber: Int = -1
    var airedEpisodeNumber: Int = -1
    var airedSeason: Int = 0
    var episodeName: String = ""
    var firstAired: String = ""
    var id: Int
    var language : [String:String] = [:]
    var overview = ""
    
    // extra
    var banner = ""
    var airsTime: String?
    var network: String?

    // full episode call
    var guestStars: [String] = []
    var director : String = ""
    var directors: [String] = []
    var writers: [String] = []
    var productionCode: String = ""
    var showUrl: String = ""
    var lastUpdated: Int = 0
    var filename: String = ""
    var seriesId: Int = 0
    var lastUpdatedBy: String = ""
    var airsAfterSeason:Int = 0
    var airsBeforeSeason: Int = 0
    var airsBeforeEpisode: Int = 0
    var thumbAuthor: Int = 0
    var thumbAdded: String = ""
    var thumbWidth: String = ""
    var thumbHeight: String = ""
    var imdbId: String = ""
    var siteRating: Int = 0
    var siteRatingCount: Int = 0
    
    init(dict: [String:AnyObject]){
        if let absoluteNumber = dict["absoluteNumber"] as? Int {
            self.absoluteNumber = absoluteNumber
        }
        if let airedEpisodeNumber = dict["airedEpisodeNumber"] as? Int {
            self.airedEpisodeNumber = airedEpisodeNumber
        }
        if let airedSeason = dict["airedSeason"] as? Int {
            self.airedSeason = airedSeason
        }

        if let episodeName = dict["episodeName"] as? String {
            self.episodeName = episodeName
        }
        if let firstAired = dict["firstAired"] as? String {
            self.firstAired = firstAired
        }
        if let id = dict["id"] as? Int {
            self.id = id
        } else {
            self.id = 0
        }
        if let language = dict["language"] as? [String:String] {
            self.language = language
        }
        if let overview = dict["overview"] as? String {
            self.overview = overview
        }
        if let banner = dict["banner"] as? String {
            self.banner = banner
        }
    }
}
extension Episode: Equatable {
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id
    }
}
