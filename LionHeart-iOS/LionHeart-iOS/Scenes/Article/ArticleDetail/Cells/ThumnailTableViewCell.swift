//
//  ThumnailTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 김민재 on 2023/07/12.
//  Copyright (c) 2023 Thumnail. All rights reserved.
//

import UIKit

import SnapKit

final class ThumnailTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    private enum Size {
        static let thumbnailWidthHeightRatio: CGFloat = 224 / 375
    }

    var bookmarkButtonDidTap: ((Bool) -> Void)?

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let gradientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ImageLiterals.Curriculum.gradient
        return imageView
    }()

    private let imageCaptionLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray500)
        return label
    }()

    private lazy var bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(ImageLiterals.BookMark.inactiveBookmarkBig, for: .normal)
        button.setImage(ImageLiterals.BookMark.activeBookmarkBig, for: .selected)
        button.addButtonAction { [weak self] _ in
            guard let self else { return }
            button.isSelected.toggle()
            self.bookmarkButtonDidTap?(button.isSelected)
        }
        return button
    }()

    var inputData: ArticleBlockData? {
        didSet {
            configureCell(inputData)
        }
    }

    var isMarked: Bool? {
        didSet {
            guard let isMarked else { return }
            bookMarkButton.isSelected = isMarked
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.thumbnailImageView.image = nil
    }
}

private extension ThumnailTableViewCell {
    
    func setHierarchy() {
        contentView.addSubviews(thumbnailImageView, imageCaptionLabel, bookMarkButton)
        thumbnailImageView.addSubview(gradientImageView)
    }
    
    func setLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(Constant.Screen.width)
            make.height.equalTo(thumbnailImageView.snp.width).multipliedBy(Size.thumbnailWidthHeightRatio)
        }

        gradientImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        imageCaptionLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.centerX.equalTo(thumbnailImageView)
            make.bottom.equalToSuperview().inset(22)
        }

        bookMarkButton.snp.makeConstraints{
            $0.top.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
        }

    }

    
    func configureCell(_ model: ArticleBlockData?) {
        guard let model else { return }
        Task {
            let image = try await LHKingFisherService.fetchImage(with: model.content)
            thumbnailImageView.image = image
        }
        imageCaptionLabel.text = model.caption
    }
}

extension ThumnailTableViewCell {
    func setThumbnailImageView() {
        bookMarkButton.isHidden = false
        gradientImageView.isHidden = false
    }

    func setImageTypeCell() {
        imageCaptionLabel.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(72)
        }
        gradientImageView.isHidden = true
        bookMarkButton.isHidden = true
    }
}
