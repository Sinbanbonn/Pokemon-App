import UIKit

class HomeViewController: UIViewController {

    private var titles: [Pokemon] = [Pokemon]()
    private let pokSer = RepoService()
    private let pokemonTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pokemonTable.layoutIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(pokemonTable)
        pokemonTable.delegate = self
        pokemonTable.dataSource = self
        title = "Pokemon List"
        
        fetchData()
        pokSer.getPokemonList(offset: 0, limit: 20) { result in
            switch result {
            case .success(let list):
                print(list.results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        
        }


    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonTable.frame = view.bounds
    }

    private func fetchData() {
        APICaller.shared.getPokemonList { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles += titles
                DispatchQueue.main.async {
                    self?.pokemonTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }

        let title = titles[indexPath.row]
        cell.configure(with: PokemonViewModel(titleName: title.name.capitalizeFirstLetter()))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = titles.count - 1
        if indexPath.row == lastElement {
           fetchData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let pokemon = titles[indexPath.row]
        APICaller.shared.getPokemonInfo(url: pokemon.url) { [weak self] result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    let vc = PokemonViewController()
                    vc.configure(with: PokemonDetailViewModel(
                        picture: pokemon.sprites.other.officialArtwork.frontDefault,
                        name: pokemon.name.capitalizeFirstLetter(),
                        height: pokemon.height,
                        weight: pokemon.weight,
                        type: pokemon.types.map { $0.type.name }.joined(separator: ", ")))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}
