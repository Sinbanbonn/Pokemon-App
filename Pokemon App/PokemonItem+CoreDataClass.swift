import Foundation
import CoreData

@objc(PokemonItem)
public class PokemonItem: NSManagedObject {}

extension PokemonItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonItem> {
        return NSFetchRequest<PokemonItem>(entityName: "PokemonItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var weight: Int64
    @NSManaged public var height: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var type: String?


}

extension PokemonItem : Identifiable {}
