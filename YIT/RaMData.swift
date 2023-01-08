import Foundation

// MARK: - RaMData
class RaMData: Codable {
    let info: Info?
    var results: [Character]
}

// MARK: - Info
class Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
