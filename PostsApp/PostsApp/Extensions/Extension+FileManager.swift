//
//  Extension+FileManager.swift
//  PostsApp
//
//  Created by Matvei Khlestov on 19.07.2024.
//

import Foundation

extension FileManager {
    func documentsDirectoryURL() -> URL? {
        return self.urls(for: .documentDirectory, in: .userDomainMask).first
    }
}
