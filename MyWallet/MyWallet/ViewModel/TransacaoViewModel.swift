//
//  TransacaoViewModel.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import Foundation

struct TransacaoViewModel {
 
    var imagemMoeda: String?
    var nomeMoeda: String?
    var tipoTransacao: String?
    var dataTransacao: Date?
    var capitalInvestido: Double?
    var cotacao: Double?
    var capitalAtual: Double?
    var porcentagemLucro: Double?
    
    init(transacao: Transacao){
        self.imagemMoeda = transacao.imagemMoeda
        self.nomeMoeda = transacao.nomeMoeda
        self.tipoTransacao = transacao.tipoTransacao
        self.dataTransacao = transacao.dataTransacao
        self.capitalInvestido = transacao.capitalInvestido
        self.cotacao = transacao.cotacao
        self.capitalAtual = transacao.capitalAtual
        self.porcentagemLucro = transacao.porcentagemLucro
    }
    
}
