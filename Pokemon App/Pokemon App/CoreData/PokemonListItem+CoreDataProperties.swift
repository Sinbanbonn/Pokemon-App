import Foundation
import CoreData

@objc(PokemonListItem)
public class PokemonListItem: NSManagedObject {}

extension PokemonListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PokemonListItem> {
        return NSFetchRequest<PokemonListItem>(entityName: "PokemonListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var picture: String?
    @NSManaged public var height: String?
    @NSManaged public var weight: String?
    @NSManaged public var type: String?

}

extension PokemonListItem: Identifiable {}
