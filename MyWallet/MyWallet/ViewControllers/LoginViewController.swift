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
    
    @IBOutlet weak var btLoginFB: FBSDKLoginButton!
    
    var delegate: CellDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        btLoginFB.readPermissions = ["public_profile", "email"]
        btLoginFB.delegate = self
        
        DispatchQueue.main.async {
            if FBSDKAccessToken.currentAccessTokenIsActive() {
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }
        }
        
        
    }

}

extension LoginViewController {
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        if let token = result.token {
            print("Logou. " + token.appID)
            
            performSegue(withIdentifier: "showHome", sender: nil)
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Deslogou")
    }
}
