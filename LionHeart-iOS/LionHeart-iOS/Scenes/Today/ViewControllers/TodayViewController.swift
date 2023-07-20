//
//  TodayViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 Today. All rights reserved.
//

import UIKit

import SnapKit

final class TodayViewController: UIViewController {
    
    enum TodayArticleImage {
        static let ratio: CGFloat = 400/335
    }
    
    private var todayArticleID: Int?

    private lazy var todayNavigationBar = LHNavigationBarView(type: .today, viewController: self)
    private let loadingIndicatorView = LHLoadingView()
    
    private let seperateLine: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray800)
        return view
    }()
    
    private var titleLabel = LHTodayArticleTitle()
    private var subTitleLable = LHTodayArticleTitle(initalizeString: "오늘의 아티클이에요")
    private var mainArticleView = TodayArticleView()
    
    private var pointImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "TodayArticle_PointImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNavigationBar()
        setHierarchy()
        setLayout()
        setTapGesture()
        setButtonAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getInquireTodayArticle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mainArticleView.mainArticlImageView.removeGradient()
    }
}

// MARK: - 네트워킹
extension TodayViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .urlEncodingError:
            LHToast.show(message: "URL인코딩오류입니다", isTabBar: true)
        case .jsonDecodingError:
            LHToast.show(message: "Json디코딩오류입니다", isTabBar: true)
        case .badCasting:
            LHToast.show(message: "배드퀘스트", isTabBar: true)
        case .fetchImageError:
            LHToast.show(message: "이미지패치실패", isTabBar: true)
        case .unAuthorizedError:
            LHToast.show(message: "인증오류", isTabBar: true)
        case .clientError(_, let message):
            LHToast.show(message: message, isTabBar: true)
        case .serverError:
            LHToast.show(message: "승준이어딧니 내목소리들리니", isTabBar: true)
        }
    }
}

extension TodayViewController {
    func getInquireTodayArticle() {
        Task {
            view.addSubview(loadingIndicatorView)
            loadingIndicatorView.startAnimating()
            do {
                let responseArticle = try await ArticleService.shared.inquiryTodayArticle()
                let image = try await LHKingFisherService.fetchImage(with: responseArticle.mainImageURL)
                mainArticleView.mainArticlImageView.image = image
                titleLabel.userNickName = responseArticle.fetalNickname
                mainArticleView.data = responseArticle
                todayArticleID = responseArticle.aticleID
                loadingIndicatorView.stopAnimating()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }

        }
    }
}

// MARK: - layout
private extension TodayViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.black)
    }
    
    func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setHierarchy() {
        view.addSubviews(todayNavigationBar, seperateLine)
        view.addSubviews(titleLabel, subTitleLable, pointImage, mainArticleView)
        
    }
    
    func setLayout() {
        todayNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        seperateLine.snp.makeConstraints { make in
            make.top.equalTo(todayNavigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(seperateLine.snp.bottom).offset(53)
            make.leading.equalToSuperview().inset(20)
        }
        
        subTitleLable.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
        }
        
        pointImage.snp.makeConstraints { make in
            make.top.equalTo(subTitleLable.snp.top)
            make.leading.equalTo(subTitleLable.snp.trailing).offset(4)
            make.size.equalTo(10)
        }
        
        mainArticleView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLable.snp.bottom).offset(28)
            make.width.equalTo(ScreenUtils.getWidth(335))
            make.centerX.equalToSuperview()
            make.height.equalTo(mainArticleView.snp.width).multipliedBy(TodayArticleImage.ratio)
        }
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(articleTapped(_:)))
        mainArticleView.addGestureRecognizer(tapGesture)
    }

    func setButtonAction() {
        todayNavigationBar.rightFirstBarItemAction {
            let bookmarkViewController = BookmarkViewController()
            self.navigationController?.pushViewController(bookmarkViewController, animated: true)
        }
        
        todayNavigationBar.rightSecondBarItemAction {
            let myPageViewController = MyPageViewController()
            self.navigationController?.pushViewController(myPageViewController, animated: true)
        }
    }
    
    @objc func articleTapped(_ sender: UIButton) {
        let articleDetailViewController = ArticleDetailViewController()
        articleDetailViewController.setArticleId(id: self.todayArticleID)
        articleDetailViewController.isModalInPresentation = true
        articleDetailViewController.modalPresentationStyle = .overFullScreen
        self.present(articleDetailViewController, animated: true)
    }
}
