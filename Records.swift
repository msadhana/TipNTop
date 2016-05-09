//
//  Records.swift
//  TipNTop
//
//  Created by Sadhana Maniarasu on 4/11/16.
//  Copyright © 2016 Sadhana Maniarasu. All rights reserved.
//

import Foundation
import CoreData

@objc(Records)
class Records: NSManagedObject {

  
    
    func csv() -> String {
        
        let name_t = name ?? ""
        let phoneno_t = phoneno ?? ""
        let startTime_t = startTime ?? ""
        let endTime_t = endTime ?? ""
        let duration_t = duration ?? ""
        let pausedtime_t = pausedTime ?? ""
      
        
        var boardCost_t:String
        if let boardcost = boardBill?.floatValue {
            boardCost_t = String(boardcost)
        } else {
            boardCost_t = ""
        }
        
        var canteenCost_t:String
        if let canteencost = canteenCost?.floatValue {
            canteenCost_t = String(canteencost)
        } else {
            canteenCost_t = ""
        }
        
        var otherCost_t:String
        if let othercost = otherCost?.floatValue {
            otherCost_t = String(othercost)
        } else {
            otherCost_t = ""
        }
        
        var totalCost_t:String
        if let totalcost = totalBill?.floatValue {
            totalCost_t = String(totalcost)
        } else {
            totalCost_t = ""
        }
        
        let discount_t = discount ?? ""

        let addondetail_t = addonDetail ?? ""
        
        var batchno_t:String
        if let batchNo = batchno?.integerValue {
            batchno_t = String(batchNo)
        } else {
            batchno_t = ""
        }
        
        var tableno_t:String
        if let tableNo = tableno?.integerValue {
            tableno_t = String(tableNo)
        } else {
            tableno_t = ""
        }
        
        return "\(batchno_t),\(tableno_t),\(name_t),\(phoneno_t),\(startTime_t),\(endTime_t),\(duration_t),\(pausedtime_t)," +
            "\(boardCost_t),\(canteenCost_t),\(otherCost_t),\(totalCost_t),\(discount_t),\(addondetail_t)\n"
    }
}
