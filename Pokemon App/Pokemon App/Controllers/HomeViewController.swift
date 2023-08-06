import UIKit


final class HomeViewController: UIViewController {

    private let viewModel = TitlesViewModel()
    private var titles: [PokemonViewModel] = []
    weak var mainCoordinator: MainCoordinator?
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
        navigationItem.titleView = customTitleView
        view.addSubview(pokemonTable)
        pokemonTable.delegate = self
        pokemonTable.dataSource = self

        if PokemonManager.shared.isConnectedToNetwork {
            CoreDataManager.shared.clearСoreData()
        }
        else {
            mainCoordinator?.showTextFieldAlert()
        }
        Task{
            try await fetchData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonTable.frame = view.bounds
    }
    
    private func fetchData() async throws {
        do {
            titles = try await viewModel.fetchData()
            DispatchQueue.main.async {
                self.pokemonTable.reloadData()
            }
        }
        catch {
            throw error
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TitleTableViewCell.identifier,
            for: indexPath) as? TitleTableViewCell else {
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
        let lastElement = viewModel.titles.count - 1
        if indexPath.row == lastElement {
            Task{
                try await fetchData()
            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mainCoordinator?.showDetails(id: indexPath.row)
    }
}
