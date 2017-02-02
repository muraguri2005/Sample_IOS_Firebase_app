//
//  EventCell.swift
//  Firebase Sample App
//
//  Created by Richard Gathogo on 27/01/2017.
//  Copyright © 2017 Richard Gathogo. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    
    
    @IBOutlet weak var eventImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
