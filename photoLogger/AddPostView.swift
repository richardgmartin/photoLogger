//
//  AddPostView.swift
//  photoLogger
//
//  Created by Richard Martin on 2016-08-24.
//  Copyright © 2016 richard martin. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import SVProgressHUD

class AddPostView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: TitleTextField!
    @IBOutlet weak var savePostButton: SavePostButton!
    @IBOutlet weak var descriptionTextView: TitleTextField!
    
    var imagePicker: UIImagePickerController!
    var imageSelected: Bool = false
    var locationManager = CLLocationManager()
    var address: String?
    var postDate: String?
    var choice = "blank"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: #imageLiteral(resourceName: "photo-logger-logo-white"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 35)
        navigationItem.titleView = imageView
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // initialize and set locationManager property values
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "PHOTO LOGGER"
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
        // present alert controller (with action sheet) to select access to either camera or photo library
        
        let alertController = UIAlertController(title: "Choose Photo Source", message: "Please choose either camera or your photo library.", preferredStyle: .actionSheet)
        let cameraButton = UIAlertAction(title: "Select Camera", style: .default) { (action) in
            print("RGM -> AddPostView -> camera button pressed for image choice.")
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.imagePicker.sourceType = .camera
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let savePhotosButton = UIAlertAction(title: "Select Photo Album", style: .default) { (action) in
            print("RGM -> AddPostView -> photo library button pressed for image choice.")
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
            print("RGM -> AddPostView -> cancel button pressed for image choice.")
        }
        alertController.addAction(cameraButton)
        alertController.addAction(savePhotosButton)
        alertController.addAction(cancelButton)
        
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // save post to firebase
    @IBAction func savePostButtonTapped(_ sender: AnyObject) {
        
        // determine time save post button is pushed
        self.postDate = getDateAndTime()
        print("PostView: RGM: self.postDate is ... \(self.postDate)")
        
        // determine if access to user location was denied and if yes, request access again
        if CLLocationManager.authorizationStatus() == .denied {
            let alertController = UIAlertController(
                title: "You Have Denied Access to Your Location",
                message: "In order to provide the address of where your image was taken, please open this app's settings and allow location access to 'While Using the App'.",
                preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
                if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                }
            })
            alertController.addAction(openAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        // check to make sure post entries complete
        guard let postTitle = titleTextField.text, postTitle != "" else {
            displayAlert(messageToDisplay: "Post title is required. Please complete.")
            return
        }
        guard let postDescription = descriptionTextView.text, postDescription != "" else {
            displayAlert(messageToDisplay: "Post description is required. Please complete.")
            return
        }
        guard let image = imageView.image, imageSelected == true else {
            displayAlert(messageToDisplay: "Post image is required. Please click camera icon in top right hand corner.")
            return
        }
        guard let postAddress = self.address, postAddress != "" else {
            return
        }
        guard let postDate = self.postDate, postDate != "" else {
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
            "taskDescription": descriptionTextView.text!,
            "taskAddress": self.address!,
            "taskDate": self.postDate!
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.child((FIRAuth.auth()?.currentUser?.uid)!).childByAutoId()
        firebasePost.setValue(photoLoggerPost)
    }
    
    // alert controller to display message to user
    func displayAlert(messageToDisplay: String) {
        
        let alertController = UIAlertController(title: "Not Enough Information to Create Post", message: messageToDisplay, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK. Try Again", style: .default) { (action: UIAlertAction!) in
                print("RGM -> AddPostView -> OK button tapped on Alert")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

