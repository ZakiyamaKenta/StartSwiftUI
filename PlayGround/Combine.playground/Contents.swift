/// 登場人物
/// パブリッシャー: 値を出力する
/// サブスクライバー: 値を取得する

import UIKit
import Foundation
import Combine

extension Notification.Name {
    static let finishCalc = Notification.Name("finishCalc")
}

execution()


/// 実行する!!!
func execution(){
    // 実行する関数を書いてね
    simpleCombine2()
}

/// JustとSinkを使用する!
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

/// JustとSinkを使用する!
func simpleCombine2() {
    // anyCancelable型が返却される!! ワンライナーで書ける!!
    Just(9000).sink(receiveValue: { value in
        print(value)
    })
}

func simpleCombineAssign1() {
    class TestResult {
        var score: Int
        init(score: Int) {
            self.score = score
        }
    }
    
    let testResult = TestResult(score: 80)
    print("点数：\(testResult.score)")
    // assignで指定したプロパティに代入することができる
    // onに代入するプロパティを持つインスタンスを指定. toに代入したいプロパティを指定する
    // バクスラドットについて: KeyPath型の省略記法. 今回だと、\TestResult.scoreと同義. onでインスタンスの型がわかってるからね!
    let _ = Just(100).assign(to: \.score, on: testResult)
    print("更新後の点数：\(testResult.score)")
}

/// パブリッシャーとサブスクライバーで型違いが起きていた場合の処理
func simpleCombineAssignOperator1() {
    class TestResult {
        var score: Int
        init(score: Int) {
            self.score = score
        }
    }
    
    let testResult = TestResult(score: 80)
    print("点数：\(testResult.score)")
    // パブリッシャーはString. サブスクライバーはInt型の場合を想定
    let _ = Just("ホゲ")
        .map { (Int($0) ?? 0) } // mapで型変換する
        .assign(to: \.score, on: testResult)
    print("更新後の点数：\(testResult.score)")
}

/// notificationCenterPublisherを利用する経由
func notificationCombine(){
    class TestResult {
        var score: Int
        init(score: Int) {
            self.score = score
        }
    }
    
    let testResult = TestResult(score: 80)
    print("点数：\(testResult.score)")
    let _ = NotificationCenter.default.publisher(for: .finishCalc, object: nil)
        .map { $0.userInfo?["result"] as? Int ?? 0 }
        .assign(to: \.score, on: testResult)

    // 値を送信する
    NotificationCenter.default.post(name: .finishCalc, object: nil,
                                    userInfo: ["result": 100])
    print("更新後の点数：\(testResult.score)")
}

