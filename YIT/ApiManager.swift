import Foundation


protocol CallBack_ApiManager {
    func dataReady(ramData: RaMData)
    func onError(error: Error?)
}

class ApiManager {
    
    var delegate: CallBack_ApiManager?
    
    init() {}
    
    func callApi(link: String, _delegate: CallBack_ApiManager?) {
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
            // How to convert Data object to String
            let dataString = String(data: safeData, encoding: .utf8)
            
            
            var ramData: RaMData! = jsonToRaMData(data: safeData)
            sleep(2)
            
            print("success = \(ramData.info?.count)")
            delegate?.dataReady(ramData: ramData)
        }
    }
    
    func jsonToRaMData(data: Data) -> RaMData? {
        let decoder = JSONDecoder()

        do {
            var ramData = try decoder.decode(RaMData.self, from: data)
            return ramData
        } catch {
            print("error = \(error)")
        }
        
        return nil
    }
}
