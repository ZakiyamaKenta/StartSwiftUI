//
//  SampleDataViewModel.swift
//  StartSwiftUI
//
//  Created by 山崎健太 on 2022/01/12.
//

import Foundation
import Combine

final class SampleDataViewModel: ObservableObject {
    var repository: DataRepository = DataRepository()
    
    // disposedBagと同じ役割、監視を解除しておくために必要
    var cancelabe = Set<AnyCancellable>()
    
    // @Publishedをつけることにより、値の変化があった場合通知するPublisherが自動的に作成される
    @Published var sampleData: [LGTM] = []

    func fetchData() {
        repository.fetch()
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
