import Foundation
import UIKit

class CharacterTableCell: UITableViewCell {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

class CharacterTableCell2: UITableViewCell {
    

    @IBOutlet weak var root: UIView!
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.root.layer.cornerRadius = 24
        self.root.layer.masksToBounds = true

//        self.contentView.backgroundColor = .white
//        self.contentView.layer.cornerRadius = 38
        self.contentView.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowRadius = 10;
        self.contentView.layer.shadowOpacity = 0.35;
    }
}
