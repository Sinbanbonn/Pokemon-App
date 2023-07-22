//
//  PokemonItem+CoreDataProperties.swift
//  
//
//  Created by Андрей Логвинов on 7/22/23.
//
//

import Foundation
import CoreData


extension PokemonItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonItem> {
        return NSFetchRequest<PokemonItem>(entityName: "PokemonItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var weight: Int64
    @NSManaged public var height: Int64
    @NSManaged public var type: String?
    @NSManaged public var image: UIImage?
    @NSManaged public var imageURL: String?

}
