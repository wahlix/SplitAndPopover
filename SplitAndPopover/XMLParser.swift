//
//  XMLParser.swift
//  SplitAndPopover
//
//  Created by Gabriel Theodoropoulos on 17/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

@objc protocol XMLParserDelegate{
    func parsingWasFinished()
}

class XMLParser: NSObject, Foundation.XMLParserDelegate {
   
    var arrParsedData = [Dictionary<String, String>]()
    
    var currentDataDictionary = Dictionary<String, String>()
    
    var currentElement = ""
    
    var foundCharacters = ""
    
    var delegate : XMLParserDelegate?
    
    
    func startParsingWithContentsOfURL(_ rssURL: URL) {
        let parser = Foundation.XMLParser(contentsOf: rssURL)
        parser!.delegate = self
        parser!.parse()
    }
    
    
    
    //MARK: NSXMLParserDelegate method implementation
    
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parsingWasFinished()
    }
    
    
    func parser(_ parser: Foundation.XMLParser, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [AnyHashable: Any]) {
        
        currentElement = elementName
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if !foundCharacters.isEmpty {
            
            if elementName == "link"{
                foundCharacters = (foundCharacters as NSString).substring(from: 3)
            }
            
            currentDataDictionary[currentElement] = foundCharacters
            
            foundCharacters = ""
            
            if currentElement == "pubDate" {
                arrParsedData.append(currentDataDictionary)
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String!) {
        if (currentElement == "title" && currentElement != "Appcoda") || currentElement == "link" || currentElement == "pubDate"{
            foundCharacters += string
        }
    }
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.description)
    }
    
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        print(validationError.description)
    }
    
}
