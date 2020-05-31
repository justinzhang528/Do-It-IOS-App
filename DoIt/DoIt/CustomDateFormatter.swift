//
//  CustomDateFormatter.swift
//  DoIt
//
//  Created by 張維俊 on 2020/5/30.
//  Copyright © 2020 NTUT. All rights reserved.
//

import Foundation

public class CustomDateFormatter {
    func Formatter(date: Date, format: String) -> String {
        let dataFormatter = DateFormatter() //實體化日期格式化物件
        dataFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dataFormatter.dateFormat = format //參照ISO8601的規則
        let stringDate = dataFormatter.string(from: date)
        return stringDate
    }
}
