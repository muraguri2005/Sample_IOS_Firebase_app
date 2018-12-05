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
    var ref:DatabaseReference!
    
    @IBOutlet weak var eventDescription: UITextField!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventLocation: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    
    var storageRef: StorageReference!
    
    var posterPath : String?
    var imageId = Int(Date.timeIntervalSinceReferenceDate*1000);
    var eventId : String?
    var event : Event? {
        didSet {
            updateUI()
        }
        
    }
    
    
    var updatedEvent : Event {
        return Event(name: eventName.text ?? "no name", description: eventDescription.text ?? "no description", userId: Auth.auth().currentUser?.uid ?? "no uid", location: eventLocation.text ?? "no location", startDate: NSNumber(value:startDatePicker.date.timeIntervalSince1970*1000))
    }
    private func updateUI() {
        self.navigationItem.title = event?.name
        eventDescription?.text = event?.eventDescription
        eventName?.text = event?.name
        eventLocation?.text = event?.location
        if let time = event?.startDate.doubleValue {
            startDatePicker?.date = Date(timeIntervalSince1970: time/1000)
        }
    }
    
    
    @IBAction func saveEvent(_ sender: UIBarButtonItem) {
        saveEventToDB();
    }
    
    @IBAction func attachEventPoster(_ sender: UIButton) {
        let imagePickerVC = UIImagePickerController();
        
        imagePickerVC.delegate = self;
        imagePickerVC.sourceType = .photoLibrary;
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if let referenceURL = info[UIImagePickerControllerReferenceURL] {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL as! URL], options: nil)
            let asset = assets.firstObject;
            asset?.requestContentEditingInput(with: nil) { [weak self] (contentEditingInput, info) in
                let imageFile = contentEditingInput?.fullSizeImageURL
                
                guard let strongSelf = self  else {return}
                let filePath = "\(uid)/\(strongSelf.imageId)/\((referenceURL as AnyObject).lastPathComponent!)"
                strongSelf.storageRef.child(filePath).putFile(from: imageFile!, metadata: nil) { (metadata, error) in
                    if let nsError = error as NSError? {
                        print("Error uploading: \(nsError.localizedDescription)")
                        return;
                    }
                    strongSelf.posterPath=strongSelf.storageRef.child((metadata?.path)!).description;
                    if strongSelf.eventId != nil {
                        strongSelf.saveEventToDB();
                    }
                }
            }
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStorage();
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func configureStorage(){
        storageRef = Storage.storage().reference(forURL: "gs://sampleandroidappusingfir-a68b0.appspot.com");
    }
    func saveEventToDB(){
        guard let currentUser = Auth.auth().currentUser,
            let description = eventDescription.text, !description.isEmpty,
            let name = eventName.text, !name.isEmpty,
            let location = eventLocation.text, !location.isEmpty
            else {
                var message = "Invalid Data";
                var title = "You must fill all the fields before saving";
                if Auth.auth().currentUser == nil {
                    message = "Please Log in first";
                    title = "Not Logged In";
                }
                showAlert(message, withTitle: title)
                return
        }
        let data = [
            EventFields.DESCRIPTION: description,
            EventFields.NAME: name,
            EventFields.LOCATION:location,
            EventFields.START_DATE:startDatePicker.date.timeIntervalSince1970*1000,
            EventFields.USERID:currentUser.uid,
            EventFields.POSTER_PATH:posterPath ?? ""] as [String : Any];
        if eventId == nil {
            eventId = ref?.child("events").childByAutoId().key;
        }
        ref.child("events").child(eventId!).setValue(data, withCompletionBlock: { [weak self] (error, firDB) in
            if error == nil {
                self?.event = Event(event:data as Dictionary<String, AnyObject>)
                self?.showAlert("Event saved Successfully", withTitle: "Event Saved")
                self?.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                print(error ?? "")
            }
        })
        
    }
    func showAlert(_ message:String,withTitle title: String){
        let alertVC = UIAlertController(title:title,message:message,preferredStyle:.alert);
        let close = UIAlertAction(title: "Close", style: .default, handler: nil)
        alertVC.addAction(close);
        self.present(alertVC, animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let popoverPresentationController = navigationController?.popoverPresentationController{
            if popoverPresentationController.arrowDirection != .unknown {
                navigationItem.rightBarButtonItem = nil
            }
        }
    }
    
}
