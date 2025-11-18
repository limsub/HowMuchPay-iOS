//
//  BaseCollectionViewCell.swift
//  TTOON
//
//  Created by 임승섭 on 4/5/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        layouts()
        configures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addSubViews() { }
    func layouts() { }
    func configures() {
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear 
    }
}

extension BaseCollectionViewCell {
    func makeGenreStr(_ genres: [String]) -> String  {
        var str = ""
        for (idx, genre) in genres.enumerated() {
            if (idx != genres.count - 1) {
                str += "\(genre) · "
            } else {
                str += "\(genre)"
            }
        }
        return str
    }
}
