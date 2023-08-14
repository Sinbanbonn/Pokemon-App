import UIKit
import Combine


/// Input requirements for the PreviewViewModel.
protocol PreviewViewModelInput {
    // Function to show an alert
    func showAlert(_ title: String, _ message: String)
    // Function to show the detail view for a Pokemon with the given id
    func showDetail(id: Int)
}

/// Output requirements for the PreviewViewModel.
protocol PreviewViewModelOutput {
    // Published property for the ViewModel's state
    var viewModelState: Published<PreviewViewModelState>.Publisher { get }
    // PassthroughSubject to emit the result of the Pokemon list request
    var pokemonListResult: PassthroughSubject<Result<Void, Error>, Never> { get }
}

/// Protocol that combines both input and output requirements for the PreviewViewModel.
protocol PreviewViewModelProtocol {
    var input: PreviewViewModelInput { get }
    var output: PreviewViewModelOutput { get }
}

/// Default implementation of the PreviewViewModelProtocol using the conformance to input and output requirements.
extension PreviewViewModelProtocol where Self: PreviewViewModelInput & PreviewViewModelOutput {
    var input: PreviewViewModelInput { return self }
    var output: PreviewViewModelOutput { return self }
}
