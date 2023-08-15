import UIKit
import Combine

final class PreviewViewController: UIViewController {
    
    private let viewModel: PreviewViewModel
    private var cancellable = Set<AnyCancellable>()
    
    private let pokemonTable: UITableView = {
        let table = UITableView()
        table.registerWithoutNib(TitleTableViewCell.self)
        return table
    }()
    
    init(viewModel: PreviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        
        bindPublishers()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pokemonTable.frame = view.bounds
    }
}

extension PreviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(TitleTableViewCell.self, for: indexPath) else {  return UITableViewCell()}
        cell.configure(with: viewModel.titles[indexPath.row])
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

extension PreviewViewController {
    /// Bind publishers for data updates
    func bindPublishers() {
        viewModel.output.pokemonListResult
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                switch result {
                case .success:
                    self?.viewModel.fetchData()
                    self?.pokemonTable.reloadData()
                case .failure:
                    break
                }
            })
            .store(in: &cancellable)
    }
}
