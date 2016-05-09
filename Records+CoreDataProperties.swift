//
//  Records+CoreDataProperties.swift
//  TipNTop
//
//  Created by Sadhana Maniarasu on 4/11/16.
//  Copyright © 2016 Sadhana Maniarasu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Records {

    @NSManaged var canteenCost: NSNumber?
     @NSManaged var otherCost: NSNumber?
    @NSManaged var addonDetail: String?
    @NSManaged var boardBill: NSNumber?
    @NSManaged var discount: String?
    @NSManaged var duration: String?
    @NSManaged var endTime: String?
    @NSManaged var name: String?
    @NSManaged var pausedTime: String?
    @NSManaged var phoneno: String?
    @NSManaged var startTime: String?
    @NSManaged var totalBill: NSNumber?
     @NSManaged var batchno: NSNumber?
    @NSManaged var tableno: NSNumber?
    
}
