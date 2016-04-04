//
//  SearchOptionsViewController.swift
//  iRegex
//
//  Created by James Frost on 12/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

struct SearchOptions {
    let searchString: String
    var replacementString: String?
    let matchCase: Bool
    let wholeWords: Bool
}

class SearchOptionsViewController: UITableViewController {
    
    var searchOptions: SearchOptions?
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var replacementTextField: UITextField!
    @IBOutlet weak var replaceTextSwitch: UISwitch!
    @IBOutlet weak var matchCaseSwitch: UISwitch!
    @IBOutlet weak var wholeWordsSwitch: UISwitch!
    
    struct Storyboard {
        struct Identifiers {
            static let UnwindSegueIdentifier = "UnwindSegue"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let options = searchOptions {
            searchTextField.text = options.searchString
            replacementTextField.text = options.replacementString
            replaceTextSwitch.on = (options.replacementString != nil)
            matchCaseSwitch.on = options.matchCase
            wholeWordsSwitch.on = options.wholeWords
        }
        
        searchTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        searchOptions = nil
        
        performSegueWithIdentifier(Storyboard.Identifiers.UnwindSegueIdentifier, sender: self)
    }
    
    @IBAction func searchTapped(sender: AnyObject) {
        searchOptions = SearchOptions(searchString: searchTextField.text!,
                                      replacementString: (replaceTextSwitch.on) ? replacementTextField.text : nil,
                                      matchCase: matchCaseSwitch.on,
                                      wholeWords: wholeWordsSwitch.on )
        
        performSegueWithIdentifier(Storyboard.Identifiers.UnwindSegueIdentifier, sender: self)
    }
    
    @IBAction func replaceTextSwitchToggled(sender: AnyObject) {
        replacementTextField.enabled = replaceTextSwitch.on
    }
}
