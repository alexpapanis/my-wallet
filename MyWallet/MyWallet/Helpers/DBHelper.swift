//
//  DBHelper.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 13/07/18.
//  Copyright © 2018 Papanis. All rights reserved.
//

import Foundation
import CoreData

class DBHelper {
    func getCarteira() -> Carteira {
        var carteira: Carteira?
        let fetchRequest: NSFetchRequest<Carteira> = Carteira.fetchRequest()
        do {
            carteira = try PersistenceService.context.fetch(fetchRequest).first
        } catch {
            print("Erro ao pegar carteira no banco")
        }
        
        return carteira ?? Carteira()
    }
    
    func getTransacoes(_ tipoTransacao: TipoTransacao?) -> [Transacao] {
        var transacoes: [Transacao] = []
        
        let fetchRequest: NSFetchRequest<Transacao> = Transacao.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Transacao.data), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do{
            if tipoTransacao != nil {
                fetchRequest.predicate = NSPredicate(format: "tipo == %@", (tipoTransacao?.rawValue)!)
            }
            
            transacoes = try PersistenceService.context.fetch(fetchRequest)
        } catch {
            print("Error while fetching Atividades")
        }
        return transacoes
    }
}
