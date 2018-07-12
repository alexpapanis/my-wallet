//
//  TransacaoViewController.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import UIKit
import CoreData

class TransacaoViewController: UIViewController {

    var tipoTransacao: TipoTransacao?
    var transacoes: [Transacao] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buscarTransacoes()
        
        self.navigationController?.navigationBar.tintColor = .white
        
    }

    
    func buscarTransacoes() {
        
        
        let fetchRequest: NSFetchRequest<Transacao> = Transacao.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Transacao.data), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do{
            if tipoTransacao != nil {
                fetchRequest.predicate = NSPredicate(format: "tipo == %@", (tipoTransacao?.rawValue)!)
            }
            
            transacoes = try PersistenceService.context.fetch(fetchRequest)
            print(transacoes.count)
            tableView.reloadData()
            
        } catch {
            print("Error while fetching Atividades")
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TransacaoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transacoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "transacaoCell") as? TransacaoCell {
            
            cell.transacao = transacoes[indexPath.row]
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")
        
        return cell
    }
}
