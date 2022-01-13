//
//  SampleData.swift
//  StartSwiftUI
//
//  Created by 山崎健太 on 2022/01/12.
//

import Foundation

struct LGTM: Codable {
    var created_at: String
    var user: User
}
struct User: Codable {
    var id: String
}
