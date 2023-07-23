import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init(){}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ModelStore")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load CoreData store: \(error)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    
    func savePokemonListItems(_ items: [Pokemon]) {
        for item in items {
            let newItem = PokemonItem(context: context)
            newItem.name = item.name
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Failed to save Core Data context: \(error)")
        }
    }
    
    func fetchPokemonListItems() -> [PokemonItem] {
        let fetchRequest: NSFetchRequest<PokemonItem> = PokemonItem.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func addPokemonToCoreData(pokemon: PokemonDetail) {
        let newPokemon = PokemonItem(context: context)
        newPokemon.name = pokemon.name
        newPokemon.height = Int64(pokemon.height)
        newPokemon.weight = Int64(pokemon.weight)
        newPokemon.type = pokemon.types.map { $0.type.name }.joined(separator: ", ")
        newPokemon.imageURL = pokemon.sprites.other.officialArtwork.frontDefault
        do {
            try self.context.save()
        } catch {
            fatalError("Failed to save Core Data context: \(error)")
        }
    }
    
    func updatePokemonListItem(_ item: PokemonItem, newName: String) {
        item.name = newName
        do {
            try context.save()
        } catch {
            fatalError("Failed to save Core Data context: \(error)")
        }
    }
    
    func clearСoreData() {
        DispatchQueue.main.async {
            let entities = self.fetchPokemonListItems()
            for entity in entities {
                self.context.delete(entity)
            }
            
            do {
                try self.context.save()
            } catch {
                print("Failed to clear CoreData: \(error)")
            }
        }
    }
    
}
