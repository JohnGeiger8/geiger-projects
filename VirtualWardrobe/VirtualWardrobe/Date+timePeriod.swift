//
//  Date+timePeriod.swift
//  VirtualWardrobe
//
//  Created by John Geiger on 12/15/19.
//  Copyright © 2019 John Geiger. All rights reserved.
//

import Foundation

extension Date {
    func firstDayOf(dateComponent: Calendar.Component) -> Date {
        
        let calendar = Calendar.current
        switch dateComponent {
        case .year:
            let firstDay = calendar.date(from: calendar.dateComponents([.year], from: self))
            return firstDay!
    
        case .month:
            let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: self))
            return firstDay!

        case .weekOfYear:
            let firstDay = calendar.date(from: calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self))
            return firstDay!
            
        default:
            return Date()
        }
    }
    
    func lastDayOf(dateComponent: Calendar.Component) -> Date {
        let firstDay = firstDayOf(dateComponent: dateComponent)
        var lastDay = Calendar.current.date(byAdding: dateComponent, value: 1, to: firstDay) // Add one of specified component
        lastDay = Calendar.current.date(byAdding: .day, value: -1, to: lastDay!) // Subtract day
        return lastDay!
    }
    
    func textFromComponent(component: Calendar.Component) -> String {
        
        switch component {
        case .year:
            let year = Calendar.current.component(.year, from: self)
            return String(year)
            
        case .month:
            let monthNumber = Calendar.current.component(.month, from: self)
            var month = "Jan"
            switch monthNumber {
            case 1:
                month = "Jan"
            case 2:
                month = "Feb"
            case 3:
                month = "Mar"
            case 4:
                month = "Apr"
            case 5:
                month = "May"
            case 6:
                month = "June"
            case 7:
                month = "July"
            case 8:
                month = "Aug"
            case 9:
                month = "Sep"
            case 10:
                month = "Oct"
            case 11:
                month = "Nov"
            case 12:
                month = "Dec"
            default:
                break
            }
            return month
            
        case .weekOfYear:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            
            // Give string representation of the week starting on this date
            let oneWeekFromNow = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: self)!
            let week = dateFormatter.string(from: self) + " - \n" + dateFormatter.string(from: oneWeekFromNow)
            return week
            
        default:
            break
        }
       
        return ""
    }
}
