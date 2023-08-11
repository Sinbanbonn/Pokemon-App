import UIKit
import Combine

protocol PreviewViewModelInput {
    func showAlert(_ title: String, _ message: String)
    func showDetail(id: Int)
}

protocol PreviewViewModelOutput {
    var pokemonListResult: PassthroughSubject<PreviewViewModel.Output, Never> { get }
}

protocol PreviewViewModelProtocol {
    var input: PreviewViewModelInput { get }
    var output: PreviewViewModelOutput { get }
}

extension PreviewViewModelProtocol where Self: PreviewViewModelInput & PreviewViewModelOutput {
    var input: PreviewViewModelInput { return self }
    var output: PreviewViewModelOutput { return self }
}
