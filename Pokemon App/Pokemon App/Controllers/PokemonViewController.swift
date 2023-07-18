import UIKit
import SDWebImage

class PokemonViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(pokemonImage)
        view.addSubview(pokemonName)
        view.addSubview(pokemonType)
        view.addSubview(pokemonWeight)
        view.addSubview(pokemonHeight)

        applyConstraints()
    }

    private func applyConstraints() {

       let pokemonImageConstraints = [pokemonImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pokemonImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pokemonImage.widthAnchor.constraint(equalToConstant: 250),
            pokemonImage.heightAnchor.constraint(equalToConstant: 250)]

        let pokemonNameConstraints =
            [pokemonName.topAnchor.constraint(equalTo: pokemonImage.bottomAnchor, constant: 20),
            pokemonName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)]

        let pokemonWeightConstraints =
            [pokemonWeight.topAnchor.constraint(equalTo: pokemonName.bottomAnchor, constant: 12),
            pokemonWeight.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonWeight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)]
        let pokemonHeightConstraints =
            [pokemonHeight.topAnchor.constraint(equalTo: pokemonWeight.bottomAnchor, constant: 12),
            pokemonHeight.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonHeight.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)]
        let pokemonTypeConstraints =
            [pokemonType.topAnchor.constraint(equalTo: pokemonHeight.bottomAnchor, constant: 12),
            pokemonType.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pokemonType.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)]

        NSLayoutConstraint.activate(pokemonImageConstraints)
        NSLayoutConstraint.activate(pokemonNameConstraints)
        NSLayoutConstraint.activate(pokemonHeightConstraints)
        NSLayoutConstraint.activate(pokemonWeightConstraints)
        NSLayoutConstraint.activate(pokemonTypeConstraints)

    }

    func configure(with model: TitlePreviewViewModel) {
        pokemonName.text = model.name
        pokemonHeight.text = "Height: \(model.height) cm"
        pokemonWeight.text = "Weight: \(model.weight) kg"
        pokemonType.text = "Type: \(model.type)"

        guard let url = URL(string: model.picture) else {return}
        pokemonImage.sd_setImage(with: url)
    }

}
