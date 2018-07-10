//
//  LoginViewController.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Logou. " + result.token.appID)
        
        performSegue(withIdentifier: "showHome", sender: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Deslogou")
    }
    

    @IBOutlet weak var btLoginFB: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btLoginFB.readPermissions = ["public_profile", "email"]
        btLoginFB.delegate = self
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
