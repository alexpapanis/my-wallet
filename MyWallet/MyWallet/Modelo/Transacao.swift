//
//  Transacao.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import Foundation

class TransacaoTotal: Decodable {
    var idUsuario: String?
    var imagemMoeda: String?
    var nomeMoeda: String?
    var tipoTransacao: String?
    var dataTransacao: Date?
    var capitalInvestido: Double?
    var cotacao: Double?
    var capitalAtual: Double?
    var porcentagemLucro: Double?
}
