//
//  TextFieldClearPlaceHolderDelegate.swift
//  Image Picker
//
//  Created by ABDULRAHMAN ALRAHMA on 10/24/18.
//  Copyright © 2018 ABDULRAHMAN ALRAHMA. All rights reserved.
//

import Foundation
import UIKit

class TextFieldClearPlaceHolderDelegate: NSObject, UITextFieldDelegate {
    
    static var currentTextField: UITextField!
    
    let placeHolders: [String] = ["TOP", "BOTTOM"]
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        TextFieldClearPlaceHolderDelegate.currentTextField = textField

        for placeHolder in placeHolders {
            if textField.text == placeHolder {
                textField.text = ""
                return
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        TextFieldClearPlaceHolderDelegate.currentTextField = nil
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextFieldClearPlaceHolderDelegate.currentTextField.resignFirstResponder()
        return true
    }
    
}
