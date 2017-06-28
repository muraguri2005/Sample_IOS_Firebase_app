//
//  EventVC.swift
//  Firebase Sample App
//
//  Created by Richard Muraguri Gathogo on 16/06/2017.
//  Copyright © 2017 Richard Gathogo. All rights reserved.
//

import UIKit

class EventVC: UIViewController {
    var event: Event? {
        didSet {
            updateUI();
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateUI();
        
    }
    
    func updateUI(){
        nameLabel?.text = event?.name
        descriptionLabel?.text = event?.eventDescription

    }

}
