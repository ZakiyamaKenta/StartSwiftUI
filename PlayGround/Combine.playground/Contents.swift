/// 登場人物
/// パブリッシャー: 値を出力する
/// サブスクライバー: 値を取得する

import UIKit
import Foundation
import Combine

func simpleCombine() {
    // JustPublisherを使用する!!
    let publisher = Just("ホゲホゲ")
    // SinkSubScriberを使用する!!
    let subscriber = Subscribers.Sink<String,Never>(receiveCompletion:{ result in
        // 状態が渡ってくる
        switch result {
        case .failure(let error):
            print(error.localizedDescription)
        case .finished:
            print("正常終了")
        }
    }, receiveValue: { value in
        print(value)
    })
    
    // 実行!!
    publisher.subscribe(subscriber)
}

func simpleCombine2() {
    // anyCancelable型が返却される!! ワンライナーで書ける!!
    Just(9000).sink(receiveValue: { value in
        print(value)
    })
}

func execution(){
    simpleCombine2()
}

execution()
