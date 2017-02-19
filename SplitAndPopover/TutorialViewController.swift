//
//  TutorialViewController.swift
//  SplitAndPopover
//
//  Created by Gabriel Theodoropoulos on 17/9/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var webview: UIWebView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var pubDateButtonItem: UIBarButtonItem!
    
    
    var tutorialURL : URL!
    
    var publishDate : String!
    
    var tutorialsButtonItem : UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        webview.isHidden = true
        toolbar.isHidden = true
        
        tutorialsButtonItem = UIBarButtonItem(title: "Tutorials", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TutorialViewController.showTutorialsViewController))
        
        NotificationCenter.default.addObserver(self, selector: #selector(TutorialViewController.handleFirstViewControllerDisplayModeChangeWithNotification(_:)), name: NSNotification.Name(rawValue: "PrimaryVCDisplayModeChangeNotification"), object: nil)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if tutorialURL != nil {
            let request : URLRequest = URLRequest(url: tutorialURL)
            webview.loadRequest(request)
            
            if webview.isHidden {
                webview.isHidden = false
                toolbar.isHidden = false
            }
            
            
            if self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact{
                toolbar.items?.insert(self.splitViewController!.displayModeButtonItem, at: 0)
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    
    
    func showTutorialsViewController(){
        splitViewController?.preferredDisplayMode = UISplitViewControllerDisplayMode.allVisible
    }
    
    
    func handleFirstViewControllerDisplayModeChangeWithNotification(_ notification: Notification){
        let displayModeObject = notification.object as? NSNumber
        let nextDisplayMode = displayModeObject?.intValue
        
        if toolbar.items?.count == 3{
            toolbar.items?.remove(at: 0)
        }
        
        if nextDisplayMode == UISplitViewControllerDisplayMode.PrimaryHidden.rawValue {
            toolbar.items?.insert(tutorialsButtonItem, at: 0)
        }
        else{
            toolbar.items?.insert(splitViewController!.displayModeButtonItem, at: 0)
        }
    }
 
    
     func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection) {
        if previousTraitCollection.verticalSizeClass == UIUserInterfaceSizeClass.compact{
            let firstItem = toolbar.items![0] as? UIBarButtonItem
            if firstItem?.title == "Tutorials"{
                toolbar.items?.remove(at: 0)
            }
        }
        else if previousTraitCollection.verticalSizeClass == UIUserInterfaceSizeClass.regular{
            if toolbar.items?.count == 3{
                toolbar.items?.remove(at: 0)
            }
            
            if splitViewController?.displayMode == UISplitViewControllerDisplayMode.primaryHidden {
                toolbar.items?.insert(tutorialsButtonItem, at: 0)
            }
            else{
                toolbar.items?.insert(self.splitViewController!.displayModeButtonItem, at: 0)
            }
        }
    }
    
    
    
    @IBAction func showPublishDate(_ sender: AnyObject) {
        let popoverViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idPopoverViewController") as? PopoverViewController
        
        popoverViewController?.modalPresentationStyle = UIModalPresentationStyle.popover
        
        popoverViewController?.popoverPresentationController?.delegate = self
        
        self.present(popoverViewController!, animated: true, completion: nil)
        
        popoverViewController?.popoverPresentationController?.barButtonItem = pubDateButtonItem
        popoverViewController?.popoverPresentationController?.permittedArrowDirections = .any
        popoverViewController?.preferredContentSize = CGSize(width: 200.0, height: 80.0)
        
        popoverViewController?.lblMessage.text = "Publish Date:\n\(publishDate)"
        
    }
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
