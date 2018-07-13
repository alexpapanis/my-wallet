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
    
    var transacao: Transacao! {
        didSet {
            
            self.imgMoeda.image = UIImage(named: transacao.moeda == "Bitcoin" ? "bitcoin" : "dollar")
            self.lbTransacao.text = "\(transacao.moeda!) - \(transacao.tipo!)"
            self.lbQuantidade.text = "\(transacao.quantidade)"
            self.lbCotacao.text = "\(transacao.cotacao.converterMoeda)"
            self.lbDataTransacao.text = Utils.formatarData(data: transacao.data! as Date)
            self.lbCapitalInvestido.text = "\((Double(transacao.quantidade) * transacao.cotacao).converterMoeda)"
            
        }
    }

}
