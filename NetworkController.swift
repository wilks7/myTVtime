//
//  NetworkController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/10/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import Foundation
import UIKit 


class NetworkController {
    
    static var myToken = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE0NzQ2NTI5ODYsImlkIjoibXlUVnRpbWUiLCJvcmlnX2lhdCI6MTQ3NDU2NjU4Nn0.BMsTzrNhys_jhZyHYHmGuGnpJ4ZMtyFC3oCgzj3jva4meFNSDlaCmOj3jgbOLDbizdgQYB4ZiLjtBv3pCXBxP7uAIISwnd3KqUaxO-hXdoyePDUP_kGyiKTHSXTjp7HhWskzr94NY9I154d4ECfP6ChMQXj0HYnY1WMX7Vq7zLldPZZEv-dDSs-BxpINba9ggMjW3c_coiiN_AFoZnwZOhquyR9gojRUfUZE8Mqq83SOsozm0ngLK0BXvWXMSOLfqJX5i9p6-D9CtyscCEln7Y09Qm-xj4H0mS_Q4GP06F-1VpxI7hiA59zQ8mu5x2_196cq-EEdVWlgJHdQWUgAVA"
    
    static let baseUrl = "https://api.thetvdb.com/"
    
    
    static func refreshToken(){
        let urlStr = baseUrl + "refresh_token"
        let myUrl = URL(string: urlStr)
        
        var request = URLRequest(url:myUrl!)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let headerString = "Bearer \(myToken)"
        request.addValue(headerString, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if error != nil { print("error=\(error)"); return }
            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if let dataDict = convertedJsonIntoDict as? [String:String] {
                        if let token = dataDict["token"] {
                            myToken = token
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }); task.resume()
    }
    
    static func getPageCount(_ id: Int, completion:@escaping(_ pageCount: Int)->Void) {
        
            let idString = String(id)
            let searchUrl = baseUrl + "series/\(idString)/episodes"
            let searchParam = searchUrl
            let myUrl = URL(string: searchParam)
            
            var request = URLRequest(url:myUrl!)
            
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let headerString = "Bearer " + myToken
            request.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                            if let linksDict = dataDict["links"] as? [String:AnyObject]{
                                if let pageCount = linksDict["last"] as? Int {
                                    completion(pageCount)
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }); task.resume()
    }

    static func getCurrentEpisode(id: Int, day: String, completion:@escaping(_ episodeDict: [[String:AnyObject]], _ error: NSError?)->Void) {        
        
        let urlStr = baseUrl + "series/\(id)/episodes/query?firstAired=\(day)"
        
        let myUrl = URL(string: urlStr)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let headerString = "Bearer " + myToken
        request.addValue(headerString, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if error != nil {
                print("error=\(error)")
                completion([["":"" as AnyObject]], error as NSError?)
                return
            }
            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                        if var dataArray = dataDict["data"] as? [[String:AnyObject]]{
                            dataArray[0]["banner"] = "" as AnyObject
                            completion(dataArray, nil)
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }); task.resume()
    }
    
    static func getPosterUrl(id: Int, completion:@escaping(_ url: String, _ error: NSError?)->Void) {
        let urlStr = baseUrl + "series/\(id)/images/query?keyType=poster"
        
        let myUrl = URL(string: urlStr)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let headerString = "Bearer " + myToken
        request.addValue(headerString, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if error != nil {
                print("error=\(error)")
                completion("", error as NSError?)
                return
            }
            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                        if let dataArray = dataDict["data"] as? [[String:AnyObject]]{
                            var count = 0
                            var myUrl = ""
                            for posterDict in dataArray {
                                
                                if let posterSmall = posterDict["thumbnail"] as? String, let ratingCount = posterDict["ratingsInfo"] as? [String:Int] {
                                    if ratingCount["count"]! > 0 {
                                        count = ratingCount["count"]!
                                        myUrl = posterSmall
                                    }
                                }
                            }
                            completion(myUrl, nil)
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }); task.resume()
    }
    
    static func episodeByID(_ id: Int, completion:@escaping (_ series: Episode?, _ error: NSError?)->Void) {
        let urlStr = baseUrl + "episodes/\(id)"
        
        let myUrl = URL(string: urlStr)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let headerString = "Bearer " + myToken
        request.addValue(headerString, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if error != nil {
                print("error=\(error)")
                completion(nil, error as NSError?)
                return
            }
            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                        if let episodeDict = dataDict["data"] as? [String:AnyObject]{
                            let myEpisode = Episode(dict: episodeDict)
                            completion(myEpisode, nil)
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(nil, error as NSError?)
            }
            
        }); task.resume()
    }
    
