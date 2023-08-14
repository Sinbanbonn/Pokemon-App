import UIKit
import Combine

/// Input requirements for the DetailViewModel.
protocol DetailViewModelInput {
    var id: Int { get }
}

/// Output requirements for the DetailViewModel.
protocol DetailViewModelOutput {
    var detailModelResult: PassthroughSubject<Result<Void, Error>, Never> { get }
}

/// Protocol that combines both input and output requirements for the DetailViewModel.
protocol DetailViewModelProtocol {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get }
}

/// Default implementation of the DetailViewModelProtocol using the conformance to input and output requirements.
extension DetailViewModelProtocol where Self: DetailViewModelInput & DetailViewModelOutput {
    var input: DetailViewModelInput { return self }
    var output: DetailViewModelOutput { return self }
}
