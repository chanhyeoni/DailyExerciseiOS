//
//  LoginVC.swift
//  DailyExercise
//
//  Created by Changhyun Lee on 6/30/16.
//  Copyright © 2016 Changhyun Lee. All rights reserved.
//

import UIKit
import OAuthSwift

class LoginVC: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        

    @IBAction func login(sender: UIButton) {
        let usernameInput:String = username.text! as String
        let passwordInput:String = password.text! as String
        
        if (usernameInput == "" || passwordInput == ""){

            // if the username or password is empty string, do something
        }else{
            // do the oauth process
            
            let serviceParameters:[String:String] = [
                "client_id" : "229HDN",
                "client_secret" : "351b65c4dd3d4b9586a51c8603ecba26",
                "scope" : "activity heartrate location nutrition profile settings sleep social weight",
                "name" : "DailyExercise",
                "redirectURL" : "oauth-swift://oauth-callback/fitbit2",
                "baseURL" : "https://api.fitbit.com"
            ]
            
            self.GetFitbitAPIContext(serviceParameters)
        }
        
    }
    
    
    func GetFitbitAPIContext(serviceParameters: [String:String]){
        
        var oauthswift:OAuth2Swift
        
        
        oauthswift = OAuth2Swift(
            consumerKey : serviceParameters["client_id"]!,
            consumerSecret : serviceParameters["client_secret"]!,
            authorizeUrl: "https://www.fitbit.com/oauth2/authorize",
            responseType: "code"
        )
        
        oauthswift.accessTokenBasicAuthentification = true
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL(
            NSURL(string: serviceParameters["redirectURL"]!)!,
            scope: serviceParameters["scope"]!,
            state: state,
            success: {
                credential, response, parameters in
                print ("it is success!!!!")
                print (credential.oauth_token)
                self.showTokenAlert(serviceParameters["name"], credential: credential)
                self.testFitbit2(oauthswift)
            },
            failure: {
                error in
                print(error.localizedDescription)
            }
        )
        
        oauthswift.authorize_url_handler = SafariURLHandler(viewController : self)
    }
    
    func showTokenAlert(name: String?, credential: OAuthSwiftCredential) {
        var message = "oauth_token:\(credential.oauth_token)"
        if !credential.oauth_token_secret.isEmpty {
            message += "\n\noauth_token_secret:\(credential.oauth_token_secret)"
        }
        self.showAlertView(name ?? "Service", message: message)
        
        let services = Services()
        
        if let service = name {
            services.updateService(service, dico: ["authentified":"1"])
            // TODO refresh graphic
        }
    }
    
    func showAlertView(title: String, message: String) {
        #if os(iOS)
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        #elseif os(OSX)
            let alert = NSAlert()
            alert.messageText = title
            alert.informativeText = message
            alert.addButtonWithTitle("Close")
            alert.runModal()
        #endif
    }
    
    func testFitbit2(oauthswiftobj: OAuth2Swift) {
        oauthswiftobj.client.get("https://api.fitbit.com/1/user/-/profile.json", parameters: [:],
            success: {
                data, response in
                let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                print(jsonDict)
            }, failure: { error in
                print(error.localizedDescription)
            }
        )
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
