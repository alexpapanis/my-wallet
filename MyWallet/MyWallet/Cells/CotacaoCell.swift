//
//  CotacaoCell.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit

class CotacaoCell: UITableViewCell {
    
    var delegate: CellDelegate!

    @IBOutlet weak var vwContentView: UIView!
    @IBOutlet weak var imgMoeda: UIImageView!
    @IBOutlet weak var lbNomeMoeda: UILabel!
    @IBOutlet weak var lbCotacaoVenda: UILabel!
    @IBOutlet weak var lbCotacaoCompra: UILabel!
    
    var cotacao: Cotacao! {
        didSet {
            if cotacao.moeda == Defines.BRITA {
                lbNomeMoeda.text = "Brita"
                imgMoeda.image = UIImage(named: "dollar")
            } else {
                lbNomeMoeda.text = "Bitcoin"
                imgMoeda.image = UIImage(named: "bitcoin")
            }
            
            lbCotacaoVenda.text = "\(cotacao.cotacaoVenda!)"
            lbCotacaoCompra.text = "\(cotacao.cotacaoCompra!)"
        }
    }
    
    @IBAction func venderMoeda(_ sender: UIButton) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callVenderSegue(cotacao: cotacao)
        }
        
//
//
//        var transacao = Transacao()
//        transacao.cotacao = cotacao.cotacaoCompra
//        transacao.dataTransacao = Date.init()
//        transacao.nomeMoeda = cotacao.moeda
//        transacao.tipoTransacao = "Compra"
//        transacao.idUsuario = UserDefaults.standard.string(forKey: "idUsuario")
        
    }
    
    @IBAction func comprarMoeda(_ sender: UIButton) {
        if(self.delegate != nil){ //Just to be safe.
            self.delegate.callComprarSegue(cotacao: cotacao)
        }
    }
    

}
