//
//  SubtitleTableViewCell.swift
//  DIT355
//
//  Created by Jean paul Massoud on 2019-11-18.
//  Copyright © 2019 DIT355-group. All rights reserved.
//
import UIKit

class SubtitleTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
