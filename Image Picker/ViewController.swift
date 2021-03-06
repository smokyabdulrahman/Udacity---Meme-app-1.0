//
//  ViewController.swift
//  Image Picker
//
//  Created by ABDULRAHMAN ALRAHMA on 10/23/18.
//  Copyright © 2018 ABDULRAHMAN ALRAHMA. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    var isMemeReadyToBeShared: Bool = false
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var currentImg: UIImage!
    
    let textFieldCPDelegat = TextFieldClearPlaceHolderDelegate()
    
    // MARK: life cycle and init/reinit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initApp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    
    func initApp() {
        view.backgroundColor = UIColor.darkGray
        
        imageView.contentMode = .scaleAspectFit
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
        imageView.image = nil
        currentImg = nil
        
        initTextFields()
    }
    
    func initTextFields() {
        topTextField.delegate = textFieldCPDelegat
        bottomTextField.delegate = textFieldCPDelegat
        
        let textFieldsAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 32)!,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -4,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        topTextField.defaultTextAttributes = textFieldsAttributes
        bottomTextField.defaultTextAttributes = textFieldsAttributes
        
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: ImagePickerController logic
    
    func openImagePickerWith(source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = source
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func openCamera() {
        openImagePickerWith(source: .camera)
    }
    
    @IBAction func openPhotoLibrary() {
        openImagePickerWith(source: .photoLibrary)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        currentImg = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        isMemeReadyToBeShared = true
        imageView.image = currentImg
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: hiding keyboard && pushing view so keyboard doesn't hide bottomTextField logic
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo;
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let textField = TextFieldClearPlaceHolderDelegate.currentTextField {
            let keybrHeight = getKeyboardHeight(notification)
            if textField.frame.minY > keybrHeight {
                view.frame.origin.y = -keybrHeight
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.frame.origin.y = 0
    }
    
    // MARK: Subscribing to keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Meme generation and saving logic
    
    func generateMeme() -> UIImage {
        shouldHideUI(true)
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        shouldHideUI(false)
        return memedImage
    }
    
    func shouldHideUI(_ shouldHide: Bool) {
        toolBar.isHidden = shouldHide
        navBar.isHidden = shouldHide
    }
    
    @IBAction func share() {
        let activityViewController = UIActivityViewController(activityItems: [generateMeme()], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                // User completed activity
                self.saveMeme()
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    func saveMeme() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImg: currentImg, memeImg: generateMeme())
        
        // save meme in shared instance
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func addMemeCreatorPresenterButton() {
        let rightBarItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openMemeVC))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc func openMemeVC() {
        let memeVC = storyboard?.instantiateViewController(withIdentifier: "MemeViewController") as! ViewController
        present(memeVC, animated: true, completion: nil)
    }
}

