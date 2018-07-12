//
//  Utils.swift
//  MyWallet
//
//  Created by Alexandre Papanis on 10/07/2018.
//  Copyright © 2018 Papanis. All rights reserved.
//

import Foundation

class Utils {
    
    static func formatarData(data: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let dataHoraFormatadaStr = dateFormatter.string(from: data)
        
        return dataHoraFormatadaStr
    }
    
    
}
