//
//  SimpleDataRepository.swift
//  StartSwiftUI
//
//  Created by 山崎健太 on 2022/01/14.
//

import Foundation
import Combine

final class DataRepository {
    // 参考: https://developer.apple.com/documentation/foundation/urlsession/processing_url_session_data_task_results_with_combine
    func fetch() -> AnyPublisher<[LGTM],Error> {
        let url = URL(string: "https://qiita.com/api/v2/items/a9ead7285d10aadf5643/likes")!
        let request = URLRequest(url: url)

        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(1) // エラーの場合の繰り返し回数. ネットワークエラーを想定しているっぽい.
            .tryMap{ element in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: [LGTM].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main) // メインスレッドで返却する
            .eraseToAnyPublisher() // AnyPublisherでラップできる. 下流に流すにはこの方法をAppleが推奨している.
    }
}
