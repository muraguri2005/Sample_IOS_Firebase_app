//
//  AddEventVC.swift
//  Firebase Sample App
//
//  Created by Richard Gathogo on 27/01/2017.
//  Copyright © 2017 Richard Gathogo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddEventVC: UIViewController {
    var ref:FIRDatabaseReference!

    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    @IBAction func saveEvent(_ sender: UIButton) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            let notLoggedInVC = UIAlertController(title:"Not Logged Int",message:"Please Log in first",preferredStyle:.alert);
            let close = UIAlertAction(title: "Close", style: .default, handler: nil)
            notLoggedInVC.addAction(close);
            self.present(notLoggedInVC, animated: true, completion: nil)
            return;
        }
        
        var data = Dictionary<String,AnyObject>();
        
        data[EventFields.DESCRIPTION] = eventDescription.text as AnyObject?;
        data[EventFields.NAME] = eventName.text as AnyObject?;
        data[EventFields.LOCATION] = eventLocation.text as AnyObject?;
        let time = startDatePicker.date.timeIntervalSince1970*1000;
        data[EventFields.START_DATE] = time as AnyObject?;
        data[EventFields.USERID] = currentUser.uid as AnyObject?;
        
        ref?.child("events").childByAutoId().setValue(data, withCompletionBlock: { (error, firDB) in
            print(error ?? "event saved successfully")
        });
    }
    
    @IBAction func cancelAddEvent(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
}
