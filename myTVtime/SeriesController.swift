//
//  SeriesController.swift
//  myTVtime
//
//  Created by Michael Wilkowski on 9/18/16.
//  Copyright © 2016 Rifigy. All rights reserved.
//

import Foundation
import UIKit

class SeriesController {
    
    static let sharedController = SeriesController()
    
    var myList: [Series] = []
    
    var imageCache = [Int:UIImage]()
    
    var myWatchedList = [Int]()
    
    var todayList = [Episode]()
    
    var watchedDict: [Int:[Int]] = [0:[]]
    
    var toWatchDict: [Int:[Int]] = [0:[]]

}
