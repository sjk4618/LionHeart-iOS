//
//  CurriculumListByWeekViewController.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/14.
//  Copyright (c) 2023 CurriculumListByWeek. All rights reserved.
//

import UIKit

import SnapKit

final class CurriculumListByWeekViewController: UIViewController {
    
    var weekToIndexPathItem: Int = 0 {
        didSet {
            navigationBar.setCurriculumWeek(week: weekToIndexPathItem + 4)
        }
    }
    
    var listByWeekDatas: [ArticleDataByWeek] = [] {
        didSet {
            self.curriculumListByWeekCollectionView.reloadData()
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            let indexPath = IndexPath(item: currentPage, section: 0)
            self.curriculumListByWeekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
            self.navigationBar.setCurriculumWeek(week: currentPage + 4)
        }
    }
    
    private lazy var navigationBar: LHNavigationBarView = {
        let nav = LHNavigationBarView(type: .curriculumByWeek, viewController: self)
        nav.setCurriculumWeek(week: self.weekToIndexPathItem + 4)
        return nav
    }()
    
    private let curriculumListByWeekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .designSystem(.background)
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - 컴포넌트 설정
        setUI()
        
        // MARK: - addsubView
        setHierarchy()
        
        // MARK: - autolayout설정
        setLayout()
        
        // MARK: - delegate설정
        setDelegate()
        
        // MARK: - collectionView Register 설정
        setCollectionView()
        
        // MARK: - notificationCenter 설정
        setNotificationCenter()
        
        //api 연결할 때 구현
//        setDataBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListByWeekData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let indexPath = IndexPath(item: self.weekToIndexPathItem, section: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        LHNavigationBarView(type: .curriculumByWeek, viewController: self)
        self.curriculumListByWeekCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

private extension CurriculumListByWeekViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        self.navigationController?.isNavigationBarHidden = true
        view.addSubviews(navigationBar, curriculumListByWeekCollectionView)
        navigationBar.setCurriculumWeek(week: 1)
        
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        curriculumListByWeekCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.trailing.leading.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
    
    
    func setNotificationCenter() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(leftButtonTapped),
                                               name: NSNotification.Name("leftButton"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(rightButtonTapped),
                                               name: NSNotification.Name("rightButton"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(bookmarkButtonTapped), name: NSNotification.Name("isArticleBookmarked"), object: nil)
        
    }
    
    @objc
    func leftButtonTapped(notification: NSNotification) {
        let nextPage: Int = max(0,currentPage - 1)
        self.currentPage = nextPage
    }
    
    @objc
    func rightButtonTapped(notification: NSNotification) {
        let nextPage = min(listByWeekDatas.count - 1, currentPage + 1)
        self.currentPage = nextPage
        
    }
    
    @objc
    func bookmarkButtonTapped(notification: NSNotification) {
        guard let isBookmarkedRow = notification.object as? Int else { return }
        let isBookmarkedPage = currentPage
        
        listByWeekDatas[isBookmarkedRow].isArticleBookmarked.toggle()
        
//        listByWeekDatas[isBookmarkedPage].articleData[isBookmarkedRow].isArticleBookmarked.toggle()

    }
    
    func setDelegate() {
        
        curriculumListByWeekCollectionView.delegate = self
        curriculumListByWeekCollectionView.dataSource = self
        
    }
    
    func setCollectionView() {
        CurriculumListByWeekCollectionViewCell.register(to: curriculumListByWeekCollectionView)
    }
    
    //api호출 할 때 구현
//    func setDataBind() {
//        /// api호출
//        listByWeekDatas = CurriculumWeekData.dummy()
//        self.curriculumListByWeekCollectionView.reloadData()
//    }
}

extension CurriculumListByWeekViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CurriculumListByWeekCollectionViewCell.dequeueReusableCell(to: curriculumListByWeekCollectionView, indexPath: indexPath)
        
        cell.weekCount = self.weekToIndexPathItem
        cell.inputData = listByWeekDatas
        cell.selectedIndexPath = indexPath
        
        return cell
    }
}

extension CurriculumListByWeekViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension CurriculumListByWeekViewController: ViewControllerServiceable {
    
    func handleError(_ error: NetworkError) {
        switch error {
        case .unAuthorizedError:
            guard let window = self.view.window else { return }
            ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(), withAnimation: false)
        case .clientError(code: _, message: let message):
            LHToast.show(message: "\(message)")
        default:
            LHToast.show(message: error.description)
        }
    }
}

extension CurriculumListByWeekViewController {
    func getListByWeekData() {
        Task {
            do {
                let responseListByWeek = try await CurriculumService.shared.getArticleListByWeekInfo(week: 6)
                
                listByWeekDatas = responseListByWeek
                
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
        
    }
}
