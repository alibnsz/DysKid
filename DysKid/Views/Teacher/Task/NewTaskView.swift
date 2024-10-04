//
//  NewTaskView.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 26.09.2024.
//

import SwiftUI

struct NewTaskView: View {
    
    @Environment(\.dismiss) private var dismiss
    //Model context for saving data
    @Environment(\.modelContext) private var context
    @State private var taskTitle: String = ""
    @State private var taskDate: Date = .init()
    @State private var taskColor: String = "TaskColor1"
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .tint(.red)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Task Color")
                    .font(.caption)
                    .foregroundStyle(.gray)
                TextField("Go For a Walk!", text: $taskTitle)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .background(.white.shadow(.drop(color: .black.opacity(0.25),radius: 2)), in: .rect(cornerRadius: 10))
                    .foregroundColor(.black)
                    
            }
            .hSpacing(.leading)
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Color")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    
                    let colors: [String] = (1...5).compactMap { index -> String in
                        
                        return "TaskColor\(index)"
                    }
                    
                    HStack(spacing: 0) {
                        ForEach(colors, id: \.self) { color in
                            Circle()
                                .fill(Color(color))
                                .frame(width: 20, height: 30)
                                .background(content: {
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .opacity(taskColor == color ? 1 : 0)
                                })
                                .hSpacing(.center)
                                .contentShape(.rect)
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        taskColor = color
                                    }
                                }
                        }
                    }
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Task Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    DatePicker("", selection: $taskDate)
                        .datePickerStyle(.compact)
                        .scaleEffect(0.9, anchor: .leading)
                        
                }

                .padding(.trailing, -15)
            }
            .padding(.top,5)
            Spacer(minLength: 0)

            Button(action: {
                let task = Task(taskTitle: taskTitle,tint: taskColor, creationDate: taskDate)
                do {
                    context.insert(task)
                    try context.save()
                    // after succesfull task creation dismissing the view
                    dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Text("Add Task")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textScale(.secondary)
                    .foregroundStyle(.white)
                    .hSpacing(.center)
                    .padding(.vertical)
                    .background(Color("ColorSecondaryBlack"), in: .rect(cornerRadius: 10))
            })
            .disabled(taskTitle == "" )
            .opacity(taskTitle == "" ? 0.5 : 1)
        }
        .padding(15)
    }
}

#Preview {
    NewTaskView()
        .vSpacing(.bottom)
}
