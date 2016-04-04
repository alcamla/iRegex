//
//  SearchViewController.swift
//  iRegex
//
//  Created by James Frost on 11/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    struct Storyboard {
        struct Identifiers {
            static let SearchOptionsSegueIdentifier = "SearchOptionsSegue"
        }
    }
    
    var searchOptions: SearchOptions?
    
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func unwindToTextHighlightViewController(segue: UIStoryboardSegue) {
        if let searchOptionsViewController = segue.sourceViewController as? SearchOptionsViewController {
            if let options = searchOptionsViewController.searchOptions {
                performSearchWithOptions(options)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == Storyboard.Identifiers.SearchOptionsSegueIdentifier) {
            if let options = self.searchOptions {
                if let navigationController = segue.destinationViewController as? UINavigationController {
                    if let searchOptionsViewController = navigationController.topViewController as? SearchOptionsViewController {
                        searchOptionsViewController.searchOptions = options
                    }
                }
            }
        }
    }
    
    //MARK: Text highlighting, and Find and Replace

    func performSearchWithOptions(searchOptions: SearchOptions) {
        self.searchOptions = searchOptions
        
        if let replacementString = searchOptions.replacementString {
            searchForText(searchOptions.searchString, replaceWith: replacementString, inTextView: textView)
        } else {
            highlightText(searchOptions.searchString, inTextView: textView)
        }
    }
    
    func searchForText(searchText: String, replaceWith replacementText: String, inTextView textView: UITextView) {
        
        let beforeText = textView.text
        let range = NSMakeRange(0, beforeText.characters.count)
        
        if let regex = NSRegularExpression(options: self.searchOptions!) {
            let afterText = regex.stringByReplacingMatchesInString(beforeText, options: NSMatchingOptions(rawValue:0), range: range, withTemplate: replacementText)
            
            textView.text = afterText
        }
    }
    
    func highlightText(searchText: String, inTextView textView: UITextView) {
        // 1
        let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        // 2
        let attributedTextRange = NSMakeRange(0, attributedText.length)
        attributedText.removeAttribute(NSBackgroundColorAttributeName, range: attributedTextRange)
        // 3
        if let regex = NSRegularExpression(options: self.searchOptions!) {
            let range = NSMakeRange(0, textView.text.characters.count)
            let matches = regex.matchesInString(textView.text, options: NSMatchingOptions(rawValue:0), range: range)
            // 4
            for match in matches{
                
                let matchRange = match.range
                attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: matchRange)
            }
        }
        // 5
        textView.attributedText = attributedText.copy() as! NSAttributedString
    }
    
    func rangeForAllTextInTextView() -> NSRange {
        return NSMakeRange(0, textView.text.characters.count)
    }

    //MARK: Underline dates, times, and locations
    
    @IBAction func underlineInterestingData(sender: AnyObject) {
        underlineAllDates()
        underlineAllTimes()
        underlineAllLocations()
    }

    func underlineAllDates() {
        if let regex = NSRegularExpression.regularExpressionForDates() {
            let matches = matchesForRegularExpression(regex, inTextView: textView)
            highlightMatches(matches)
        }
    }
    
    func underlineAllTimes() {
        if let regex = NSRegularExpression.regularExpressionForTimes() {
            let matches = matchesForRegularExpression(regex, inTextView: textView)
            highlightMatches(matches)
        }
    }
    
    func underlineAllLocations() {
        if let regex = NSRegularExpression.regularExpressionForLocations() {
            let matches = matchesForRegularExpression(regex, inTextView: textView)
            highlightMatches(matches)
        }
    }
    

    
    func matchesForRegularExpression(regex: NSRegularExpression, inTextView textView: UITextView) -> [NSTextCheckingResult] {
        let string = textView.text
        let range = rangeForAllTextInTextView()
        
        //return regex.matchesInString(string, options: .allZeros, range: range) as [NSTextCheckingResult]
        return regex.matchesInString(string, options: NSMatchingOptions.WithTransparentBounds, range: range) as [NSTextCheckingResult]
    }
    
    func highlightMatches(matches: [NSTextCheckingResult]) {
        let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
        let attributedTextRange = NSMakeRange(0, attributedText.length)
        attributedText.removeAttribute(NSBackgroundColorAttributeName, range: attributedTextRange)
        
        for match in matches {
            let matchRange = match.range
            attributedText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: matchRange)
            attributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: matchRange)
        }
        
        textView.attributedText = attributedText.copy() as! NSAttributedString
    }
}
