//
//  SearchViewController.swift
//  MovieMania
//
//  Created by JATIN YADAV on 30/05/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles : [Title] = [Title]()
    
    private let discoverTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen
        title="Search"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self

        fetchDiscoverMovies()
    }
    
    private func fetchDiscoverMovies(){
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else{
            return UITableViewCell()
        }
        
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.title, posterURL: title.poster_path ?? " Unknown Poster Path "))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
