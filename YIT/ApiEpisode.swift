import Foundation


protocol CallBack_ApiEpisode {
    func dataReady(episode: Episode)
    func onError(error: Error?)
}

class ApiEpisode {
    
    var delegate: CallBack_ApiEpisode?
    
    init() {}
    
    func callApi(link: String, _delegate: CallBack_ApiEpisode?) {
        self.delegate = _delegate
        
        if let url = URL(string: link) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url, completionHandler: handler(data:urlResponse:error:))
            
            task.resume()
        }
    }
    
    func handler(data: Data?, urlResponse: URLResponse?, error: Error?) {
        if (error != nil) {
            print("error = \(error)")
            delegate?.onError(error: error)
            return
        }
        
        
        if let safeData = data {
            var episode: Episode! = jsonToEpisode(data: safeData)
            delegate?.dataReady(episode: episode)
        }
    }
    func jsonToEpisode(data: Data) -> Episode? {
        let decoder = JSONDecoder()

        do {
            var episode = try decoder.decode(Episode.self, from: data)
            return episode
        } catch {
            print("error = \(error)")
        }

        return nil
    }

}
