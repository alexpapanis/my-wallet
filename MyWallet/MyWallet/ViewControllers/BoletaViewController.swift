//
//  BoletaViewController.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 11/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit
import CoreData

enum TipoTransacao: String {
    case compra
    case venda
}

protocol BoletaDelegate {
    func atualizarValores(transacao: Transacao)
}

class BoletaViewController: UIViewController {
    
    //MARK: - Variaveis e constantes
    var cotacao: Cotacao!
    var moeda: String?
    var tipoTransacao: TipoTransacao?
    fileprivate var valorCotacao: Double?
    fileprivate var totalTransacao: Double?
    fileprivate var keyboardHeight: CGFloat = 0
    
    fileprivate let transacaoClassName:String = String(describing: Transacao.self)
    fileprivate var mensagemErroValidacao: String?
    
    var boletaDelegate: BoletaDelegate?
    
    
    //MARK: - IB Outlets
    
    @IBOutlet weak var lbTitulo: UILabel!
    @IBOutlet weak var vwBoleta: UIView!
    @IBOutlet weak var txQuantidade: UITextField!
    @IBOutlet weak var lbValorCotacao: UILabel!
    @IBOutlet weak var lbTotalTransacao: UILabel!
    @IBOutlet weak var btEfetivarTransacao: UIButton!
    @IBOutlet weak var vwBoletaCenterY: NSLayoutConstraint!
    
    //MARK: - IB Actions
    
    @IBAction func cancelar(_ sender: UIButton) {
        txQuantidade.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func efetivarTransacao(_ sender: UIButton) {
        
        let carteira = DBHelper().getCarteira()
        
        let validacao = validaTransacao(carteira)
        
        if  validacao.valido {
            let transacao = NSEntityDescription.insertNewObject(forEntityName: self.transacaoClassName, into: PersistenceService.context) as! Transacao
            
            transacao.codigoMoeda = cotacao.moeda!
            transacao.moeda = cotacao.moeda!
            transacao.cotacao = tipoTransacao?.rawValue == "compra" ? cotacao.cotacaoCompra! : cotacao.cotacaoVenda!
            transacao.data = NSDate.init()
            transacao.tipo = tipoTransacao?.rawValue
            transacao.quantidade = Double(txQuantidade.text ?? "0")!
            PersistenceService.saveContext()
            
            boletaDelegate?.atualizarValores(transacao: transacao)
            
            let alertController = UIAlertController(title: "Sucesso!", message: "Sua \(transacao.tipo!) foi realizada com sucesso.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Aviso!", message: validacao.mensagem, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        }
        
        
        
        
        
    }
    
    func validaTransacao(_ carteira: Carteira) -> RespostaValidacao{
        var resposta = RespostaValidacao()
        
        if tipoTransacao?.rawValue == "venda"{
            let quantidadeCarteira = moeda == "Bitcoin" ? carteira.qtdeBitcoin : carteira.qtdeBrita
            resposta = TransacaoHelper().validaVenda(quantidadeCarteira: quantidadeCarteira, quantidade: Double(txQuantidade.text! != "" ? txQuantidade.text! : "0")!)
        } else {
            resposta = TransacaoHelper().validaCompra(saldo: carteira.saldo, quantidade: Double(txQuantidade.text! != "" ? txQuantidade.text! : "0")!, valorCotacao: cotacao.cotacaoCompra!)
        }
        return resposta
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txQuantidade.becomeFirstResponder()
        
        if case tipoTransacao = TipoTransacao.compra {
            lbTitulo.text = "Digite a quantidade que deseja comprar:"
            valorCotacao = cotacao?.cotacaoCompra
            btEfetivarTransacao.setTitle("Comprar", for: .normal)
        } else {
            lbTitulo.text = "Digite a quantidade que deseja vender:"
            valorCotacao = cotacao?.cotacaoVenda
            btEfetivarTransacao.setTitle("Vender", for: .normal)
        }
        
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.init(identifier: "pt-br") // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        if let cotacaoFormatada = formatter.string(from: valorCotacao! as NSNumber) {
            lbValorCotacao.text = "\(cotacaoFormatada)"
        }
        
        
        totalTransacao = lbTotalTransacao.text == "" ? 0 : Double(lbTotalTransacao.text!)
        
        
        if let totalTransacaoFormatada = formatter.string(from: totalTransacao! as NSNumber) {
            lbTotalTransacao.text = "\(totalTransacaoFormatada)"
        }
        
        //lbValorCotacao.text = "\((valorCotacao)!)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShown), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }

    @objc func keyboardShown(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardHeight = keyboardFrame.size.height
        print("keyboardHeight: \(keyboardHeight)")
    }

}

extension BoletaViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.vwBoletaCenterY.constant = -self.keyboardHeight/2
            }, completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txQuantidade {
            
            if string != "" {
                let numero = Double(textField.text! + string) ?? 0
                totalTransacao = valorCotacao! * numero
                
            } else {
                let novoNumero = String((textField.text?.dropLast())!)
                let numero = Double(novoNumero) ?? 0
                totalTransacao = valorCotacao! * numero
            }
            
            lbTotalTransacao.text = totalTransacao?.converterMoeda

        }
        return true
    }
}
