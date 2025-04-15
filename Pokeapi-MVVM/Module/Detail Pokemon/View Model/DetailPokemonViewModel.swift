//
//  DetailPokemonViewModel.swift
//  Pokeapi-MVVM
//
//  Created by Fathya on 20/03/25.
//

import Foundation

protocol DetailPokemonViewProtocol {
    var urlString: String { get }
    var bindDetailPokemon: (((DetailPokeModel)?) -> ())? { get set }
    func fetchPokemonDetailDatas()
}

class DetailPokemonViewModel: DetailPokemonViewProtocol {
    private var apiService: ApiServiceProtocol?
    var urlString: String
    var detailPokeModel: DetailPokeModel?
    
    var bindDetailPokemon: (((DetailPokeModel)?) -> ())?
    
    init(urlString: String, apiService: ApiServiceProtocol){
        self.urlString = urlString
        self.apiService = apiService
        if let url = URL(string: urlString){
            self.apiService?.get(url: url)
        }
        fetchPokemonDetailDatas()
    }
    
    func fetchPokemonDetailDatas() {
        self.apiService?.callApi(model: DetailPokeModel.self, completion: { response in
            switch response {
            case .success(let detailData):
                print("success get detail pokemon")
                self.detailPokeModel = detailData
                let group = DispatchGroup()
                
                for (index, move) in detailData.moves.enumerated(){
                    group.enter()
                    
                    guard let detailMoveURL = URL(string: move.move.url) else {
                        group.leave()
                        continue
                    }
                    
                    self.apiService?.get(url: detailMoveURL)
                    print("GET \(detailMoveURL)")
                    self.apiService?.callApi(model: MoveDetailModel.self, completion: { response in
                        switch response{
                        case .success(let detailMoveData):
                            self.detailPokeModel?.moves[index].move.detail = detailMoveData
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        
                        group.leave()
                    })
                }
                group.notify(queue: DispatchQueue.main) {
                    self.bindDetailPokemon?(self.detailPokeModel)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                self.bindDetailPokemon?(nil)
            }
        })
    }
}
