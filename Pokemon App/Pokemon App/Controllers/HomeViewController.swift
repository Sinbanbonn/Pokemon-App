import UIKit
import Reachability
import CoreData

class HomeViewController: UIViewController {

    private var titles: [PokemonViewModel] = [PokemonViewModel]()
    private let pokSer = NetworkService()
    
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
        let customTitleView = TitleView()
            customTitleView.titleLabel.text = "Pokemon List"
           
            
            navigationItem.titleView = customTitleView

        view.addSubview(pokemonTable)
        pokemonTable.delegate = self
        pokemonTable.dataSource = self
        //title = "Pokemon List"
        
        fetchData()
        //CoreDataManager.shared.clearoreData()
       print(isInternetAvailable())
        
    }
    func isInternetAvailable() -> Bool {
        let reachability = try! Reachability()
        return reachability.connection != .unavailable
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonTable.frame = view.bounds
    }

    private func fetchData() {
        PokemonManager.shared.getPokemonList(offset: 0) { [weak self] result in
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
        cell.configure(with: title)
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
        print(indexPath.row)
        let pokemon = titles[indexPath.row]
        PokemonManager.shared.getPokemonDetails(id: indexPath.row) { [weak self] result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    let vc = PokemonViewController()
                    vc.configure(with: pokemon)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

    }
}

