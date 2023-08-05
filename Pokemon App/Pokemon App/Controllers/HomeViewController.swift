import UIKit


final class HomeViewController: UIViewController {

    private let viewModel = TitlesViewModel()
    
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

        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonTable.frame = view.bounds
    }

    private func fetchData() {
        viewModel.fetchData {
            DispatchQueue.main.async {
                self.pokemonTable.reloadData()
                print(self.viewModel.titles.count)
            }
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TitleTableViewCell.identifier,
            for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
      
        let title = viewModel.titles[indexPath.row]
        cell.configure(with: title)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = viewModel.titles.count - 1
        if indexPath.row == lastElement {
            fetchData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        mainCoordinator?.showDetails(id: indexPath.row)
    }

    func showTextFieldAlert() {
        let alertController = UIAlertController(title: "Attention",
                                                message: "No available information source",
                                                preferredStyle: .alert)

        let okAction = UIAlertAction(title: "Okay", style: .default) { _ in }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

}
