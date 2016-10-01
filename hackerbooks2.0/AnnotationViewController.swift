//
//  AnnotationViewController.swift
//  hackerbooks2.0
//
//  Created by fran on 30/9/16.
//  Copyright © 2016 Francisco Navarro Aguilar. All rights reserved.
//

import UIKit

class AnnotationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    var annotation : Annotation
    
    init(annotation : Annotation){
        self.annotation = annotation
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.automaticallyAdjustsScrollViewInsets = false;
        self.textView.delegate = self
        self.textView.text = annotation.text
        self.imageView.image = annotation.photo?.image
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = annotation.text?.components(separatedBy: " ").first
        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(){
        let picker =  UIImagePickerController()
        
        if UIImagePickerController.isCameraDeviceAvailable(.rear){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        
        picker.delegate = self
        self.present(picker, animated: true) { 
            
        }
    }
    
    @IBAction func deletePhoto(){
        self.annotation.photo = nil
        self.imageView.image = nil
    }
    
    func shareNote(){
        let pdfURL = self.annotation.pdf?.book?.pdfURL
        let text = self.annotation.text
        let image = self.annotation.photo?.image
        

        let activityController = UIActivityViewController(activityItems: [text,pdfURL,image], applicationActivities: nil)
        
        
        self.present(activityController, animated: true) { 
            
        }
        
    }
}


extension AnnotationViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.annotation.text = textView.text
    }
    
}

extension  AnnotationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.annotation.photo = Photo(image: image, context: self.annotation.managedObjectContext!)
        
        self.dismiss(animated: true) { 
            
        }
    }
    
}
