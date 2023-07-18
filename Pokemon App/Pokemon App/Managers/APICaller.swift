import Foundation

struct Constants {

}

class APICaller {
    static let shared = APICaller()

    func getPokemonList(completion: @escaping (Result<[Pokemon], RequestError>) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(Title.self, from: data) else{
                    completion(.failure(.decode))
                    return
                }
                return completion(.success(decodedResponse.results))
            case 401:
                return completion(.failure(.unauthorized))
            default:
                print(response.statusCode)
                return completion(.failure(.unexpectedStatusCode))
            }
 

        }
        task.resume()

    }

    func getPokemonInfo(url: String, completion: @escaping (Result<TitlePreview, Error>) -> Void) {
        guard let url = URL(string: url) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }

            do {
                let results = try JSONDecoder().decode(TitlePreview.self, from: data)
                completion(.success(results))
                print(results)
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }

        }
        task.resume()
    }
}
