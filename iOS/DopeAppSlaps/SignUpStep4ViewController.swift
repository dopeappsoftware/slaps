//
//  SignUpStep4ViewController.swift
//  DopeAppSlaps
//
//  Created by Maximillian Parelius on 5/24/15.
//  Copyright (c) 2015 DopeAppSoftware. All rights reserved.
//

import UIKit

class SignUpStep4ViewController: UIViewController {

    var email: String!
    var password: String!
    var did: String!
    var username: String!
    var phone: String!
    var confirm: Int!
    
    @IBOutlet weak var txtCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        var code:NSString = txtCode.text as NSString
        if (code.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Invalid Code"
            alertView.message = "Please enter a confirmation code"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if (!code.isEqualToString(String(confirm))) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Invalid Code"
            alertView.message = "Incorrect confirmation code"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            self.performSegueWithIdentifier("stepFive", sender: self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stepFive" {
            if let destVC = segue.destinationViewController as? SignUpStep5ViewController {
                destVC.did = self.did
                destVC.email = self.email
                destVC.password = self.password
                destVC.username = self.username
                destVC.phone = self.phone
            }
        }
    }
}
