//
//  AddPlaceTableViewController.swift
//  Lugares 2.0
//
//  Created by Rafael Larrosa Espejo on 12/10/16.
//  Copyright © 2016 Rafael Larrosa Espejo. All rights reserved.
//

import UIKit

class AddPlaceViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var textfieldName: UITextField!
    @IBOutlet var textfieldType: UITextField!
    @IBOutlet var textfieldDirection: UITextField!
    @IBOutlet var textfieldTelephone: UITextField!
    @IBOutlet var textfieldWebsite: UITextField!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var rating: String?
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textfieldName.delegate = self
        self.textfieldType.delegate = self
        self.textfieldDirection.delegate = self
        self.textfieldTelephone.delegate = self
        self.textfieldWebsite.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    let defaultColor = UIColor(red: 150.0/255.0, green: 150.0/255.0, blue: 150.0/255.0, alpha: 1)
    let selectedColor = UIColor.red
    
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
        if let name = self.textfieldName.text, let type = self.textfieldType.text, let direction = self.textfieldDirection.text, let telephone = self.textfieldTelephone.text, let website   = self.textfieldWebsite.text, let theImage = self.imageView.image, let rating = self.rating{
            
            self.place = Place(name: name, type: type, location: direction, image: theImage, telephone: telephone, website: website)
            place!.rating = rating
            
            
            print (place!.name)
            self.performSegue(withIdentifier: "unwindToMainViewController", sender: self)
        }else{
            let alertController = UIAlertController(title: "Falta algún dato", message: "Revisa que lo tengas todo rellenado.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func ratingPressed(_ sender: AnyObject) {
        
        switch sender.tag {
        case 1:
            self.rating = "dislike"
            self.button1.backgroundColor = selectedColor
            self.button2.backgroundColor = defaultColor
            self.button3.backgroundColor = defaultColor
        case 2:
            self.rating = "good"
            self.button1.backgroundColor = defaultColor
            self.button2.backgroundColor = selectedColor
            self.button3.backgroundColor = defaultColor
        case 3:
            self.rating = "great"
            self.button1.backgroundColor = defaultColor
            self.button2.backgroundColor = defaultColor
            self.button3.backgroundColor = selectedColor
        default:
            break
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        
        /*let leadingConstraint = NSLayoutConstraint(item: self.imageView, attribute: .leading, relatedBy: .equal, toItem: self.imageView.superview, attribute: .leading, multiplier: 1.0, constant: 0)
        leadingConstraint.isActive = true*/
        
        dismiss(animated: true, completion: nil)
    }
}
