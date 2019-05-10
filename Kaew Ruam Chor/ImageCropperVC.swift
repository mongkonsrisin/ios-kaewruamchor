//
//  ImageCropperVC.swift
//  Kaew Ruam Chor
//
//  Created by Mongkon Srisin on 8/8/17.
//  Copyright © 2017 SSRU. All rights reserved.
//

import UIKit
import Alamofire

class ImageCropperVC: UIViewController,
    UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    let defaultValues = UserDefaults.standard
    let http = Http()
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    

    
    
    
    
    @IBAction func chooseImageToUpload(_ sender: UITapGestureRecognizer) {
        
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheetController.modalPresentationStyle = .popover
      
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title: "ถ่ายภาพ", style: .default) { action -> Void in
            
            
            self.picker.allowsEditing = true
            self.picker.sourceType = UIImagePickerControllerSourceType.camera
            self.picker.cameraCaptureMode = .photo
            self.picker.modalPresentationStyle = .fullScreen
            self.present( self.picker,animated: true,completion: nil)
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: "เลือกภาพจากแกลอรี่", style: .default) { action -> Void in
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .fullScreen
          
            self.present( self.picker, animated: true, completion: nil)
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        

        actionSheetController.popoverPresentationController?.sourceRect = imageView.bounds
        actionSheetController.popoverPresentationController?.sourceView = self.view
        // present an actionSheet...
        present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
      
        saveBtn.isEnabled = false
        imageView.isUserInteractionEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
   
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        var  chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage //2
        imageView.contentMode = .scaleAspectFit //3
        imageView.image = chosenImage //4
        
        
        saveBtn.isEnabled = true
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadProfile(_ sender: UIBarButtonItem) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        customActivityIndicatory(self.view, startAnimate: true)
        
        let imgData = UIImageJPEGRepresentation(imageView.image!, 0.2)!
        let stu_id = defaultValues.string(forKey: "stu_id")
        
        let parameters = ["id": stu_id!]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "image",fileName: "\(stu_id!).jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:http.getBaseUrl() + "upload.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                })
                
                upload.responseJSON { response in
                    //Response
                }
                CheckPhoto.sharedInstance.photo = "haveimage"

                UIApplication.shared.endIgnoringInteractionEvents()
                customActivityIndicatory(self.view, startAnimate: false)
                NotifyDataChange.sharedInstance.shouldReloadPhoto = true
                _ = self.navigationController?.popViewController(animated: true)
                
                
            case .failure(let encodingError):
                print(encodingError)
                //Stop animation and allow touch
                UIApplication.shared.endIgnoringInteractionEvents()
                customActivityIndicatory(self.view, startAnimate: false)
            }
        }
        
    }
    
    
}
