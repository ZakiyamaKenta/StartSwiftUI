//
//  MainListView.swift
//  StartSwiftUI
//
//  Created by 山崎健太 on 2022/01/12.
//

import SwiftUI

struct MainListView: View {
    
    // @ObservedObjectをつけると、値の変化を自動的に監視してくれる
    @ObservedObject var viewModel = SampleDataViewModel()

    var body: some View {
        List {
            // id: \.self List表示させるデータはIdentifiableに準拠させるか、idを振ってあげる
            ForEach( 0..<viewModel.sampleData.count, id: \.self) { index in
                Text(viewModel.sampleData[index].created_at)
            }
        }.onAppear{
            viewModel.fetchData()
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView(viewModel: SampleDataViewModel())
    }
}
