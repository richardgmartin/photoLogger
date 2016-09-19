//
//  PostView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-24.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import SVProgressHUD

class PostView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: TitleTextField!
    @IBOutlet weak var descriptionTextView: DescriptionTextView!
    @IBOutlet weak var savePostButton: SavePostButton!
    
    var imagePicker: UIImagePickerController!
    var imageSelected: Bool = false
    var locationManager = CLLocationManager()
    var address: String?
    var postDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // initialize and set locationManager property values
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "PhotoLogger"
    }
    
    // determine address where photo is taken
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print(error)
            } else {
                if let placemark = placemarks?[0] {
                    print("PostView: RGM: placemark: \(placemark)")
                    
                    var subThoroughfare = ""
                    if placemark.subThoroughfare != nil {
                        subThoroughfare = placemark.subThoroughfare!
                    }
                    var thoroughfare = ""
                    if placemark.thoroughfare != nil {
                        thoroughfare = placemark.thoroughfare!
                    }
                    var subLocality = ""
                    if placemark.subLocality != nil {
                        subLocality = placemark.subLocality!
                    }
                    var subAdministrativeArea = ""
                    if placemark.subAdministrativeArea != nil {
                        subAdministrativeArea = placemark.subAdministrativeArea!
                    }
                    var postalCode = ""
                    if placemark.postalCode != nil {
                        postalCode = placemark.postalCode!
                    }
                    
                    self.address = subThoroughfare + " " + thoroughfare + " " + subLocality + " " + subAdministrativeArea + " " + postalCode
                    print("PostView: RGM: address: \(self.address)")
                    
                    self.locationManager.stopUpdatingLocation()
                }
            }
        }
    }
    
    // determine time and date photo is taken
    func getDateAndTime() -> String {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd yyyy HH:mm"
        let dateAndTime = dateFormatter.string(from: date as Date)
        return dateAndTime
    }
    
    // take photo or select image from library
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageSelected = true
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: AnyObject) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }

    // save post to firebase
    @IBAction func savePostButtonTapped(_ sender: AnyObject) {
        
        // determine time save post button is pushed
        self.postDate = getDateAndTime()
        print("PostView: RGM: self.postDate is ... \(self.postDate)")
        
        // check to make sure post entries complete
        guard let postTitle = titleTextField.text, postTitle != "" else {
            print("PostView: RGM: post title must be provided")
            return
        }
        guard let postDescription = descriptionTextView.text, postDescription != "" else {
            print("PostView: RGM: post description must be provided")
            return
        }
        guard let image = imageView.image, imageSelected == true else {
            print("PostView: RGM: image must be selected")
            return
        }
        guard let postAddress = self.address, postAddress != "" else {
            print("PostView: RGM: post address must be provided")
            return
        }
        guard let postDate = self.postDate, postDate != "" else {
            print("PostView: RGM: post date must be provided")
            return
        }
        
        // prepare image and post to Firebase Storage
        let imageUID = NSUUID().uuidString
        let imageData = UIImageJPEGRepresentation(image, 0.2)
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        
        // initiate progress indicator
        SVProgressHUD.show(withStatus: "Saving Post.")
        
        DataService.ds.REF_IMAGES.child(imageUID).put(imageData!, metadata: metaData) { (metaData, error) in
            if error != nil {
                print("PostView: RGM: error uploading image to firebase storage")
            } else {
                print("PostView: RGM: image upload to firebase storage was successful")
                print("PostView: RGM: imageUID is \(imageUID)")
                print("PostView: RGM: metaData is \(metaData)")
                
                let downloadURL = metaData?.downloadURL()?.absoluteString
                print("PostView: RGM: downloadURL is \(downloadURL)")
                if let url = downloadURL {
                    // self.postDataToFirebase(imageURL: url)
                    
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        // post data to firebase
                        self.postDataToFirebase(imageURL: url)
                        
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            _ = self.navigationController?.popViewController(animated: true)

                        }
                    }
                }
            }
        }
    }
    
    // upload post data (with image url) to Firebase database
    func postDataToFirebase(imageURL: String) {
        let photoLoggerPost: Dictionary<String, String> = [
            "taskImage": imageURL,
            "taskTitle": titleTextField.text!,
            "taskDescription": descriptionTextView.text,
            "taskAddress": self.address!,
            "taskDate": self.postDate!
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId()
        firebasePost.setValue(photoLoggerPost)
    }
}

