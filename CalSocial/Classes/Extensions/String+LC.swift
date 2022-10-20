//
//  String+LC.swift
//  Labour Choice
//
//  Created by Usama on 19/06/2017.
//  Copyright © 2017 Usama. All rights reserved.
//

import UIKit
import Foundation

extension String
{

    func fromBase64() -> String
    {
        let data = Data(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        return String(data: data!, encoding: String.Encoding.utf8)!
    }

    func toBase64() -> String
    {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }

    func isValidEmail() -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        let result =  emailPredicate.evaluate(with: self)
        return result
    }
    
    func getFirstChar() -> String {
        if self != "" {
            let index = self.index(self.startIndex, offsetBy: 1)
            return String(self.prefix(upTo: index)).lowercased()
        }
        return ""
    }
    
    func isValidPassword() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")

        if rangeOfCharacter(from: characterset.inverted) != nil && count >= 8 {
            return true

        } else {
            return false
        }
    }
    
    static func timeStringFromUnixTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime/1000)
        
        // Returns date formatted as 12 hour time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, hh:mma"
        return dateFormatter.string(from: date)
    }
    
    func timeStringFromUnix(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        
        // Returns date formatted as 12 hour time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    static func timeDetailStringFromUnixTime(unixTime: Double) -> String {
        let date = Date(timeIntervalSince1970: unixTime/1000)
        
        // Returns date formatted as 12 hour time.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        return dateFormatter.string(from: date)
    }
    
//    static func makeTextUnderLineAndCenter(preText: String, underLineText: String, postText: String) -> NSAttributedString {
//
//        let style = NSMutableParagraphStyle()
//        style.alignment = NSTextAlignment.center
//
//        let underlineAttrs = [NSAttributedString.Key.font : UIFont.appThemeFontWithSize(16.0) as AnyObject, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue as AnyObject, NSAttributedString.Key.paragraphStyle: style as AnyObject]
//        let attributedString = NSMutableAttributedString(string:underLineText, attributes:underlineAttrs as [String:AnyObject])
//
//        let lightAttr = [NSFontAttributeName : UIFont.appThemeFontWithSize(16.0) as AnyObject, NSParagraphStyleAttributeName: style as AnyObject]
//        let finalAttributedText = NSMutableAttributedString(string:preText, attributes:lightAttr as [String:AnyObject])
//
//        let postText = NSMutableAttributedString(string:postText, attributes:lightAttr as [String:AnyObject])
//
//        finalAttributedText.append(attributedString)
//        finalAttributedText.append(postText)
//
//        return finalAttributedText
//    }

    static func makeTextBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {

        let boldAttrs = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.appThemeBoldFontWithSize(fontSzie)]
        let attributedString = NSAttributedString(string:boldText, attributes:boldAttrs)

        let lightAttr = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.appThemeFontWithSize(fontSzie)]
        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr)

        let postText = NSAttributedString(string:postBoldText, attributes:lightAttr)

        finalAttributedText.append(attributedString)
        finalAttributedText.append(postText)

        return finalAttributedText
    }
//
//    static func makeTextSemiBold(_ preBoldText:String, boldText:String, postBoldText:String, fontSzie:CGFloat) -> NSAttributedString {
//
//        let boldAttrs = [NSFontAttributeName : UIFont.appThemeSemiBoldFontWithSize(fontSzie) as AnyObject]
//        let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs as [String:AnyObject])
//
//        let lightAttr = [NSFontAttributeName : UIFont.appThemeFontWithSize(fontSzie) as AnyObject]
//        let finalAttributedText = NSMutableAttributedString(string:preBoldText, attributes:lightAttr as [String:AnyObject])
//
//        let postText = NSMutableAttributedString(string:postBoldText, attributes:lightAttr as [String:AnyObject])
//
//        finalAttributedText.append(attributedString)
//        finalAttributedText.append(postText)
//
//        return finalAttributedText
//    }
//
//    func safelyLimitedTo(length n: Int)->String {
//        let c = self.characters
//        if (c.count <= n) { return self }
//        return String( Array(c).prefix(upTo: n) )
//    }

    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
            }.joined().dropFirst())
    }
    
    func validateIFSC(code : String) -> Bool {
      let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{4}0.{6}$")
      return regex.numberOfMatches(in: code, range: NSRange(code.startIndex..., in: code)) == 1
    }
    
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    func safelyLimitedFrom(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n))
    }
    
    func getChatTitle(attributes: [String:Any]) -> String {
        
        var id = 0
        if Utility.isKeyPresentInUserDefaults(key: kUserId) {
            if let userid  = UserDefaults.standard.object(forKey: kUserId) as? Int {
                id = userid
            }
        }

        var channelName = ""
         if let members = attributes["members"] as? [[String:Any]] {
            for (index,member) in members.enumerated() {
                if let userId = member["id"] as? Int {
                    if id != userId {
                        if index == 0 || members.count == 2 {
                            channelName = (member["name"] as? String) ?? "No Name"
                        
                        } else if index == (members.count - 1) {
                            channelName = channelName + " & " + (member["name"] as? String)!
                            
                        } else {
                            if channelName == "" {
                                channelName = (member["name"] as? String)!
                            
                            } else {
                                channelName = channelName + ", " + (member["name"] as? String)!
                            }
                            
                        }
                    }
                }
            }
        }
        return channelName
    }
}
