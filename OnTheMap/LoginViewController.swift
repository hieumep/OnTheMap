//
//  LoginViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/22/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{

    var session : NSURLSession!
    let textFieldDelegate = TextFieldDelegate()
    
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var Loginwithfacebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textUserName.delegate = textFieldDelegate
        textPassword.delegate = textFieldDelegate
        session = NSURLSession.sharedSession()
        loginWithAccessToken()
    }
    
    @IBAction func loginTouchUp(sender: AnyObject) {
        var infoUser = [String:String]()
        
        infoUser[DBClient.JSONBody.Username] = textUserName.text
        infoUser[DBClient.JSONBody.Password] = textPassword.text
        
        DBClient.sharedInstance().authenticateWithViewController(self,infoUser : infoUser) { (success, errorString) in
            if success {
                
                self.completeLogin()
            } else {
                self.displayError(errorString)
            }
            print("\(errorString)")
        }
    }
    
    @IBAction func loginWithFacebookTouchUp(sender: AnyObject) {
        fbLoginInitiate()
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
            print("success")
        })
    }
    

    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
              print(errorString)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fbLoginInitiate() {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self){(result, error) -> Void in
            if (error != nil) {
                // Process error
                self.removeFbData()
            } else if result.isCancelled {
                // User Cancellation
                self.removeFbData()
            } else {
                //Success
                self.loginWithAccessToken()
            }
        }
    }
    
    func removeFbData() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
    func loginWithAccessToken(){
        if let accessToken = FBSDKAccessToken.currentAccessToken().tokenString {
            DBClient.sharedInstance().authenticateWithFacebook(self, accessToken: accessToken){(success, errorString) in
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
            }
        }
    }
}

