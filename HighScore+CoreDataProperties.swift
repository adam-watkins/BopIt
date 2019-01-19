//
//  HighScore+CoreDataProperties.swift
//  BopIt
//
//  Created by Adam on 2018-03-14.
//  Copyright © 2018 Adam. All rights reserved.
//
//

import Foundation
import CoreData


extension HighScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HighScore> {
        return NSFetchRequest<HighScore>(entityName: "HighScore")
    }

    @NSManaged public var difficulty: String?
    @NSManaged public var score: Int16

}
