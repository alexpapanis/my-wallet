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

protocol CellDelegate {
    func callComprarSegue(cotacao: Cotacao)
    func callVenderSegue(cotacao: Cotacao)
}

class WalletViewController: UIViewController, CellDelegate {

    let service = Service()
    let defaults = UserDefaults.standard
    
    var tipoTransacao: TipoTransacao?
    
    var totalDisponivel: Double = 0
    var lucro: Double = 0
    var capital: Double = 0
    
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
        
        lbDisponivel.text = totalDisponivel.converterMoeda
        lbLucro.text = lucro.converterMoeda
        lbCapital.text = capital.converterMoeda
        
        buscarCotacoes()
        
    }

    fileprivate func buscarCotacoes(){
        service.fetchCotacaoMoedaDia(completion: {cotacoesDoDia in
            if cotacoesDoDia.count == 0 {
                print("Erro!")
                return
            }
            self.cotacoesDoDia = cotacoesDoDia
            
            self.tableView.reloadData()
        })
        
    }
    
    func callVenderSegue(cotacao: Cotacao){
        tipoTransacao = TipoTransacao.venda
        self.performSegue(withIdentifier: "showBoleta", sender: cotacao)
    }
    
    func callComprarSegue(cotacao: Cotacao){
        tipoTransacao = TipoTransacao.compra
        self.performSegue(withIdentifier: "showBoleta", sender: cotacao)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBoleta"{
            if let vc = segue.destination as? BoletaViewController {
                if let cotacao = sender as? Cotacao {
                    vc.cotacao = cotacao
                    vc.tipoTransacao = tipoTransacao
                }
            }
        }
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
            
            cell.delegate = self
            
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


