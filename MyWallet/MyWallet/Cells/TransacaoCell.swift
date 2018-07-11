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

    @IBOutlet weak var imgMoeda: UIImageView!
    @IBOutlet weak var lbTransacao: UILabel!
    @IBOutlet weak var lbDataTransacao: UILabel!
    
    @IBOutlet weak var lbCapitalInvestido: UILabel!
    @IBOutlet weak var lbCotacao: UILabel!
    @IBOutlet weak var lbCapitalAtual: UILabel!
    @IBOutlet weak var lbPorcentagemLucro: UILabel!
    
    var transacaoViewModel: TransacaoViewModel! {
        didSet {
            self.imgMoeda.sd_setImage(with: URL(string: transacaoViewModel.imagemMoeda!), completed: nil)
            self.lbTransacao.text = "\(transacaoViewModel.nomeMoeda!) - \(transacaoViewModel.tipoTransacao!)"
            self.lbDataTransacao.text = Utils.formatarData(data: transacaoViewModel.dataTransacao!)
            self.lbCapitalInvestido.text = "\(transacaoViewModel.capitalInvestido!)"
            self.lbCapitalAtual.text = "\(transacaoViewModel.capitalAtual!)"
            let porcentagem = (transacaoViewModel.capitalAtual! - transacaoViewModel.capitalInvestido!)/(transacaoViewModel.capitalInvestido!)
            self.lbPorcentagemLucro.text = "\(porcentagem)%"
            
        }
    }

}
