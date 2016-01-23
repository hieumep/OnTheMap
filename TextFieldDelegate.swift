//
//  TextFieldDelegate.swift
//  On The Map
//
//  Created by Hieu Vo on 1/22/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class TextFieldDelegate : NSObject,UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
