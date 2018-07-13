//
//  Transacao+CoreDataProperties.swift
//  
//
//  Created by Alexandre Papanis on 12/07/2018.
//
//

import Foundation
import CoreData


extension Transacao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transacao> {
        return NSFetchRequest<Transacao>(entityName: "Transacao")
    }

    @NSManaged public var codigoMoeda: String?
    @NSManaged public var cotacao: Double
    @NSManaged public var data: NSDate?
    @NSManaged public var id: Int16
    @NSManaged public var moeda: String?
    @NSManaged public var quantidade: Double
    @NSManaged public var tipo: String?

}
