import Foundation

import UIKit
import CoreLocation

class EpisodeController: UIViewController {
    
    
    @IBOutlet weak var episode_LBL_number: UILabel!
    @IBOutlet weak var episode_LBL_name: UILabel!
    @IBOutlet weak var episode_LBL_date: UILabel!
    
    var episodeLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let API_C = episodeLink {
            ApiEpisode().callApi(link: API_C, _delegate: self)
        }
    }
    
    func updateData(episode: Episode) {
        episode_LBL_number.text = episode.episode
        episode_LBL_name.text = episode.name
        episode_LBL_date.text = episode.airDate
    }
}

// MARK: API MANAGER Call Back
extension EpisodeController: CallBack_ApiEpisode {
    func dataReady(episode: Episode) {
        DispatchQueue.main.async {
            self.updateData(episode: episode)
        }
    }

    func onError(error: Error?) {
        print(error.debugDescription)
    }
}
