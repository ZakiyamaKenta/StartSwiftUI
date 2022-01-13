//
//  SampleDataViewModel.swift
//  StartSwiftUI
//
//  Created by 山崎健太 on 2022/01/12.
//

import Foundation
import Combine

protocol SampleDataViewModelProtcol: ObservableObject {
    var cancelabe: Set<AnyCancellable> { get set }
    var sampleData: [LGTM] { get set }
    func fetchData()
}

class SampleDataViewModel: SampleDataViewModelProtcol, ObservableObject {
    // disposedBagと同じ役割、監視を解除しておくために必要
    var cancelabe = Set<AnyCancellable>()
    
    // @Publishedをつけることにより、値の変化があった場合通知するPublisherが自動的に作成される
    @Published var sampleData: [LGTM] = []

    func fetchData() {
        let url = URL(string: "https://qiita.com/api/v2/items/a9ead7285d10aadf5643/likes")!
        let request = URLRequest(url: url)

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ element in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: [LGTM].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { status in
                switch status {
                case .failure(let error):
                    print("エラー：\(error.localizedDescription)")
                case .finished:
                    print("完了")
                }
            },
            receiveValue: { [weak self] lgtm in
                guard let self = self else { return }
                self.sampleData = lgtm
            })
            .store(in: &cancelabe)  // cancelableを保存する
    }
}

