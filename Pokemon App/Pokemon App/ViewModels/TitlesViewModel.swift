import Foundation


final class TitlesViewModel {
    var titles: [PokemonViewModel] = [PokemonViewModel]()
    private let pokSer = NetworkService()

    public func fetchData(completion: @escaping(() -> Void)) {
        PokemonManager.shared.getPokemonList(offset: 0) { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles += titles
                print(titles.count)
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
}
