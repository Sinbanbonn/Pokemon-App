import UIKit

protocol TitleTableViewCellDelegate: AnyObject {
    func titleTableViewCellDidTapCell(_ cell: TitleTableViewCell, viewModel: PokemonDetailViewModel)
}

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"

    weak var delegate: TitleTableViewCellDelegate?

    private let playTitleButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "pawprint",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)

        applyConstraints()
    }

    private func  applyConstraints() {

        let titleLabelConstraints = [
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]

        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]

        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }

    public func configure(with model: PokemonViewModel) {
        titleLabel.text = model.titleName.capitalizeFirstLetter()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
