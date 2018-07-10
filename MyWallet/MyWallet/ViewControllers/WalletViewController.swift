//
//  WalletViewController.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 09/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class WalletViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if FBSDKAccessToken.currentAccessTokenIsActive() {
            print(FBSDKAccessToken.current().appID)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
