//
//  Task.swift
//  Dyskid
//
//  Created by Mehmet Ali Bunsuz on 26.09.2024.
//

import SwiftUI
import SwiftData

@Model
class Task: Identifiable {
    var id: UUID
    var taskTitle: String
    var creationDate: Date
    var isCompleted: Bool
    var tint: String
    
    init(taskTitle: String, tint: String, isCompleted: Bool = false, creationDate: Date = .init(), id: UUID = .init()) {
        self.taskTitle = taskTitle
        self.creationDate = creationDate
        self.isCompleted = isCompleted
        self.tint = tint
        self.id = id
    }
    
    var tintColor: Color {
        switch tint {
        case "TaskColor1":
            return .taskColor1
        case "TaskColor2":
            return .taskColor2
        case "TaskColor3":
            return .taskColor3
        case "TaskColor4":
            return .taskColor4
        case "TaskColor5":
            return .taskColor5
        default:
            return .black
        }
    }
}

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: Date()) ?? Date()
    }
}

