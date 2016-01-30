//
//  LoginViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/22/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import SystemConfiguration

class LoginViewController: UIViewController{

    var session : NSURLSession!
    let textFieldDelegate = TextFieldDelegate()
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    @IBOutlet weak var textUserName: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBOutlet weak var Loginwithfacebook: UIButton!
    
    @IBAction func signUpTouchUp(sender: AnyObject) {
        let checkNetwork = connectedToNetwork()
        if checkNetwork.network{
            let urlString = "https://www.udacity.com/account/auth#!/signup"
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: urlString)!)
        }else{
            displayError(checkNetwork.error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textUserName.delegate = textFieldDelegate
        textPassword.secureTextEntry = true
        textPassword.delegate = textFieldDelegate
        session = NSURLSession.sharedSession()
        loginWithAccessToken()
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer!.numberOfTapsRequired = 1
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardDismissRecognizer()
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardDismissRecognizer()
        unsubscribeToKeyboadNotifications()
    }
    
    @IBAction func loginTouchUp(sender: AnyObject) {
        var infoUser = [String:String]()
        if (self.textUserName.text!.isEmpty) || (self.textPassword.text!.isEmpty){
            let error = NSError(domain: "Text is Empty", code: 4, userInfo: [NSLocalizedDescriptionKey:"UserName/Password is empty"])
            displayError(error)
        }else{
            let checkNetwork = connectedToNetwork()
            if checkNetwork.network{
                infoUser[DBClient.JSONBody.Username] = textUserName.text
                infoUser[DBClient.JSONBody.Password] = textPassword.text
                DBClient.sharedInstance().authenticateWithViewController(self,infoUser : infoUser) { (success, error) in
                    if success {
                        self.completeLogin()
                    } else {
                        self.displayError(error)
                    }
                }
            }else{
                displayError(checkNetwork.error)
            }
        }
    }
    
    @IBAction func loginWithFacebookTouchUp(sender: AnyObject) {
        facebookLogin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func facebookLogin() {
        let checkNetwork = connectedToNetwork()
        if checkNetwork.network{
            let loginManager = FBSDKLoginManager()
            loginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self){(result, error) -> Void in
                if (error != nil) {
                    // Process error
                    self.displayError(error)
                } else if result.isCancelled {
                    // User Cancellation
                    self.removeFbData()
                } else {
                    //Success
                    self.loginWithAccessToken()
                }
            }
        }else{
            displayError(checkNetwork.error)
        }
    }
    
    func removeFbData() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
    func loginWithAccessToken(){
        if let accessToken = FBSDKAccessToken.currentAccessToken()?.tokenString {
            DBClient.sharedInstance().authenticateWithFacebook(self, accessToken: accessToken){(success, error) in
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(error)
                }
            }
        }
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
            self.presentViewController(controller, animated: true, completion: nil)
            
        })
    }
/*
    func completeLogin() {
        
            DBClient.sharedInstance().getListStudent(){(error) in
                if let error = error {
                    self.displayError(error)
                }else{
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarViewController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                }
            }
    }
*/
    func displayError(error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertVC = UIAlertController(title:"", message: error?.localizedDescription, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler : nil)
            alertVC.addAction(dismissAction)
            self.presentViewController(alertVC, animated: true, completion: nil)
        })
    }
    
    //check network connection
    func connectedToNetwork() -> (network:Bool,error : NSError?) {
        let error = NSError(domain: "Network connection", code: 6, userInfo: [NSLocalizedDescriptionKey:"No network connection"])
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return (false,error : error)
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return (false,error : error)
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        if (isReachable && !needsConnection) {
            return (network:true, error : nil)
        }else{
            return (false,error : error)
        }
    }
}

