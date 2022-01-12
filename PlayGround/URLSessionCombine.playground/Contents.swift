import Foundation
import Combine
/// Playgroundで非同期扱う場合はこれらを有効にする. 関数で括らない
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

struct LGTM: Codable {
    var created_at: String
    var user: User
}
struct User: Codable {
    var id: String
}

let url = URL(string: "https://qiita.com/api/v2/items/a9ead7285d10aadf5643/likes")!
let request = URLRequest(url: url)

let publisher = URLSession.shared.dataTaskPublisher(for: request)
    .tryMap{ element in
        guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return element.data
    }
    .decode(type: [LGTM].self, decoder: JSONDecoder())
    .sink(receiveCompletion: { status in
        switch status {
        case .failure(let error):
            print("エラー：\(error.localizedDescription)")
        case .finished:
            print("完了")
        }
    },
    receiveValue: { lgtm in
        print(lgtm.first?.user.id)
    })
print("処理終了")

