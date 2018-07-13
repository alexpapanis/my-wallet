//
//  TransacaoHelper.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 13/07/18.
//  Copyright © 2018 Papanis. All rights reserved.
//

import Foundation

class RespostaValidacao {
    var valido: Bool = false
    var mensagem: String?
    
    init(){
        
    }
    
    init(valido: Bool,mensagem: String?) {
        self.valido = valido
        self.mensagem = mensagem
    }
}

class TransacaoHelper {
    
    func validaVenda(quantidadeCarteira: Double, quantidade: Double) -> RespostaValidacao {
        
        let resposta = RespostaValidacao()
        
        if quantidadeCarteira < quantidade {
            resposta.mensagem = "Você não tem quantidades suficientes para esta transação. Quantidade disponível: \(quantidadeCarteira)"
            resposta.valido = false
            return resposta
            
        }
        return RespostaValidacao(valido: true, mensagem: nil)
    }
    
    func validaCompra(saldo: Double, quantidade: Double, valorCotacao: Double) -> RespostaValidacao{
        let resposta = RespostaValidacao()
        
        let totalTransacao = quantidade * valorCotacao
        if saldo < totalTransacao {
            resposta.mensagem = "Você não possui saldo suficiente para esta transação. Saldo disponível: \(saldo.converterMoeda)"
            resposta.valido = false
            return resposta
        }
        
        return RespostaValidacao(valido: true, mensagem: nil)
    }
    
}
