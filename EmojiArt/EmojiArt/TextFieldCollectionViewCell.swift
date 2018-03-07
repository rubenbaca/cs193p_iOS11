//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by Ruben on 3/6/18.
//  Copyright © 2018 Ruben. All rights reserved.
//
import UIKit

///
/// CollectionViewCell with an input textField.
///
class TextFieldCollectionViewCell: UICollectionViewCell, UITextFieldDelegate {
    
    ///
    /// This is called inside `textFieldDidEndEditing`.
    ///
    /// You may set this to do custom things when the text field ends editing.
    ///
    var resignationHandler: (()->Void)?
    
    ///
    /// The textField used to get input from the user
    ///
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    ///
    /// Text field ended editing
    ///
    func textFieldDidEndEditing(_ textField: UITextField) {
        // If user provided a resignationHandler, call it
        resignationHandler?()
    }
    
    ///
    /// Text field should return
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
