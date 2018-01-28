//
//  ViewController.swift
//  Slippery
//
//  Created by shawnbaek on 01/26/2018.
//  Copyright (c) 2018 shawnbaek. All rights reserved.
//

import UIKit
import Slippery

class CalendarVC: UIViewController {

    @IBOutlet weak var calendarView: UICollectionView!
    private var collectionViewLayout: SlipperyFlowLayout!
    @IBOutlet weak var calendarLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    
    var focusedItem = Int() {
        didSet {
            itemLabel.text = "Focused Item is : \(focusedItem)"
        }
    }
    
    //CollectionView's Data
    let f = DateFormatter()
    var dateArray = NSArray()
    var weekDayArray = NSArray()
    
    var calendarString = String() {
        didSet {
            calendarLabel.text = calendarString
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        //get past one month's calendars and reversed array
        dateArray = getPastDates(days: 30).reversed() as NSArray
        weekDayArray = dateArray.value(forKey: "weekDay") as! NSArray
        
        setupCollectionView()
        scrollToItem(item: 20, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.layoutIfNeeded()
    }
   
    
    func getPastDates(days: Int) -> NSMutableArray {
        
        let dates = NSMutableArray()
        let calendar = Calendar.current
        let f = DateFormatter()
        var tomorrow = calendar.startOfDay(for: Date().tomorrow)
    
        for _ in 1 ... days {
            
            let day = calendar.component(.day, from: tomorrow)
            let month = calendar.component(.month, from: tomorrow)
            let year = calendar.component(.year, from: tomorrow)
            let week = calendar.component(.weekday, from: tomorrow)
            
            let dateComponent = Date.from(year, month, day)
            let weekDay = f.shortWeekdaySymbols[Calendar.current.component(.weekday, from: dateComponent!) - 1]
            let date = NSMutableDictionary()
            
            date.setValue(day, forKey: "day")
            date.setValue(month, forKey: "month")
            date.setValue(year, forKey: "year")
            date.setValue(week, forKey: "week")
            date.setValue(weekDay, forKey: "weekDay")
            
            dates.add(date)
            tomorrow = calendar.date(byAdding: .day, value: -1, to: tomorrow)!
        }
        
        return dates
        
    }

}
extension CalendarVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var intialOffset: CGFloat {
        return self.collectionViewLayout.initialOffset
        
    }
    
    
    func scrollToItem(item: Int, animated: Bool) {

        let itemOffset = self.collectionViewLayout.updateOffset(item: item)
        self.calendarView.setContentOffset(CGPoint(x: itemOffset, y: 0), animated: true)
        self.calendarView.layoutIfNeeded()

    }
    
    func setupCollectionView(){
        
        self.collectionViewLayout = SlipperyFlowLayout.configureLayout(collectionView: self.calendarView, itemSize: CGSize(width: 120, height: 180), minimumLineSpacing: 10, highlightOption: .center(.cropping))
        self.collectionViewLayout.scaleItems = true
        self.collectionViewLayout.invalidateLayout()
        self.calendarView.layoutIfNeeded()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumberCell", for: indexPath) as! NumberCell
        
        let object = dateArray.object(at: indexPath.row)
        let day = String(describing: (object as AnyObject).value(forKey: "day")!)
        let weekDay = String(describing: (object as AnyObject).value(forKey: "weekDay")!)
        
        if weekDay == "Sun" {
            cell.number.textColor = .red
        }else {
            cell.number.textColor = .black
        }
        
        cell.number.text = day
        
        return cell
        
    }
    
}

extension CalendarVC: UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollview: UIScrollView){

        guard collectionViewLayout != nil else { return }

        let itemPage = collectionViewLayout.itemSize.width + collectionViewLayout.minimumLineSpacing

        let page = Int((scrollview.contentOffset.x + scrollview.contentInset.left + ((itemPage) / 2 ) + intialOffset) / (itemPage))
        guard page < dateArray.count else { return }
        let currentObject = dateArray.object(at: page)
        let month = (currentObject as AnyObject).value(forKey: "month")! as! Int
        let monthString = f.shortMonthSymbols[month-1].uppercased()
        
        focusedItem = page
        calendarString = "\(monthString) \((currentObject as AnyObject).value(forKey: "year")!)"

    }
    
}

