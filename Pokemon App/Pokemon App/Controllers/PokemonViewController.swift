import UIKit
import Combine
import SDWebImage

final class PokemonViewController: UIViewController {
    private var viewModel: PokemonDetailViewModel
    
    var activityIndicator: UIActivityIndicatorView?
    private let output = PassthroughSubject<PokemonDetailViewModel.Input, Never>()
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let pokemonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Image")
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private let pokemonName: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        nameLabel.textAlignment = .center
        return nameLabel
    }()

    private let pokemonType: UILabel = {
        let bodyTypeLabel = UILabel()
        bodyTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyTypeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        bodyTypeLabel.textAlignment = .left
        return bodyTypeLabel
    }()

    private let pokemonWeight: UILabel = {
        let weightLabel = UILabel()
        weightLabel.translatesAutoresizingMaskIntoConstraints = false
        weightLabel.font = UIFont.systemFont(ofSize: 24)
        weightLabel.textAlignment = .left
        return weightLabel
    }()

    private let pokemonHeight: UILabel = {
        let heightLabel = UILabel()
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        heightLabel.font = UIFont.systemFont(ofSize: 24)
        heightLabel.textAlignment = .left
        return heightLabel
    }()

    func showLoader() {
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.center = CGPoint(x: 125, y: 125)
            activityIndicator?.startAnimating()
            pokemonImage.addSubview(activityIndicator!)
        }
    }

    func hideLoader() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(pokemonImage)
        view.addSubview(pokemonName)
        view.addSubview(pokemonType)
        view.addSubview(pokemonWeight)
        view.addSubview(pokemonHeight)

        applyConstraints()
        observe()
        output.send(.getPokemonsDetailt)
    }

    func observe() {
        viewModel.fetchData(input: output.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .setPokemonDetail(let model):
                    self.pokemonName.text = model.name
                    self.pokemonHeight.text = "Height: \(model.height) cm"
                    self.pokemonWeight.text = "Weight: \(model.weight) kg"
                    self.pokemonType.text = "Type: \(model.type)"
                    if PokemonManager.shared.isConnectedToNetwork {
                        guard let url = URL(string: model.imageURL) else { return }
                        self.loadImage(with: url)
                    } else {
                        self.pokemonImage.image = UIImage(systemName: "tortoise")
                        self.pokemonImage.tintColor = UIColor.systemBackground
                    }
                    
                }
            }.store(in: &cancellable)
                
            }
        
    private func applyConstraints() {
        let pokemonImageConstraints = [
            pokemonImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokemonImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImage.widthAnchor.constraint(equalToConstant: 250),
            pokemonImage.heightAnchor.constraint(equalToConstant: 250)
        ]

        let pokemonNameConstraints = [
            pokemonName.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor, constant: 20),
            pokemonName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]

        let pokemonWeightConstraints = [
            pokemonWeight.topAnchor.constraint(equalTo: pokemonName.bottomAnchor, constant: 12),
            pokemonWeight.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonWeight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]

        let pokemonHeightConstraints = [
            pokemonHeight.topAnchor.constraint(equalTo: pokemonWeight.bottomAnchor, constant: 12),
            pokemonHeight.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonHeight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]

        let pokemonTypeConstraints = [
            pokemonType.topAnchor.constraint(equalTo: pokemonHeight.bottomAnchor, constant: 12),
            pokemonType.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(pokemonImageConstraints)
        NSLayoutConstraint.activate(pokemonNameConstraints)
        NSLayoutConstraint.activate(pokemonHeightConstraints)
        NSLayoutConstraint.activate(pokemonWeightConstraints)
        NSLayoutConstraint.activate(pokemonTypeConstraints)
    }
    
    func loadImage(with url: URL) {
        showLoader()

        pokemonImage.sd_setImage(with: url) { [weak self] (_, error, _, _) in
            self?.hideLoader()
            if let error = error {
                print("Failed to fetch image: \(error.localizedDescription)")
            }
        }
    }
}
