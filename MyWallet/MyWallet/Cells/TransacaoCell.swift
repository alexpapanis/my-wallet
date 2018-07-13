//
//  TransacaoCell.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit
import SDWebImage

class TransacaoCell: UITableViewCell {

    let service = Service()
    
    @IBOutlet weak var imgMoeda: UIImageView!
    @IBOutlet weak var lbTransacao: UILabel!
    @IBOutlet weak var lbDataTransacao: UILabel!
    
    @IBOutlet weak var lbQuantidade: UILabel!
    @IBOutlet weak var lbCotacao: UILabel!
    @IBOutlet weak var lbCapitalInvestido: UILabel!
    @IBOutlet weak var lbCapitalAtual: UILabel!
    @IBOutlet weak var lbPorcentagemLucro: UILabel!
    
    var transacao: Transacao! {
        didSet {
            
            if transacao.moeda == "Bitcoin" {
                service.getCotacaoBitcoin(completion: {cotacao in
                    
                    var cotacaoUsada = 0.0
                    
                    //se transacao é de compra, a cotacao utilizada é a de venda
                    if self.transacao.tipo == TipoTransacao.compra.rawValue {
                        cotacaoUsada = cotacao.cotacaoVenda!
                    } else {
                        cotacaoUsada = cotacao.cotacaoCompra!
                    }
                    
                    self.lbCapitalAtual.text = "\((Double(self.transacao.quantidade) * cotacaoUsada).converterMoeda)"
                    
                    let porcentagem = (self.transacao.cotacao - cotacaoUsada)/(self.transacao.cotacao)
                    self.lbPorcentagemLucro.text = "\(porcentagem.converterPorcentagem)"
                    self.lbPorcentagemLucro.textColor = porcentagem >= 0.0 ? .blue : .red
                })
            } else {
                service.getCotacaoBrita(completion: {cotacao in
                    
                    var cotacaoUsada = 0.0
                    
                    //se transacao é de compra, a cotacao utilizada é a de venda
                    if self.transacao.tipo == TipoTransacao.compra.rawValue {
                        cotacaoUsada = cotacao.cotacaoVenda!
                    } else {
                        cotacaoUsada = cotacao.cotacaoCompra!
                    }
                    
                    self.lbCapitalAtual.text = "\((Double(self.transacao.quantidade) * cotacaoUsada).converterMoeda)"
                    
                    let porcentagem = (self.transacao.cotacao - cotacaoUsada)/(self.transacao.cotacao)
                    self.lbPorcentagemLucro.text = "\(porcentagem.converterPorcentagem)"
                    self.lbPorcentagemLucro.textColor = porcentagem >= 0.0 ? .blue : .red
                })
            }
            
            self.imgMoeda.image = UIImage(named: transacao.moeda == "Bitcoin" ? "bitcoin" : "dollar")
            self.lbTransacao.text = "\(transacao.moeda!) - \(transacao.tipo!)"
            self.lbQuantidade.text = "\(transacao.quantidade)"
            self.lbCotacao.text = "\(transacao.cotacao.converterMoeda)"
            self.lbDataTransacao.text = Utils.formatarData(data: transacao.data! as Date)
            self.lbCapitalInvestido.text = "\((Double(transacao.quantidade) * transacao.cotacao).converterMoeda)"
            
        }
    }

}
