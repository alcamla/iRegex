//
//  SignUpViewController.swift
//  iRegex
//
//  Created by James Frost on 13/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var middleInitialField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    
    var textFields: [UITextField]!
    var regexes: [NSRegularExpression?]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [ firstNameField, middleInitialField, lastNameField, dateOfBirthField ]
        
        let patterns = [ "^[a-z]{1,10}$",      // First name
            "^[a-z]$",            // Middle Initial
            "^[a-z']{2,10}$",     // Last Name
            "^(0[1-9]|1[012])[-/.](0[1-9]|[12][0-9]|3[01])[-/.](19|20)\\d\\d$" ]  // Date of Birth
        
        regexes = patterns.map {
            do{
               let regex = try  NSRegularExpression(pattern: $0, options: .CaseInsensitive)
                return regex
            } catch{
                return nil
            }
        }
    }
    func validateTextField(textField: UITextField) {
        let index = textFields.indexOf(textField)
        if let regex = regexes[index!] {
            let text = textField.text!.stringByTrimmingLeadingAndTrailingWhitespace()
            let range = NSMakeRange(0, text.characters.count)
            
            let matchRange = regex.rangeOfFirstMatchInString(text, options: .ReportProgress, range: range)
            
            let valid = matchRange.location != NSNotFound
            
            textField.textColor = (valid) ? UIColor.trueColor() : UIColor.falseColor()
        }
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        for textField in textFields {
            validateTextField(textField)
            textField.resignFirstResponder()
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.textColor = UIColor.blackColor()
        doneButton.enabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        validateTextField(textField)
        doneButton.enabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        validateTextField(textField)
        
        makeNextTextFieldFirstResponder(textField)
        
        return true
    }
    
    func makeNextTextFieldFirstResponder(textField: UITextField) {
        textField.resignFirstResponder()

        if var index = textFields.indexOf(textField) {
            index += 1
            if index < textFields.count {
                textFields[index].becomeFirstResponder()
            }
        }
    }
}

extension UIColor {
    class func trueColor() -> UIColor {
        return UIColor(red: 0.1882, green:0.6784, blue:0.3882, alpha:1.0)
    }
    
    class func falseColor() -> UIColor {
        return UIColor(red:0.7451, green:0.2275, blue:0.1922, alpha:1.0)
    }
}

extension String {
    func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
        let leadingAndTrailingWhitespacePattern = "(?:^\\s+)|(?:\\s+$)"
        
        
        do{
            let regex = try NSRegularExpression(pattern: leadingAndTrailingWhitespacePattern, options: .CaseInsensitive)
            let range = NSMakeRange(0, self.characters.count)
            let trimmedString = regex.stringByReplacingMatchesInString(self, options: .ReportProgress, range: range, withTemplate: "$1")
            return trimmedString
        }catch{
            print ("invalid regex")
        }
        return self
    }
}

