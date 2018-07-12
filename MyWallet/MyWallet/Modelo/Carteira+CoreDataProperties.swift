//
//  Carteira+CoreDataProperties.swift
//  
//
//  Created by Alexandre Papanis on 12/07/18.
//
//

import Foundation
import CoreData


extension Carteira {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Carteira> {
        return NSFetchRequest<Carteira>(entityName: "Carteira")
    }

    @NSManaged public var saldo: Double
    @NSManaged public var totalInvestido: Double

}
