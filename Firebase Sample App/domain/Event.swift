//
//  Event.swift
//  Firebase Sample App
//
//  Created by Richard Gathogo on 27/01/2017.
//  Copyright © 2017 Richard Gathogo. All rights reserved.
//

import Foundation
import Firebase
class Event:NSObject {
    var startDate : NSNumber;
    var name: String;
    var eventDescription: String;
    var location:String;
    init(event:Dictionary<String,AnyObject>) {
        startDate = event[EventFields.START_DATE] as? NSNumber ?? NSNumber(value: 0)
        location = event[EventFields.LOCATION] as? String ?? ""
        name = event[EventFields.NAME] as? String ?? ""
        eventDescription = event[EventFields.DESCRIPTION] as? String ?? ""
        super.init();
    }
}
