//
//  CopyRightTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 CopyRight. All rights reserved.
//

import UIKit

import SnapKit

final class CopyRightTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    private enum Size {
        static let backgroundViewWidthHeightRatio: CGFloat = 118 / 375
    }

    //TODO: - inputData가 없는 경우..
    var inputData: DummyModel?

    private let copyrightBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.background)
        return view
    }()

    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.text = "모든 콘텐츠는 제공자와 라이온하트에 저작권이 있습니다.\n저작권법에 의거 무단 전재 및 재배포를 금지합니다."
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray600)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CopyRightTableViewCell {
    
    func setHierarchy() {
        contentView.addSubview(copyrightBackgroundView)
        copyrightBackgroundView.addSubview(copyrightLabel)
    }
    
    func setLayout() {
        copyrightBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(copyrightBackgroundView.snp.width).multipliedBy(Size.backgroundViewWidthHeightRatio)
        }
        copyrightLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(26)
            make.centerX.equalToSuperview()
        }
    }
}
