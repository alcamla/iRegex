import UIKit

func highlightMatches(pattern: String, inString string: String) -> NSAttributedString? {
    do{
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue:0))
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: NSMatchingOptions(rawValue:0), range: range) as [NSTextCheckingResult]
        
        let attributedText = NSMutableAttributedString(string: string)
        
        for match in matches {
            attributedText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: match.range)
        }
        
        return attributedText.copy() as? NSAttributedString
    } catch{
        print("unable to create regex")
    }
    return nil

}

func listMatches(pattern: String, inString string: String) -> [String]? {
    do{
        let regex  = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0))
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: NSMatchingOptions(rawValue:0), range: range) as [NSTextCheckingResult]
        
        return matches.map {
            let range = $0.range
            return (string as NSString).substringWithRange(range)
        }
    }catch{
        print("unable to create regex")
    }
    return nil
}

func listGroups(pattern: String, inString string: String) -> [String]? {
    do{
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue: 0))
        let range = NSMakeRange(0, string.characters.count)
        let matches = regex.matchesInString(string, options: NSMatchingOptions(rawValue:0), range: range) as [NSTextCheckingResult]
        
        var groupMatches = [String]()
        for match in matches {
            let rangeCount = match.numberOfRanges
            
            for group in 0..<rangeCount {
                groupMatches.append((string as NSString).substringWithRange(match.rangeAtIndex(group)))
            }
        }
        
        return groupMatches
        
    }catch{
        
    }
    return nil
}

func containsMatch(pattern: String, inString string: String) -> Bool? {
    do{
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue:0))
        let range = NSMakeRange(0, string.characters.count)
        return regex.firstMatchInString(string, options: NSMatchingOptions(rawValue:0), range: range) != nil
        
    } catch{
         print("unable to create regex")        
    }
    return nil

}

func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
    do{
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions(rawValue:0))
        let range = NSMakeRange(0, string.characters.count)
        
        return regex.stringByReplacingMatchesInString(string, options: NSMatchingOptions(rawValue:0), range: range, withTemplate: replacementString)
    } catch{
         print("unable to create regex")
    }
    return nil

}
