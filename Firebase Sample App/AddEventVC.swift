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
import Photos
import FirebaseStorage
class AddEventVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var ref:FIRDatabaseReference!
    
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    var storageRef: FIRStorageReference!
    
    var data = Dictionary<String,AnyObject>();
    var imageId = Int(Date.timeIntervalSinceReferenceDate*1000);
    var eventId : String?
    
    @IBAction func saveEvent(_ sender: UIButton) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            let notLoggedInVC = UIAlertController(title:"Not Logged In",message:"Please Log in first",preferredStyle:.alert);
            let close = UIAlertAction(title: "Close", style: .default, handler: nil)
            notLoggedInVC.addAction(close);
            self.present(notLoggedInVC, animated: true, completion: nil)
            return;
        }
        saveEventToDB(uid: currentUser.uid);
    }
    
    @IBAction func cancelAddEvent(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func attachEventPoster(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController();
        
        imagePickerVC.delegate = self;
        imagePickerVC.sourceType = .photoLibrary;
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        if let referenceURL = info[UIImagePickerControllerReferenceURL] {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL as! URL], options: nil)
            let asset = assets.firstObject;
            asset?.requestContentEditingInput(with: nil) { [weak self] (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
               
                guard let strongSelf = self  else {return}
                 let filePath = "\(uid)/\(strongSelf.imageId)/\((referenceURL as AnyObject).lastPathComponent!)"
                strongSelf.storageRef.child(filePath).putFile(imageFile!, metadata: nil) { (metadata, error) in
                    if let nsError = error as? NSError {
                        print("Error uploading: \(nsError.localizedDescription)")
                        return;
                    }
                strongSelf.data[EventFields.POSTER_PATH]=strongSelf.storageRef.child((metadata?.path)!).description as AnyObject?;
                    strongSelf.saveEventToDB(uid: uid);
                                        
                }
            }
            
        }
        print("Picked");
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("cancelled");
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStorage();
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func configureStorage(){
        storageRef = FIRStorage.storage().reference(forURL: "gs://sampleandroidappusingfir-a68b0.appspot.com");
    }
    func saveEventToDB(uid:String){
        data[EventFields.DESCRIPTION] = eventDescription.text as AnyObject?;
        data[EventFields.NAME] = eventName.text as AnyObject?;
        data[EventFields.LOCATION] = eventLocation.text as AnyObject?;
        let time = startDatePicker.date.timeIntervalSince1970*1000;
        data[EventFields.START_DATE] = time as AnyObject?;
        data[EventFields.USERID] = uid as AnyObject?;
        if eventId == nil {
            eventId = ref?.child("events").childByAutoId().key;
        }
        ref.child("events").child(eventId!).setValue(data, withCompletionBlock: { (error, firDB) in
            print(error ?? "event saved successfully")
        });
        
    }
    
}