    static func seriesByID(_ id: Int, completion:@escaping (_ series: Series?, _ error: NSError?)->Void) {
        let urlStr = baseUrl + "series/\(id)"
        
        let myUrl = URL(string: urlStr)
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let headerString = "Bearer " + myToken
        request.addValue(headerString, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if error != nil {
                print("error=\(error)")
                completion(nil, error as NSError?)
                return
            }
            
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                        if let seriesDict = dataDict["data"] as? [String:AnyObject]{
                            let mySeries = Series(dict: seriesDict)
                            completion(mySeries, nil)
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
                completion(nil, error as NSError?)
            }
            
        }); task.resume()
    }
    
    static func searchSeries(_ search: String, completion:@escaping (_ shows: [Series]?, _ error: NSError?)->Void) {
        
    let searchUrl = baseUrl + "search/series?name="
    let searchParam = searchUrl + search
    let searchParamNoSpace = searchParam.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!

    let myUrl = URL(string: searchParamNoSpace)
    
    var request = URLRequest(url:myUrl!)
    
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    let headerString = "Bearer " + myToken
    request.addValue(headerString, forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
        
        if error != nil {
            print("error=\(error)")
            completion(nil, error as NSError?)
            return
        }
        
        // Convert server json response to Dictionary
        do {
            if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                
                if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                    if let dataArray = dataDict["data"] as? [[String:AnyObject]]{
                        var shows = [Series]()
                        for show in dataArray {
                            guard let id = show["id"] as? Int else {return;}
                            if let aliases = show["aliases"] as? [String], let banner = show["banner"] as? String, let firstAired = show["firstAired"] as? String, let overview = show["overview"] as? String, let seriesName = show["seriesName"] as? String, let status = show["status"] as? String, let network = show["network"] as? String {
                                let showObject = Series(aliases: aliases, banner: banner, firstAired: firstAired, id: id, network: network, overview: overview, seriesName: seriesName, status: status)
                                shows.append(showObject)
                            }
                        }
                        completion(shows, nil)
                    }
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            completion(nil, error as NSError?)
        }
        
    }); task.resume()
    }
    
    static func getBanners(series: [Int], completion:@escaping(_ bannerUrls: [Int:String], _ error: NSError?)->Void){
        var dict: [Int:String]
        for id in series {
            let urlStr = baseUrl + "series/\(id)"
            
            let myUrl = URL(string: urlStr)
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let headerString = "Bearer " + myToken
            request.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    //completion(false, error as NSError?)
                    return
                }
                
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                            if let details = dataDict["data"] as? [String:AnyObject]{
                                if let banner = details["banner"] as? String {
                                    
                                }
                            }
                        }
                    }
                }catch let error as NSError {
                    print(error.localizedDescription)
                }
            }); task.resume()
        }
    }
    
    static func cacheAllBanners(series: [Int], completion:@escaping (_ done: Bool, _ error: NSError?)->Void){
        
        var dict: [Int:String] = [0:""]
        for id in series {
            let urlStr = baseUrl + "series/\(id)"
            
            let myUrl = URL(string: urlStr)
            var request = URLRequest(url:myUrl!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let headerString = "Bearer " + myToken
            request.addValue(headerString, forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                
                if error != nil {
                    print("error=\(error)")
                    completion(false, error as NSError?)
                    return
                }
                
                do {
                    if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                            if let details = dataDict["data"] as? [String:AnyObject]{
                                if let banner = details["banner"] as? String {
                                    let urlString = "http://thetvdb.com/banners/" + banner
                                    if let imgURL = URL(string: urlString){
                                        let request = URLRequest(url: imgURL)
                                        
                                        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                                            if error == nil {
                                                if let image = UIImage(data: data!){
                                                    SeriesController.sharedController.imageCache[id] = image

                                                }
                                            }
                                        }); task.resume()
                                    }

                                   dict[id] = banner
                                }
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                
            }); task.resume()
        }
        completion(true, nil)
        
    }
    
    static func getEpisodes(_ id: Int, completion:@escaping (_ episode: [Episode]?, _ error: NSError?)->Void) {
        
        NetworkController.getPageCount(id) { (pageCount) in
            var allEpisodes = [Episode]()
            for i in 1...pageCount {
                let idString = String(id)
                let searchUrl = baseUrl + "series/\(idString)/episodes?page=\(i)"
                let searchParam = searchUrl
                let myUrl = URL(string: searchParam)
                
                var request = URLRequest(url:myUrl!)
                
                request.httpMethod = "GET"
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                let headerString = "Bearer " + myToken
                request.addValue(headerString, forHTTPHeaderField: "Authorization")
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                    
                    if error != nil {
                        print("error=\(error)")
                        completion(nil, error as NSError?)
                        return
                    }
                    
                    do {
                        if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            
                            if let dataDict = convertedJsonIntoDict as? [String:AnyObject] {
                                if let dataArray = dataDict["data"] as? [[String:AnyObject]]{
                                    for episodeDict in dataArray {
                                        
                                        let episode = Episode(dict: episodeDict)
                                        //print("S\(episode.airedSeason)E\(episode.airedEpisodeNumber)")
                                        if episode.absoluteNumber < 0 {
                                            if episode.airedSeason > 0 && episode.airedEpisodeNumber > 0 {
                                                allEpisodes.append(episode)
                                            }
                                        } else {
                                            allEpisodes.append(episode)
                                        }
                                    }
                                }
                            }
                        }
                        completion(allEpisodes, nil)
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        completion(nil, error as NSError?)
                    }
                }); task.resume()
            }
        }
    }
}
