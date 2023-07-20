//
//  ArticleListByCategoryViewController.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/09.
//  Copyright (c) 2023 ArticleListByCategory. All rights reserved.
//

import UIKit

import SnapKit

final class ArticleListByCategoryViewController: UIViewController {
    
    var categoryString = String()
    var articleListData = [ArticleListByCategoryAppData]()

    private lazy var navigationBar = LHNavigationBarView(type: .exploreEachCategory, viewController: self)
    
    private let articleListTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .designSystem(.background)
        let view = ArticleListByCategoryHeaderView()
        view.frame = CGRect(x: 0, y: 0, width: Constant.Screen.width, height: 192)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = view
        return tableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        setHierarchy()
        
        setLayout()
        
        setAddTarget()
        
        setDelegate()
        
        setTableView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            do {
                self.articleListData = try await ArticleService.shared.getArticleListByCategory(categoryString: categoryString)
                self.articleListTableView.reloadData()
            } catch {
                guard let error = error as? NetworkError else { return }
                handleError(error)
            }
        }
    }
}

private extension ArticleListByCategoryViewController {
    func setUI() {
        view.backgroundColor = .designSystem(.background)
    }
    
    func setHierarchy() {
        view.addSubviews(navigationBar, articleListTableView)
    }
    
    func setLayout() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        articleListTableView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setAddTarget() {
        
    }
    
    func setDelegate() {
        articleListTableView.dataSource = self
        articleListTableView.delegate = self
    }
    
    func setTableView() {
        CurriculumArticleByWeekTableViewCell.register(to: articleListTableView)
    }
}

extension ArticleListByCategoryViewController: ViewControllerServiceable {
    func handleError(_ error: NetworkError) {
        switch error {
        case .urlEncodingError:
            LHToast.show(message: "URL Error")
        case .jsonDecodingError:
            LHToast.show(message: "Decoding Error")
        case .badCasting:
            LHToast.show(message: "Bad Casting")
        case .fetchImageError:
            LHToast.show(message: "Image Error")
        case .unAuthorizedError:
            guard let window = self.view.window else { return }
            ViewControllerUtil.setRootViewController(window: window, viewController: SplashViewController(), withAnimation: false)
        case .clientError(_, _):
            print("뜨면 위험함")
        case .serverError:
            LHToast.show(message: "승준이 빠따")
        }
    }
}

extension ArticleListByCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CurriculumArticleByWeekTableViewCell.dequeueReusableCell(to: articleListTableView)
        cell.inputData = articleListData[indexPath.item]
        cell.backgroundColor = .designSystem(.background)
        return cell
    }
}

extension ArticleListByCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 326
    }
}
