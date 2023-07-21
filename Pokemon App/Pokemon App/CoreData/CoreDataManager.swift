import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    private var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    

    func savePokemonListItems(_ items: [Pokemon]) {
        for item in items {
            let newItem = PokemonListItem(context: context)
            newItem.name = item.name
        }
        
        appDelegate.saveContext()
    }
    
    
    func fetchPokemonListItems() -> [PokemonListItem] {
        let fetchRequest: NSFetchRequest<PokemonListItem> = PokemonListItem.fetchRequest()
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch PokemonListItems: \(error)")
            return []
        }
    }
    

    
    func updatePokemonListItem(_ item: PokemonListItem, newName: String) {
        item.name = newName
        appDelegate.saveContext()
    }
    
    
    func clearCoreData() {
        let entities = appDelegate.persistentContainer.managedObjectModel.entities
            
            for entity in entities {
                if let entityName = entity.name {
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    
                    do {
                        try context.execute(deleteRequest)
                        try context.save()
                    } catch {
                        print("Failed to clear CoreData for entity: \(entityName), error: \(error)")
                    }
                }
            }
        }
    
    
}
