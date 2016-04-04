//
//  RegexHelpers.swift
//  iRegex
//
//  Created by camacholaverde on 4/4/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    convenience init?(options: SearchOptions) {
        let searchString = options.searchString
        let isCaseSensitive = options.matchCase
        let isWholeWords = options.wholeWords
        
        let pattern = (isWholeWords) ? "\\b\(searchString)\\b" : searchString
        
        do{
            let option:NSRegularExpressionOptions = isCaseSensitive ? NSRegularExpressionOptions(rawValue: 0): .CaseInsensitive
            try self.init(pattern:pattern, options: option)
            
        }
        catch{
            return nil
        }
    }
    
    class func regularExpressionForDates() -> NSRegularExpression? {
        let pattern = "(\\d{1,2}[-/.]\\d{1,2}[-/.]\\d{1,2})|(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|Jun(e)?|Jul(y)?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)\\s*(\\d{1,2}(st|nd|rd|th)?+)?[,]\\s*\\d{4}"
        do{
            return try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            
        } catch{
            return nil
        }
    }
    
    class func regularExpressionForTimes() -> NSRegularExpression? {
        // Times
        //let pattern = "\\d{1,2}\\s*(pm|am)"
        let pattern = "(1[0-2]|0?[1-9]):([0-5][0-9]\\s?(am|pm))"
        do{
            return try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            
        } catch{
            return nil
        }
    }
    
    class func regularExpressionForLocations() -> NSRegularExpression? {
        // Locations
        let pattern = "[a-zA-Z]+[,]\\s*([A-Z]{2})"
        do{
            return try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue:0))
            
        } catch{
            return nil
        }
    }
    
    class func regularExpressionForEmails() -> NSRegularExpression? {
        // email adress
        let pattern = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        do{
            return try NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            
        } catch{
            return nil
        }
    }
}
