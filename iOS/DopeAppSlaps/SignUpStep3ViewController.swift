//
//  SignUpStep3ViewController.swift
//  DopeAppSlaps
//
//  Created by Maximillian Parelius on 5/24/15.
//  Copyright (c) 2015 DopeAppSoftware. All rights reserved.
//

import UIKit

class SignUpStep3ViewController: UIViewController {

    var email: String!
    var password: String!
    var did: String!
    var username: String!
    var code: Int!

    @IBOutlet weak var txtPhone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        var phoneNum:NSString = txtPhone.text as NSString
        if (phoneNum.isEqualToString("")) {
            var alertView:UIAlertView = UIAlertView()
            alertView.title = "Invalid Phone Number"
            alertView.message = "Please enter a phone number"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            var post:NSString = "method=validatePhone&phone=\(phoneNum)"
            NSLog("PostData: %@",post);
            var url:NSURL = NSURL(string: "http://52.24.127.193/slaps_repo/server/rpc.php")!
            var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
            var postLength:NSString = String(postData.length)
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = postData
            request.setValue(postLength, forHTTPHeaderField: "Content-Length")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            var reponseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            if (urlData != nil) {
                let res = response as NSHTTPURLResponse!;
                NSLog("Response code: %ld", res.statusCode);
                if (res.statusCode >= 200 && res.statusCode < 300) {
                    var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                    NSLog("Response ==> %@", responseData);
                    var error: NSError?
                    let jsonData:JSON = JSON(data: urlData!)
                    let success:NSInteger = jsonData["success"].intValue
                    self.code = jsonData["code"].intValue
                    NSLog("Success: %ld", success);
                    if(success == 1) {
                        NSLog("Sign Up SUCCESS");
                        self.performSegueWithIdentifier("stepFour", sender: self)
                    } else {
                        var error_msg:NSString
                        if let err = jsonData["errorMessage"].string {
                            error_msg = err
                        } else {
                            error_msg = "Unknown Error"
                        }
                        var alertView:UIAlertView = UIAlertView()
                        alertView.title = "Sign Up Failed!"
                        alertView.message = error_msg
                        alertView.delegate = self
                        alertView.addButtonWithTitle("OK")
                        alertView.show()
                    }
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            } else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign Up Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
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
        if segue.identifier == "stepFour" {
            if let destVC = segue.destinationViewController as? SignUpStep4ViewController {
                destVC.did = self.did
                destVC.email = self.email
                destVC.password = self.password
                destVC.username = self.username
                destVC.phone = self.txtPhone.text
                destVC.confirm = self.code
            }
        }
    }
}
