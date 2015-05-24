//
//  SignUpStep5ViewController.swift
//  DopeAppSlaps
//
//  Created by Maximillian Parelius on 5/24/15.
//  Copyright (c) 2015 DopeAppSoftware. All rights reserved.
//

import UIKit

extension String {
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = map(digest) { String(format: "%02hhx", $0) }
        return "".join(hexBytes)
    }
}

class SignUpStep5ViewController: UIViewController {
    
    var email: String!
    var password: String!
    var did: String!
    var username: String!
    var phone: String!
    var token: String!

    @IBOutlet weak var emailConfirm: UILabel!
    @IBOutlet weak var usernameConfirm: UILabel!
    @IBOutlet weak var phoneConfirm: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailConfirm.text = "Email: \(email)"
        usernameConfirm.text = "Username: \(username)"
        phoneConfirm.text = "Phone Number: \(phone)"
        self.token = "\(username)\(password)"
        self.token = self.token.sha1()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okPressed(sender: AnyObject) {
        var post:NSString = "method=createAccount&token=\(token)&email=\(email)&username=\(username)&phone=\(phone)&deviceID=\(did)"
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
                NSLog("Success: %ld", success);
                if(success == 1) {
                    NSLog("Sign Up SUCCESS");
                    self.dismissViewControllerAnimated(true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
