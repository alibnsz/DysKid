//
//  TasksView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 26.09.2024.
//

import SwiftUI
import SwiftData

struct TasksView: View {
    @Binding var currentDate : Date
    //SwiftData Dynamic Query
    @Query private var tasks: [Task]
    init(currentDate: Binding<Date>) {
        self._currentDate = currentDate
        // predicate
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: currentDate.wrappedValue)
        let endOfDate = calendar.date(byAdding: .day, value: 1, to: startOfDate)!
        let predicate = #Predicate<Task> {
            return $0.creationDate >= startOfDate && $0.creationDate < endOfDate
        }
        //sorting
        let sortDescriptor = [
            SortDescriptor(\Task.creationDate, order: .reverse)
        ]
        
        self._tasks = Query(filter: predicate, sort: sortDescriptor, animation: .snappy)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 35) {
            ForEach(tasks) { task in
                TaskRowView(task: task)
                    .background(alignment: .leading) {
                        if tasks.last?.id != task.id {
                            Rectangle()
                                .frame(width: 1)
                                .offset(x:8)
                                .padding(.bottom, -35)
                        }
                    }
            }
        }
        .padding([.vertical, .leading], 35)
        .padding(.top, 15)
        .overlay {
            if tasks.isEmpty {                    
            }
        }
    }
}

#Preview {
    TaskHome()
}
