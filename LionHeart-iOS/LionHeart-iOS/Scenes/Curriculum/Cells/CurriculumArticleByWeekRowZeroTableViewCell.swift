//
//  CurriculumArticleByWeekRowZeroTableViewCell.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//  Copyright (c) 2023 CurriculumArticleByWeekRowZero. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumArticleByWeekRowZeroTableViewCell: UITableViewCell, TableViewCellRegisterDequeueProtocol {

    var inputData: Int? {
        didSet {
            guard let inputData else { return }
            //inputData는 row가 0부터인데 주차정보는 4주차부터 시작이므로 +4를 해줌

            weekLabel.text = "\(inputData)주차"
            weekBackGroundImageView.image = WeekBackgroundImage.dummy()[inputData-4].weekBackgroundImage

        }
    }
    
    private enum Size {
        static let weekBackGroundImageSize: CGFloat = 200 / 375
    }

    private let weekBackGroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .designSystem(.gray500)
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let blurblackView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.black)?.withAlphaComponent(0.4)
        return view
    }()
    
    private lazy var leftWeekButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ImageLiterals.Curriculum.arrowLeftWeek, for: .normal)
        button.addButtonAction { _ in

            NotificationCenter.default.post(name: NSNotification.Name("leftButton"),
                                            object: nil)
        }
        return button
    }()
    
    private lazy var rightWeekButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(ImageLiterals.Curriculum.arrowRightWeek, for: .normal)
        button.addButtonAction { _ in

            NotificationCenter.default.post(name: NSNotification.Name("rightButton"),
                                            object: nil)
        }
        return button
    }()
    
    private let curriculumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .pretendard(.body2R)
        label.textColor = .designSystem(.lionRed)
        label.text = "Curriculum"
        return label
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendard(.head1)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        return label
    }()
    
    private let curriculumAndWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setHierarchy()
        setLayout()
    }

    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CurriculumArticleByWeekRowZeroTableViewCell {
    func setUI() {
    }
    
    func setHierarchy() {
        
        curriculumAndWeekStackView.addArrangedSubviews(curriculumLabel, weekLabel)
        weekBackGroundImageView.addSubviews(blurblackView, curriculumAndWeekStackView)
        contentView.addSubviews(weekBackGroundImageView, leftWeekButton, rightWeekButton)
        
    }
    
    func setLayout() {
        
        weekBackGroundImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
            $0.height.equalTo(weekBackGroundImageView.snp.width).multipliedBy(Size.weekBackGroundImageSize)
        }

        blurblackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        leftWeekButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        rightWeekButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
        
        curriculumAndWeekStackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
    
}
