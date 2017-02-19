//
//  TopicsTableViewController.swift
//  SplitAndPopover
//
//  Created by Gabriel Theodoropoulos on 17/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

class TopicsTableViewController: UITableViewController, XMLParserDelegate {

    var xmlParser : XMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://feeds.feedburner.com/appcoda")
        xmlParser = XMLParser()
        xmlParser.delegate = self
        xmlParser.startParsingWithContentsOfURL(url!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: XMLParserDelegate method implementation
    
    func parsingWasFinished() {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlParser.arrParsedData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCell", for: indexPath) as UITableViewCell
        
        let currentDictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        
        cell.textLabel?.text = currentDictionary["title"]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionary = xmlParser.arrParsedData[indexPath.row] as Dictionary<String, String>
        let tutorialLink = dictionary["link"]
        let publishDate = dictionary["pubDate"]
        
        let tutorialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTutorialViewController" as TutorialViewController,
        
        tutorialViewController.tutorialURL = URL(string: tutorialLink!),
        tutorialViewController.publishDate = publishDate,
        
        showDetailViewController(tutorialViewController, sender: self),
        
        
    }
    
}
