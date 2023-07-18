import Foundation
import Reachability

struct Constants {

}

class APICaller {
    
    static let shared = APICaller()
    private var baseURL = "https://pokeapi.co/api/v2/pokemon"
    //checking for internet connection
    private let reachability = try! Reachability()
    private var isConnectedToNetwork: Bool {
            return reachability.connection != .unavailable
        }
    
    func getPokemonList(completion: @escaping (Result<[Pokemon], RequestError>) -> Void) {
        print(isConnectedToNetwork)
        guard let url = URL(string: baseURL) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.serviceUnavailable))
                return
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(Title.self, from: data) else{
                    completion(.failure(.decode))
                    return
                }
                self.baseURL = decodedResponse.next
                completion(.success(decodedResponse.results))
            case 400...499:
                let error = handleResponseError(statusCode: response.statusCode)
                completion(.failure(error))
            case 500...599:
                let error = handleResponseError(statusCode: response.statusCode)
                completion(.failure(error))
            
            default:
                completion(.failure(.other(response.statusCode)))
            }
 

        }
        task.resume()

    }

    func getPokemonInfo(url: String, completion: @escaping (Result<TitlePreview, RequestError>) -> Void) {
        guard let url = URL(string: url) else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.serviceUnavailable))
                return
            }
            
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(TitlePreview.self, from: data) else{
                    completion(.failure(.decode))
                    return
                }
                completion(.success(decodedResponse))
            case 400...499:
                let error = handleResponseError(statusCode: response.statusCode)
                completion(.failure(error))
            case 500...599:
                let error = handleResponseError(statusCode: response.statusCode)
                completion(.failure(error))
            
            default:
                completion(.failure(.other(response.statusCode)))
            }       }
        task.resume()
    }
}
