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
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        
        if (isLoggedIn != 1){
            self.performSegueWithIdentifier("Login", sender: self)
        }else{
            self.username.text = prefs.valueForKey("USERNAME") as? String
        }
    }
    
    @IBAction func logout(sender: UIButton) {
        self.performSegueWithIdentifier("Login", sender: self)
    }

}

