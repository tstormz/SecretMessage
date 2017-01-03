//
//  ViewController.swift
//  SecretMessage
//
//  Created by Travis Hafner on 1/2/17.
//  Copyright © 2017 Travis Hafner. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        messageField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        messageField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may return mutliple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected photo
        photoImageView.image = selectedImage
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        messageField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        // Only allow images to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func encrypt(_ sender: AnyObject) {
        let imgData: Data? = UIImageJPEGRepresentation(photoImageView.image!, 1.0)
        guard let imgBytes = imgData else {
            return
        }
        let nBytes = imgBytes.count
        //let msg = messageField.text ?? ""
        //let msgBytes = [UInt8](msg.utf8)
        let newImgData = NSMutableData(capacity: nBytes)
        if let theData = newImgData {
            //let array: [UInt8] = [UInt8](imgBytes)
            var iterator = imgBytes.makeIterator()
            while var byte = iterator.next() {
                let myData = NSData(bytes: &byte, length: 1)
                theData.append(myData as Data)
            }
            //let data = NSData(bytes: array, length: array.count)
            //theData.setData(data as Data)
            let newImage = UIImage(data: theData as Data)
            UIImageWriteToSavedPhotosAlbum(newImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func createBitArray(from byte: UInt8) -> [Bool] {
        let bitMask: UInt8 = 1
        var bits = [Bool]()
        for index: UInt8 in 0...7 {
            let bit = (byte >> index) & bitMask == 1 ? true : false
            bits.insert(bit, at: Int(index))
        }
        return bits
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    


}

