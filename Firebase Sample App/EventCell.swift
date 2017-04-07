//
//  EventCell.swift
//  Firebase Sample App
//
//  Created by Richard Gathogo on 27/01/2017.
//  Copyright © 2017 Richard Gathogo. All rights reserved.
//

import UIKit
import FirebaseStorage

class EventCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    let dateFormatter = DateFormatter();
    
    var event:Event? {
        didSet {
            eventName?.text = event?.name
            eventDescription?.text = event?.eventDescription
            eventLocation?.text = event?.location
            if let startDateValue = event?.startDate.doubleValue {
                let startDate = Date(timeIntervalSince1970: TimeInterval(startDateValue/1000))
                eventStartDate?.text = String(describing: dateFormatter.string(from: startDate))
            }
            
            if let imageURL = event?.posterPath {
                if imageURL.hasPrefix("gs://") {
                    FIRStorage.storage().reference(forURL: imageURL).data(withMaxSize: INT64_MAX) {[weak self] (data,error) in
                        if let error = error {
                            print("Error \(error.localizedDescription)")
                            return
                        }
                        let image = UIImage(data: data!);
                        let oldWidth = image!.size.width;
                        var scaleFactor: CGFloat = 1
                        if let thisWidth = self?.bounds.size.width {
                            scaleFactor = thisWidth/oldWidth;
                        }
                        let newHeight = image!.size.height * scaleFactor;
                        let newWidth = oldWidth * scaleFactor;
                        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight));
                        image?.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight));
                        let newImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        self?.eventImage?.image = newImage;
                        
                    }
                } else if let URL = URL(string:imageURL), let data = try? Data(contentsOf: URL){
                    eventImage?.image = UIImage(data: data);
                }
            } else {
                eventImage?.image = nil;
            }
            
        }
    }
    
    
    @IBOutlet weak var eventImage: UIImageView!
    override func awakeFromNib() {
        dateFormatter.dateFormat = "yyyy-MM-dd hh:ss";
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
}
