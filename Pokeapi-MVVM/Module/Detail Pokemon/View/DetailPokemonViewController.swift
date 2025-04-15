//
//  DetailPokemonViewController.swift
//  Pokeapi-MVVM
//
//  Created by Fathya on 20/03/25.
//

import UIKit

class DetailPokemonViewController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    static let identifier = "DetailPokemonViewController"
    var detailUrl: String?
    var detailViewModel: DetailPokemonViewModel?
    var modelDetail: DetailPokeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        setupTableView()
        callAPI()
    }

    func setupTableView(){
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(UINib(nibName: "TopDetailTableViewCell", bundle: nil), forCellReuseIdentifier: TopDetailTableViewCell.identifier)
        detailTableView.register(UINib(nibName: "MovesTableViewCell", bundle: nil), forCellReuseIdentifier: MovesTableViewCell.identifier)
        detailTableView.separatorStyle = .none
    }
    
    func callAPI(){
        guard let detailUrl = detailUrl else { return }
        self.detailViewModel = DetailPokemonViewModel(urlString: detailUrl, apiService: ApiService())
        self.detailViewModel?.bindDetailPokemon = { detailModel in
            if let model = detailModel {
                self.modelDetail = model
            } else {
                self.detailTableView.backgroundColor = .red
            }
            print("reload data")
            DispatchQueue.main.async {
                self.detailTableView.reloadData()
            }
        }
    }
}

extension DetailPokemonViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return modelDetail?.moves.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = detailTableView.dequeueReusableCell(withIdentifier: "TopDetailTableViewCell", for: indexPath) as? TopDetailTableViewCell else { return UITableViewCell() }
            
            if let detail = modelDetail {
            cell.setData(data: detail)
            }
            
            return cell
        } else {
            guard let cell = detailTableView.dequeueReusableCell(withIdentifier: "MovesTableViewCell", for: indexPath) as? MovesTableViewCell else { return UITableViewCell() }
            let moveDetail = modelDetail?.moves[indexPath.row].move

            if let moveDetail = moveDetail {
            cell.setData(moveData: moveDetail)
            }
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
