//
//  ViewController.swift
//  Pokeapi-MVVM
//
//  Created by Fathya on 20/03/25.
//

import UIKit
import SDWebImage

class ListPokemonViewController: UIViewController {

    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var listPokemonViewModel: ListPokemonViewModel?
    var modelPokemon: PokemonModel?
    var filteredPokemon: [Results] = []
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PokeDex"
        setupCollectionView()
        setupSearchBar()
        callAPI()
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.masksToBounds = false
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        listCollectionView.register(UINib(nibName: "ListPokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ListPokemonCollectionViewCell.identifier)
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func callAPI(){
        self.listPokemonViewModel = ListPokemonViewModel(urlString: "https://pokeapi.co/api/v2/pokemon", apiService: ApiService())
        
        self.listPokemonViewModel?.bindListPokemonData = { pokeModel in
            if let model = pokeModel {
                self.modelPokemon = model
                self.filteredPokemon = model.results
            } else {
                self.listCollectionView.backgroundColor = .red
            }
            print("reload data")
            DispatchQueue.main.async {
                self.listCollectionView.reloadData()
            }
        }
    }
}

extension ListPokemonViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = isSearching ? filteredPokemon.count : modelPokemon?.results.count ?? 0
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pokemonList = isSearching ? filteredPokemon : modelPokemon?.results
        guard let pokemon = pokemonList?[indexPath.row],
            let cell = listCollectionView.dequeueReusableCell(withReuseIdentifier: ListPokemonCollectionViewCell.identifier, for: indexPath) as? ListPokemonCollectionViewCell else { return UICollectionViewCell() }
        cell.nameLabel.text = pokemon.name
        if let imageUrl = pokemon.image?.sprites.imageUrl {
            cell.pokemonPhoto.sd_setImage(with: URL(string: imageUrl))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 1.2, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pokemonList = isSearching ? filteredPokemon : modelPokemon?.results
        if let pokeData = pokemonList?[indexPath.row],
           let detailVC = storyboard.instantiateViewController(withIdentifier: DetailPokemonViewController.identifier) as? DetailPokemonViewController {
            
            detailVC.detailUrl = pokeData.url
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension ListPokemonViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredPokemon = modelPokemon?.results ?? []
        } else {
            isSearching = true
            filteredPokemon = modelPokemon?.results.filter { $0.name.lowercased().contains(searchText.lowercased()) } ?? []
        }
        listCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        filteredPokemon = modelPokemon?.results ?? []
        listCollectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}
