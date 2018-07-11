//
//  WalletViewController.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 09/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class WalletViewController: UIViewController {

    let service = Service()
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbDisponivel: UILabel!
    @IBOutlet weak var lbLucro: UILabel!
    @IBOutlet weak var lbCapital: UILabel!
    
    @IBAction func fazerLogout(_ sender: UIBarButtonItem) {
        let facebookLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        
        facebookLoginManager.logOut()
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func verTransacoes(_ sender: UIButton) {
        performSegue(withIdentifier: "showTransacoes", sender: nil)
    }
    
    
    var cotacoesDoDia = [Cotacao]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        
        if FBSDKAccessToken.currentAccessTokenIsActive() {
            print(FBSDKAccessToken.current().appID)
            defaults.set(FBSDKAccessToken.current().appID, forKey: "idUsuario")
        }
        
        fetchData()
        
    }

    fileprivate func fetchData(){
        service.fetchCotacaoMoedaDia(completion: {cotacoesDoDia in
            if cotacoesDoDia.count == 0 {
                print("Erro!")
                return
            }
            self.cotacoesDoDia = cotacoesDoDia
            
            self.tableView.reloadData()
        })
        
    }
    
}

extension WalletViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cotacoesDoDia.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cotacaoCell") as? CotacaoCell {
            
            cell.cotacao = cotacoesDoDia[indexPath.row]
            cell.tag = indexPath.row
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")
        
        return cell
    }
}


