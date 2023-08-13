import UIKit
import Combine

protocol PokemonDetailViewModelInput {
    var id: Int { get set }
}

protocol PokemonDetailViewModelOutput {
    var pokemonDetailResult: PassthroughSubject<PokemonDetailViewModel.Output, Never> { get }
}

protocol PokemonDetailViewModelProtocol {
    var input: PokemonDetailViewModelInput { get }
    var output: PokemonDetailViewModelOutput { get }
}

extension PokemonDetailViewModelProtocol where Self: PokemonDetailViewModelInput & PokemonDetailViewModelOutput {
    var input: PokemonDetailViewModelInput { return self }
    var output: PokemonDetailViewModelOutput { return self }
}
