//
//  Service.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class Service {
    
    func fetchCotacaoMoedaDia(completion: @escaping (_ cotacao: [Cotacao]) ->Void){
        var cotacoesDoDia: [Cotacao] = []
        
        let hoje = Date.init().yesterday
        
        let df = DateFormatter()
        df.dateFormat = "MM-dd-YYYY"
        let dataHoje = df.string(from: hoje)
        
        let urlBrita = URL(string: "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?%40moeda=%27USD%27&%40dataCotacao=%27\(dataHoje)%27&%24format=json")!
        
        Alamofire.request(urlBrita).responseJSON { response in

            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("getCotacaoBrita sucesso")
                    if let result = response.result.value {
                        
                        let json = JSON(result)
                        print(json)
                        
                        do {
                            if let cotacoes = json["value"].array {
                                if (cotacoes.count > 0){
                                    let cotacao = cotacoes[cotacoes.count-1]
                                    let data = try cotacao.rawData()
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .iso8601
                                    let c = try decoder.decode(Cotacao.self, from: data)
                                    c.moeda = Defines.BRITA
                                    cotacoesDoDia.append(c)
                                }
                            }

                        } catch {
                            completion([])
                            print("Erro")
                        }
                        
                        let urlBitcoin = URL(string: "https://www.mercadobitcoin.net/api/BTC/ticker/")!
                        Alamofire.request(urlBitcoin).responseJSON { response in
                            if let status = response.response?.statusCode {
                                switch(status){
                                case 200:
                                    print("getCotacaoBitcoin sucesso")
                                    if let result = response.result.value {
                                        
                                        let json = JSON(result)
                                        print(json)
                                        
                                        if let ticker = json["ticker"].dictionary {
                                            let cotacaoBitcoin = Cotacao()
                                            cotacaoBitcoin.cotacaoCompra = ticker["buy"]?.doubleValue
                                            cotacaoBitcoin.cotacaoVenda = ticker["sell"]?.doubleValue
                                            cotacaoBitcoin.moeda = Defines.BITCOIN
                                            cotacoesDoDia.append(cotacaoBitcoin)
                                        }
                                        completion(cotacoesDoDia)
                                            
                                   }
                                    
                                default:
                                    completion([])
                                    print("error with response status: \(status)")
                                }
                            }
                        }
                        
                    }
                default:
                    completion([])
                    print("error with response status: \(status)")
                }
            }

        }
        
    }
    
    func getCotacaoBrita(completion: @escaping (_ cotacao: Cotacao) ->Void){
        var cotacaoBrita: Cotacao = Cotacao()
        
        let hoje = Date.init().yesterday
        
        let df = DateFormatter()
        df.dateFormat = "MM-dd-YYYY"
        let dataHoje = df.string(from: hoje)
        
        let urlBrita = URL(string: "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?%40moeda=%27USD%27&%40dataCotacao=%27\(dataHoje)%27&%24format=json")!
        
        Alamofire.request(urlBrita).responseJSON { response in
            
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("getCotacaoBrita sucesso")
                    if let result = response.result.value {
                        
                        let json = JSON(result)
                        print(json)
                        
                        do {
                            if let cotacoes = json["value"].array {
                                if (cotacoes.count > 0){
                                    let cotacao = cotacoes[cotacoes.count-1]
                                    let data = try cotacao.rawData()
                                    
                                    let decoder = JSONDecoder()
                                    decoder.dateDecodingStrategy = .iso8601
                                    cotacaoBrita = try decoder.decode(Cotacao.self, from: data)
                                    cotacaoBrita.moeda = Defines.BRITA
                                }
                            }
                            completion(cotacaoBrita)
                        } catch {
                            completion(cotacaoBrita)
                            print("Erro")
                        }
                        
                        
                        
                    }
                default:
                    completion(cotacaoBrita)
                    print("error with response status: \(status)")
                }
            }
            
        }
        
    }
    
    func getCotacaoBitcoin(completion: @escaping (_ cotacao: Cotacao) ->Void){
        let cotacaoBitcoin: Cotacao = Cotacao()
        
        let urlBitcoin = URL(string: "https://www.mercadobitcoin.net/api/BTC/ticker/")!
        Alamofire.request(urlBitcoin).responseJSON { response in
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("getCotacaoBitcoin sucesso")
                    if let result = response.result.value {
                        
                        let json = JSON(result)
                        print(json)
                        
                        if let ticker = json["ticker"].dictionary {
                            cotacaoBitcoin.cotacaoCompra = ticker["buy"]?.doubleValue
                            cotacaoBitcoin.cotacaoVenda = ticker["sell"]?.doubleValue
                            cotacaoBitcoin.moeda = Defines.BITCOIN
                        }
                        completion(cotacaoBitcoin)
                        
                    }
                    
                default:
                    completion(Cotacao())
                    print("error with response status: \(status)")
                }
            }
        }
        
    }
    
    
}
