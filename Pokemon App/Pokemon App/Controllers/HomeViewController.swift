import UIKit
import Combine

final class HomeViewController: UIViewController {

    private let viewModel: PreviewViewModel
    private let output = PassthroughSubject<PreviewViewModel.Input, Never>()
    private var titles: [PokemonViewModel] = []
    private let pokemonTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    init(viewModel: PreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil , bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
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

        observe()
        output.send(.viewDidLoad)
        
    }

    func observe() {
        viewModel.fetchData(input: output.eraseToAnyPublisher())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .setPokemons(let pokemons):
                    self?.titles = pokemons
                    self?.pokemonTable.reloadData()
                case .updateView:
                    self?.pokemonTable.reloadData()
                }
            }.store(in: &cancellable)
            
    }
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonTable.frame = view.bounds
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


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.showDetail(id: indexPath.row)
    }
}
