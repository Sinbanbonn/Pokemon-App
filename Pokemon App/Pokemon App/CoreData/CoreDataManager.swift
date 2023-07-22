import CoreData
import UIKit
import SDWebImage

//переименовать контейнер
class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalDB")
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
    
    // MARK: - should return a mistake in allert
    
    func fetchPokemonListItems() -> [PokemonItem] {
        let fetchRequest: NSFetchRequest<PokemonItem> = PokemonItem.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch PokemonListItems: \(error)")
            return []
        }
    }
    

    func addPokemonToCoreData(pokemon: PokemonPreview) {
        let newPokemon = PokemonItem(context: context)
        newPokemon.name = pokemon.name
        newPokemon.height = Int64(pokemon.height)
        newPokemon.weight = Int64(pokemon.weight)
        newPokemon.type = pokemon.types.map { $0.type.name }.joined(separator: ", ")
        newPokemon.imageURL = "https://example.com/default_image.png"
        if let imageURL = URL(string: pokemon.sprites.other.officialArtwork.frontDefault) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                guard let data = data, error == nil else {
                    return
                }
                newPokemon.image = UIImage(data: data)
                do {
                    try self.context.save()
                } catch {
                    fatalError("Failed to save Core Data context: \(error)")
                }
            }
            
        }
        
        else {
            print("Invalid imageURL")
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
    
    
    func clearoreData() {
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
