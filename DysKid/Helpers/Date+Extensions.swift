//
//  Date+Extensions.swift
//  Dyskid
//
//  Created by Mehmet Ali Bunsuz on 26.09.2024.
//

import SwiftUI

extension Date {
    /// Custom Date Format
    
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    //checking whether the date is today
    
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    //checking if the date is Same Hour
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(),toGranularity: .hour) == .orderedSame
    }
    
    //checking if the date is Same Hour
    var isPast: Bool {
        return Calendar.current.compare(self, to: .init(),toGranularity: .hour) == .orderedAscending
    }
    
    // fetching week based on given Date
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
            
        }
        
        return week
    }
    
    // creating next week, based on the last current weeks date
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        return fetchWeek(nextDate)
    }
    
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        return fetchWeek(previousDate)
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}
