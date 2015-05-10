//
//  ViewController.swift
//  DopeAppSlaps
//
//  Created by student1 on 5/9/15.
//  Copyright (c) 2015 DopeAppSoftware. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //refreshData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as NSString
        }
    }
    

    @IBAction func logoutTapped(sender: AnyObject) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
    
    func jsonDataDidLoad(data: NSData!) {
        let json = JSON(data: data)
        
        println("\(json)")
        
    }
    
    func refreshData() {
        if let url = NSURL(string: "http://52.24.127.193/test.json") {
            let urlRequest = NSURLRequest(URL: url);
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler:
                {(resp: NSURLResponse!, data: NSData!, error: NSError!) -> Void
                    in
                    self.jsonDataDidLoad(data)
            })
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

