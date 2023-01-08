import Foundation


import UIKit
import CoreLocation

class CharacterController: UIViewController {
    
    
    @IBOutlet weak var character_IMG_avatar: UIImageView!
    @IBOutlet weak var character_LBL_name: UILabel!
    @IBOutlet weak var character_IMG_gender: UIImageView!
    @IBOutlet weak var character_LBL_gender: UILabel!
    @IBOutlet weak var character_LBL_status: UILabel!
    @IBOutlet weak var character_LBL_species: UILabel!
    @IBOutlet weak var character_LBL_type: UILabel!
    @IBOutlet weak var character_LBL_location: UILabel!
    @IBOutlet weak var character_LBL_origin: UILabel!
    @IBOutlet weak var character_LBL_episodes: UILabel!
    @IBOutlet weak var character_LST_episodes: UITableView!
    
    
    var character: Character?
    var selectedEpisode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    func update() {
        character_LBL_name.text = character?.name ?? "NA"
        character_LBL_gender.text = character?.gender ?? "NA"

        if let gnd = character?.gender {
            let images: [String: UIImage] = ["Male": #imageLiteral(resourceName: "ic_male"), "Female": #imageLiteral(resourceName: "ic_female")]
            character_IMG_gender.image = images[gnd]
        }
        
        character_LBL_status.text = character?.status ?? "NA"
        character_LBL_species.text = character?.species ?? "NA"
        character_LBL_type.text = character?.type ?? "NA"
        character_LBL_location.text = character?.location.name ?? "NA"
        character_LBL_origin.text = character?.location.name ?? "NA"
        let episodes = character?.episode.count ?? 0
        character_LBL_episodes.text = "\(episodes) episodes"

        ImageUtil.loadImage(url: character?.image ?? "", imageCallBack: { (img) -> Void in
            DispatchQueue.main.async {
                self.character_IMG_avatar.image = img
            }
        } )
                
        character_IMG_avatar.layer.borderWidth = 1
        character_IMG_avatar.layer.masksToBounds = false
        character_IMG_avatar.layer.borderColor = UIColor(named: "clr_border")?.cgColor
        character_IMG_avatar.layer.cornerRadius = character_IMG_avatar.frame.height/2
        character_IMG_avatar.clipsToBounds = true
        
        character_LST_episodes.delegate = self
        character_LST_episodes.dataSource = self
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openEpisode" {
            let episodeController = segue.destination as! EpisodeController
            episodeController.episodeLink = selectedEpisode
        }
    }
}

extension CharacterController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        self.selectedEpisode = self.character?.episode[didSelectRowAt.row]
        
        performSegue(withIdentifier: "openEpisode", sender: self)
    }
}

// MARK: UITableViewDataSource
extension CharacterController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.character?.episode.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "episodeCell", for: indexPath) as! EpisodeCell
        let episode = self.character?.episode[indexPath.row]
        
        let ep = episode?.components(separatedBy: "/").last
        cell.episodeCell_LBL_name.text = ep
        
        return cell
    }
    
}
