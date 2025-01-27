//
//  CurriculumViewService.swift
//  LionHeart-iOS
//
//  Created by 곽성준 on 2023/07/18.
//

import UIKit

final class CurriculumService: Serviceable {
    
    static let shared = CurriculumService()
    
    private init() {}
    
    func getCurriculumServiceInfo() async throws -> UserInfoData {
        let urlRequest = try NetworkRequest(path: "/v1/curriculum/progress", httpMethod: .get).makeURLRequest(isLogined: true)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: CurriculumResponse.self) else { return UserInfoData.emptyUserInfoData }
        
        return UserInfoData(userWeekInfo: model.week, userDayInfo: model.day, progress: model.progress + 1, remainingDay: model.remainingDay)
    }
    
    func getArticleListByWeekInfo(week: Int) async throws -> CurriculumWeekData {
        let urlRequest = try NetworkRequest(path: "v1/article/week/\(week)", httpMethod: .get).makeURLRequest(isLogined: true)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        guard let model = try dataDecodeAndhandleErrorCode(data: data, decodeType: CurriculumListByWeekResponse.self) else {
            return .init(articleData: [], week: 0)
        }

        return model.toAppData()
    }
}
