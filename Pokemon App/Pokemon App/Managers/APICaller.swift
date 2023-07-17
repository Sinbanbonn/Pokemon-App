//
//  APICaller.swift
//  Pokemon App
//
//  Created by Андрей Логвинов on 7/17/23.
//

import Foundation

struct Constants {
    
}

class APICaller {
    static let shared = APICaller()
    
    func getPokemonList(completion: @escaping (Result<[Pokemon] , Error>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(Title.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(error))
            }
           
        
        }
        task.resume()
        
    }
    
    func getPokemonInfo(url: String,completion: @escaping (Result<TitlePreview , Error>) -> Void) {
        guard let url = URL(string: url) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data , error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TitlePreview.self, from: data)
                completion(.success(results))
                print(results)
            }
            catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
           
        
        }
        task.resume()
    }
}
