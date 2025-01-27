//
//  BookmarkCollectionViewCell.swift
//  LionHeart-iOS
//
//  Created by 황찬미 on 2023/07/11.
//  Copyright (c) 2023 Bookmark. All rights reserved.
//

import UIKit

import SnapKit

final class BookmarkListCollectionViewCell: UICollectionViewCell,
                                        CollectionViewCellRegisterDequeueProtocol {
    
    private enum Size {
        static let widthHeightRatio: CGFloat = 80/125
    }
    
    var bookmarkButtonClosure: ((IndexPath) -> Void)?
    
    var inputData: ArticleSummaries? {
        didSet {
            guard let inputData else { return }
            
            Task {
                let image = try await LHKingFisherService.fetchImage(with: inputData.articleImage)
                articleImageView.image = image
            }
            
            articleTitleLabel.text = inputData.title
            tagLabel.text =  inputData.tags.joined(separator: " · ")
        }
    }
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private let articleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목입니다 출산카드 신청하기 A to Z"
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = .pretendard(.title2)
        label.textColor = .designSystem(.white)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let tagLabel: UILabel = {
        let label = UILabel()
        label.text = "신체 변화 ⋅ 건강 ⋅ 아무튼 태그"
        label.font = .pretendard(.body4)
        label.textColor = .designSystem(.gray400)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(.assetImage(.bookmarkActiveSmall), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addButtonAction { [weak self] _ in
            guard let self else { return }
            guard let indexPath = getIndexPath() else { return }
            self.bookmarkButtonClosure?(indexPath)
        }
        return button
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray800)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setHierarchy()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BookmarkListCollectionViewCell {
    func setHierarchy() {
        addSubviews(articleImageView, articleTitleLabel, tagLabel, bookmarkButton, bottomLineView)
    }
    
    func setLayout() {
        articleImageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(ScreenUtils.getWidth(125))
            $0.height.equalTo(articleImageView.snp.width).multipliedBy(Size.widthHeightRatio)
        }
        
        articleTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(articleImageView.snp.trailing).offset(13)
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(-8)
        }
        
        tagLabel.snp.makeConstraints {
            $0.top.equalTo(articleTitleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(articleTitleLabel)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func getIndexPath() -> IndexPath? {
        guard let superView = self.superview as? UICollectionView else { return nil }
        return superView.indexPath(for: self)
    }
}
