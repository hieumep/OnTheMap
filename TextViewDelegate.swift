//
//  TextViewDelegate.swift
//  On The Map
//
//  Created by Hieu Vo on 1/26/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class TextViewDelegate : NSObject, UITextViewDelegate{
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }else {
            return true
        }
    }
}
