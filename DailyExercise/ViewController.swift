//
//  ViewController.swift
//  DailyExercise
//
//  Created by Changhyun Lee on 6/21/16.
//  Copyright © 2016 Changhyun Lee. All rights reserved.
//

//import OAuthSwift

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif


class ViewController: UIViewController {
    
    
    // MARK: Properties
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: UIButton) {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("Login", sender: self)
    }
    
    @IBAction func logout(sender: UIButton) {
        self.performSegueWithIdentifier("Login", sender: self)
    }
    
    func doOAuthFitbit(serviceParameters: [String:String]){
        let oauthswift = OAuth1Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            requestTokenUrl: "https://api.fitbit.com/oauth/request_token",
            authorizeUrl:    "https://www.fitbit.com/oauth/authorize?display=touch",
            accessTokenUrl:  "https://api.fitbit.com/oauth/access_token"
        )
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/fitbit")!, success: {
            credential, response, parameters in
            self.showTokenAlert(serviceParameters["name"], credential: credential)
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    
    func doOAuthFitbit2(serviceParameters: [String:String]) {
        let oauthswift = OAuth2Swift(
            consumerKey:    serviceParameters["consumerKey"]!,
            consumerSecret: serviceParameters["consumerSecret"]!,
            authorizeUrl:   "https://www.fitbit.com/oauth2/authorize",
            accessTokenUrl: "https://api.fitbit.com/oauth2/token",
            responseType:   "code"
        )
        oauthswift.accessTokenBasicAuthentification = true
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/fitbit2")!, scope: "profile weight", state: state, success: {
            credential, response, parameters in
            self.showTokenAlert(serviceParameters["name"], credential: credential)
            self.testFitbit2(oauthswift)
            }, failure: { error in
                print(error.localizedDescription)
        })
    }
    
    


}

