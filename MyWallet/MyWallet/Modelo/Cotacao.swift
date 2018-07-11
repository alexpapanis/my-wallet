//
//  Cotacao.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import Foundation

class Cotacao: Decodable {
    
    var moeda: String?
    var paridadeCompra: Int?
    var paridadeVenda: Int?
    var cotacaoCompra: Double?
    var cotacaoVenda: Double?
    var dataHoraCotacao: String?
    var tipoBoletim: String?
    
}

