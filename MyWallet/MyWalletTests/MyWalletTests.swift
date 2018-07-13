//
//  MyWalletTests.swift
//  MyWalletTests
//
//  Created by Alexandre Papanis on 09/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import XCTest
@testable import MyWallet

class MyWalletTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testValidaTransacaoVendaFalha(){
        
        let qtdeCarteira = 0.0
        let qtdeAVender = 50.0
        
        let helper = TransacaoHelper()
        let resposta = helper.validaVenda(quantidadeCarteira: qtdeCarteira, quantidade: qtdeAVender)
        
        XCTAssertEqual(resposta.valido, false, "Não possui quantidade disponível para venda")
        
    }
    
    func testValidaTransacaoVendaSucesso(){
        
        let qtdeCarteira = 10.0
        let qtdeAVender = 5.0
        
        let helper = TransacaoHelper()
        let resposta = helper.validaVenda(quantidadeCarteira: qtdeCarteira, quantidade: qtdeAVender)
        
        XCTAssertEqual(resposta.valido, true, "Venda realizada com sucesso")
        
    }
    
    func testValidaTransacaoCompraFalha(){
        
        let qtdeAComprar = 10.0
        let valorCotacao = 5000.0
        let saldoCarteira = 40000.0
        
        let helper = TransacaoHelper()
        let resposta = helper.validaCompra(saldo: saldoCarteira, quantidade: qtdeAComprar, valorCotacao: valorCotacao)
        
        XCTAssertEqual(resposta.valido, false, "Não tem saldo suficiente para efetivar transacao")
        
    }
    
    func testValidaTransacaoCompraSucesso(){
        
        let qtdeAComprar = 1.0
        let valorCotacao = 5000.0
        let saldoCarteira = 40000.0
        
        let helper = TransacaoHelper()
        let resposta = helper.validaCompra(saldo: saldoCarteira, quantidade: qtdeAComprar, valorCotacao: valorCotacao)
        
        XCTAssertEqual(resposta.valido, true, "Compra realizada com sucesso")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
