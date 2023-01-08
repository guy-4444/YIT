import Foundation
import UIKit

class ImageUtil {
    
    typealias ImageCallBack = (UIImage?) -> Void

    static func loadImage(url: String, imageCallBack: @escaping ImageCallBack) {
        if let url = URL(string: url ?? "") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                imageCallBack(UIImage(data: data))
            }

            task.resume()
        }
    }
}
