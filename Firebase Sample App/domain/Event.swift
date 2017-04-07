//
//  Event.swift
//  Firebase Sample App
//
//  Created by Richard Gathogo on 27/01/2017.
//  Copyright © 2017 Richard Gathogo. All rights reserved.
//

import Foundation
import Firebase
struct Event {
    var startDate : NSNumber;
    var name: String;
    var eventDescription: String;
    var location:String;
    var posterPath:String?
    var userId : String
    init(event:Dictionary<String,AnyObject>) {
        startDate = event[EventFields.START_DATE] as? NSNumber ?? NSNumber(value: 0)
        location = event[EventFields.LOCATION] as? String ?? ""
        name = event[EventFields.NAME] as? String ?? ""
        eventDescription = event[EventFields.DESCRIPTION] as? String ?? ""
        posterPath =  event[EventFields.POSTER_PATH] as? String
        userId = event[EventFields.USERID] as! String
    }
    
}
