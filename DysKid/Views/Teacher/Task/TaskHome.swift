//
//  TaskHome.swift
//  DysKid
//
//  Created by Mehmet Ali Bunsuz on 26.09.2024.
//

import SwiftUI

struct TaskHome: View {
    
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    @State private var createNewTask: Bool = false
    // animation namespace
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing:0, content: {
            //Header
            HeaderView()
                
            ScrollView(.vertical) {
                VStack {
                    //tasks view
                    TasksView(currentDate: $currentDate)
                }
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        })
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button {
                createNewTask.toggle()
            } label: {
                Image(systemName: "plus")
                    .font(.custom(outfitRegular, size: 16))
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(Color("ColorSecondaryBlack").shadow(.drop(color: Color("ColorSecondaryBlack").opacity(0.25), radius: 5,x: 10, y: 10)), in: .circle)
            }
            .padding(15)
        })
        .onAppear {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                    
                }
                
            }
        }
        .sheet(isPresented: $createNewTask) {
            NewTaskView()
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.white)
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View{
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate.format("MMMM"))

                Text(currentDate.format("YYYY"))

            }
            .font(.custom(outfitLight, size: 36))
            .foregroundStyle(Color("ColorSecondaryBlack"))
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.custom(outfitRegular, size: 16))
                .foregroundStyle(.gray)
            // week slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    weekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                    
                    
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
            
        }
        .hSpacing(.leading)
        .padding(15)
        .background(Color("ColorPrimaryWhite"))
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
        
    }
    //week view
    @ViewBuilder
    func weekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 9) {
                    Text(day.date.format("E"))
                        .font(.custom(outfitRegular, size: 14))
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.custom(outfitMedium, size: 14))
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(Color("ColorSecondaryBlack"))
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            // indicator to shaw, which is todays date
                            if day.date.isToday {
                                Circle()
                                    .fill()
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y:12)
                            }
                        })
                        .background(Color("ColorPrimaryWhite") .shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background{
            GeometryReader{
                let minX  = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    func paginateWeek() {
        
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                // inserting new week at 0th index and removing last array item
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                // inserting new week at last index and removing first array item

                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
         }
        }
    }
}

#Preview {
    ContentView()
}
