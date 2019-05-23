//
//  ViewController.swift
//  iOSCalendarTutorial
//
//  Created by 夏新凯 on 2019/5/23.
//  Copyright © 2019 夏新凯. All rights reserved.
//

import UIKit
import EventKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // 1
        let eventStore = EKEventStore()
        
        // 2
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            insertEvent(store: eventStore)
        case .denied:
            print("Access denied")
        case .notDetermined:
            // 3
            eventStore.requestAccess(to: .event, completion:
                {[weak self] (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self!.insertEvent(store: eventStore)
                    } else {
                        print("Access denied")
                    }
            })
        default:
            print("Case default")
        }
    }
    
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendars(for: .event)
        
        for calendar in calendars {
            // 2
            if calendar.title == "ioscreator" {
                // 3
                let startDate = Date()
                // 2 hours
                let endDate = startDate.addingTimeInterval(2 * 60 * 60)
                
                // 4
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = "New Meeting"
                event.startDate = startDate
                event.endDate = endDate
                
                // 5
                do {
                    try store.save(event, span: .thisEvent)
                }
                catch {
                    print("Error saving event in calendar")
                    
                }
                
                // 获取所有的事件（前后1天）
                let startDate2 = Date().addingTimeInterval(-3600*24*1)
                let endDate2 = Date().addingTimeInterval(3600*24*1)
                let predicate2 = store.predicateForEvents(withStart: startDate2,
                                                               end: endDate2, calendars: nil)
                
                print("查询范围 开始:\(startDate2) 结束:\(endDate2)")
                
                if let eV = store.events(matching: predicate2) as [EKEvent]? {
                    for i in eV {
                        print("eventIdentifier \(i.eventIdentifier!)" )
                        print("eventIdentifier count \(i.eventIdentifier.count)" )
                        print("calendarItemIdentifier \(i.calendarItemIdentifier)" )
                        print("calendarItemIdentifier count \(i.calendarItemIdentifier.count)" )
                        print("calendarItemExternalIdentifier \(i.calendarItemExternalIdentifier!)" )
                        print("calendarItemExternalIdentifier count \(i.calendarItemExternalIdentifier.count)" )
                        print("标题  \(i.title!)" )
                        print("开始时间: \(i.startDate!)" )
                        print("结束时间: \(i.endDate!)" )
                    }
                }
            }
        }
    }
}
