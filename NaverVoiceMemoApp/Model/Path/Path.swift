//
//  Path.swift
//  NaverVoiceMemoApp
//
//  Created by 김동현 on 2/11/24.
//

import Foundation

class PathModel: ObservableObject {
    
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {
        self.paths = paths
    }
}
