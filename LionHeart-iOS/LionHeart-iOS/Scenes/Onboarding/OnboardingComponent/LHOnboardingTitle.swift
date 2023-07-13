//
//  LHOnboardingTitle.swift
//  LionHeart-iOS
//
//  Created by uiskim on 2023/07/13.
//

import UIKit

final class LHOnboardingTitle: UILabel {
    
    private let content: String
    
    init(_ content: String) {
        self.content = content
        super.init(frame: .zero)
        self.font = .pretendard(.head2)
        self.textColor = .designSystem(.white)
        self.numberOfLines = 2
        self.text = self.content
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

