//
//  WalletViewController.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 09/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit
import CoreData

protocol CellDelegate {
    func callComprarSegue(cotacao: Cotacao)
    func callVenderSegue(cotacao: Cotacao)
}

class WalletViewController: UIViewController, CellDelegate, BoletaDelegate {

    let service = Service()
    let defaults = UserDefaults.standard
    let carteiraClassName:String = String(describing: Carteira.self)
    
    var boletaDelegate: BoletaDelegate!
    var tipoTransacao: TipoTransacao?
    var carteira: Carteira?
    
    var totalDisponivel: Double = 0
    var lucro: Double = 0
    var capital: Double = 0
    
    
    var cotacaoBrita: Double = 0
    var qtdeBrita: Double = 0
    var totalBrita: Double = 0
    var cotacaoBitcoin: Double = 0
    var qtdeBitcoin: Double = 0
    var totalBitcoin: Double = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbQtdeBitcoin: UILabel!
    @IBOutlet weak var lbTotalBitcoin: UILabel!
    @IBOutlet weak var lbQtdeBrita: UILabel!
    @IBOutlet weak var lbTotalBrita: UILabel!
    
    
    @IBOutlet weak var lbDisponivel: UILabel!
    @IBOutlet weak var lbLucro: UILabel!
    @IBOutlet weak var lbCapital: UILabel!
    
    @IBAction func verTransacoes(_ sender: UIButton) {
        performSegue(withIdentifier: "showTransacoes", sender: nil)
    }
    
    
    var cotacoesDoDia = [Cotacao]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boletaDelegate = self

        if !defaults.bool(forKey: "configurado") {
            
            let carteira = NSEntityDescription.insertNewObject(forEntityName: self.carteiraClassName, into: PersistenceService.context) as! Carteira
            
            carteira.saldo = 100000
            carteira.qtdeBitcoin = 0
            carteira.qtdeBrita = 0
//            carteira.totalInvestido = 0
            PersistenceService.saveContext()
            
            defaults.set(true, forKey: "configurado")
        }
        
        buscarCotacoes()
        
        let fetchRequest: NSFetchRequest<Carteira> = Carteira.fetchRequest()
        do {
            carteira = try PersistenceService.context.fetch(fetchRequest).first
        } catch {
            print("Erro ao pegar carteira no banco")
        }
        
        self.totalDisponivel = carteira?.saldo ?? 0.0
        self.qtdeBitcoin = (carteira?.qtdeBitcoin)!
        self.qtdeBrita = (carteira?.qtdeBrita)!
        
        lbDisponivel.text = "\(self.totalDisponivel.converterMoeda)"
        lbLucro.text = lucro.converterMoeda
        lbCapital.text = capital.converterMoeda
        
        
        
    }

    fileprivate func buscarCotacoes(){
        service.fetchCotacaoMoedaDia(completion: {cotacoesDoDia in
            if cotacoesDoDia.count == 0 {
                print("Erro!")
                return
            }
            self.cotacoesDoDia = cotacoesDoDia
            
            self.qtdeBrita = self.carteira?.qtdeBrita ?? 0
            self.qtdeBitcoin = self.carteira?.qtdeBitcoin ?? 0
            
            for cotacao in cotacoesDoDia {
                if cotacao.moeda == "Bitcoin" {
                    if let valor = cotacao.cotacaoVenda {
                        self.cotacaoBitcoin = valor
                        self.totalBitcoin = self.qtdeBitcoin * valor
                    }
                } else {
                    if let valor = cotacao.cotacaoVenda {
                        self.cotacaoBrita = valor
                        self.totalBrita = self.qtdeBrita * valor
                    }
                }
            }
            
            self.lbQtdeBitcoin.text = "\(self.qtdeBitcoin)"
            self.lbTotalBitcoin.text = "\(self.totalBitcoin.converterMoeda)"
            self.lbQtdeBrita.text = "\(self.qtdeBrita)"
            self.lbTotalBrita.text = "\(self.totalBrita.converterMoeda)"
            
            self.lbLucro.text = "\(((self.totalDisponivel + self.totalBrita + self.totalBitcoin) - 100000.0).converterMoeda)"
            self.lbCapital.text = "\((self.totalDisponivel + self.totalBrita + self.totalBitcoin).converterMoeda)"
            
            self.tableView.reloadData()
            self.tableView.tableFooterView = UIView(frame: .zero)
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
    
    func atualizarValores(transacao: Transacao) {
        
        let carteira = DBHelper().getCarteira()
        
        if transacao.tipo == TipoTransacao.compra.rawValue {
            if transacao.moeda == "Bitcoin" {
                carteira.qtdeBitcoin += transacao.quantidade
            } else {
                carteira.qtdeBrita += transacao.quantidade
            }
            carteira.saldo -= (transacao.quantidade*transacao.cotacao)
        } else {
           
            if transacao.moeda == "Bitcoin" {
                carteira.qtdeBitcoin -= transacao.quantidade
            } else {
                carteira.qtdeBrita -= transacao.quantidade
            }
            carteira.saldo += (transacao.quantidade*transacao.cotacao)
        }
        PersistenceService.saveContext()
        
        self.lbQtdeBitcoin.text = "\(carteira.qtdeBitcoin)"
        self.lbTotalBitcoin.text = "\((carteira.qtdeBitcoin * cotacaoBitcoin).converterMoeda)"
        self.lbQtdeBrita.text = "\(carteira.qtdeBrita)"
        self.lbTotalBrita.text = "\((carteira.qtdeBrita * cotacaoBrita).converterMoeda)"
        
        self.lbDisponivel.text = "\(carteira.saldo.converterMoeda)"
        self.lbLucro.text = "\(((self.totalDisponivel + (self.qtdeBrita*self.cotacaoBrita) + (self.qtdeBitcoin*self.cotacaoBitcoin)) - 100000.0).converterMoeda)"
        self.lbCapital.text = "\((self.totalDisponivel + (self.qtdeBrita*self.cotacaoBrita) + (self.qtdeBitcoin*self.cotacaoBitcoin)).converterMoeda)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBoleta"{
            if let vc = segue.destination as? BoletaViewController {
                if let cotacao = sender as? Cotacao {
                    vc.cotacao = cotacao
                    vc.tipoTransacao = tipoTransacao
                    vc.boletaDelegate = self
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


