import Foundation


import UIKit
import CoreLocation

class TableController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var lastRamData: RaMData?
    var results: [Character?] = []
    var isPaginationOn = false
    var selectedCharacter: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.isHidden = true

        tableView.register(UINib(nibName: "CharacterCustomCell", bundle: nil), forCellReuseIdentifier: "tableCell2")
        tableView.delegate = self
        tableView.dataSource = self
        
        makeNextRequest();
    }
    
    func makeNextRequest() {
        indicator.isHidden = false
        indicator.startAnimating()
        var API: String?
        
        if (lastRamData == nil) {
            API = "https://rickandmortyapi.com/api/character"
        } else{
            API = lastRamData?.info?.next
        }
        if let API_C = API {
            ApiManager().callApi(link: API_C, _delegate: self)
        }
    }
    
    func updateData(ramData: RaMData?) {
        indicator.isHidden = true
        indicator.stopAnimating()
        print("Listed")
        self.results.append(contentsOf: ramData?.results ?? [])
        self.lastRamData = ramData
        tableView.reloadData()
        isPaginationOn = false
        
        //scrollToBottom()
    }

    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.results.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openCharacter" {
            let characterController = segue.destination as! CharacterController
            characterController.character = selectedCharacter  
        }
    }
}

extension TableController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pos = scrollView.contentOffset.y
            if pos > tableView.contentSize.height-50 - scrollView.frame.size.height{
                guard !isPaginationOn else{
                    return
                }
                isPaginationOn = true
                makeNextRequest()
            }
        }
}

extension TableController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        self.selectedCharacter = self.results[didSelectRowAt.row]
        
        performSegue(withIdentifier: "openCharacter", sender: self)
    }
}

// MARK: UITableViewDataSource
extension TableController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell2", for: indexPath) as! CharacterTableCell2
        let character = self.results[indexPath.row]
        cell.myLabel.text = character?.name
        
        ImageUtil.loadImage(url: character?.image ?? "", imageCallBack: { (img) -> Void in
            DispatchQueue.main.async {
                cell.myImage.image = img
            }
        } )

        return cell
    }
    
}


// MARK: API MANAGER Call Back
extension TableController: CallBack_ApiManager {
    func dataReady(ramData: RaMData) {
        print("\(ramData.results.count): \(ramData.info?.pages) episodes")

        // Run on UIThread
        DispatchQueue.main.async {
            self.updateData(ramData: ramData)
        }
    }

    func onError(error: Error?) {
        print(error.debugDescription)
    }
}
