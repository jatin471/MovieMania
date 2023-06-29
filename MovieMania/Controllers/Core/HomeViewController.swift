//
//  HomeViewController.swift
//  MovieMania
//
//  Created by JATIN YADAV on 30/05/23.
//

import UIKit


enum Sections : Int {
    case TrendingMovie = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
    }

class HomeViewController: UIViewController {

    let sectionTitle :[String] = ["Trending Movie" ,"Top Rated" , "Popular" ,  "Trending Shows","Upcoming"]
    
    private let homeFeedTable : UITableView = {
        let table =  UITableView(frame: .zero, style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           
           view.backgroundColor = .systemBackground
           view.addSubview(homeFeedTable)
           
           homeFeedTable.delegate = self
           homeFeedTable.dataSource = self
        
        
        configureNavbar()
        
        let headerView = HeroHeader(frame : CGRect(x: 0, y: 0, width: view.bounds.width, height: 400))
        homeFeedTable.tableHeaderView = headerView
        
        
       }
    
    
    
    private func configureNavbar() {
//        var image =
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "m.square"), style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell else {
            fatalError("Unable to dequeue CollectionTableViewCell")
        }

        switch indexPath.section {
        case Sections.TrendingMovie.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }

        default:
            fatalError("Invalid section")
        }

        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        headerView.frame = CGRect(x: headerView.bounds.origin.x+20 , y: headerView.bounds.origin.y, width: 80, height: 40)
        
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        headerView.textLabel?.text = sectionTitle[section]
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset  = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
}
