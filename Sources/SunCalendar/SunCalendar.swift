#if os(iOS) || os(tvOS)
import UIKit
#else
import AppKit
#endif

public typealias SCL = SunCalendar

public final class SunCalendar: NSObject {
    public static let shared = SunCalendar()
    private var cellHeight: Double = 0
    private var cellWidth: Double = 0
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    
    
    private lazy var calendarView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        let cellNib = UINib(nibName: "SunCalendarViewCell", bundle: nil)
//        collectionView.register(cellNib, forCellWithReuseIdentifier: "SunCalendarViewCell")
        collectionView.register(SunCalendarViewCell.self, forCellWithReuseIdentifier: "SunCalendarViewCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .none
        return collectionView
    }()
    
    
    override init() {
        super.init()
    }
    
    public func makeCalendar(_ view: UIView) {
        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        
//        let cellNib = UINib(nibName: "SunCalendarViewCell", bundle: nil)
//        self.calendarView.register(cellNib, forCellWithReuseIdentifier: "SunCalendarViewCell")
        
        self.cellHeight = view.frame.height / 6
        self.cellWidth = view.frame.width / 7
        
        print(view.frame.height)
        print(view.frame.width)
        
        view.addSubview(self.calendarView)
        [
            calendarView.topAnchor.constraint(equalTo: view.topAnchor),
            calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].forEach {
            $0.isActive = true
        }
    }
    
    
}

extension SunCalendar: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SunCalendarViewCell", for: indexPath) as? SunCalendarViewCell else { return SunCalendarViewCell() }
        
        if indexPath.item%3 == 0 {
            cell.backgroundColor = .red
        } else if indexPath.item%3 == 1 {
            cell.backgroundColor = .blue
        } else if indexPath.item%3 == 2{
            cell.backgroundColor = .green
        } else {
            cell.backgroundColor = .gray
        }
        
        let borderCheck = self.cellWidth > self.cellHeight ? self.cellWidth : self.cellHeight
        
        cell.layer.cornerRadius = borderCheck / 2
//        print(cell.dayText.text ?? "return")
//        print(cell.dayText.text!)
//        cell.backView?.layer.cornerRadius = borderCheck/2
//        collectionView.reloadData()
        cell.check = indexPath.item
        
        return cell
        
//        guard let cell: SunCalendarViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SunCalendarViewCell", for: indexPath) as? SunCalendarViewCell else {
//                   return UICollectionViewCell()
//               }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        42
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }
    
}



extension Date {
    var year: Int {
        let cal = Calendar.current
        return cal.component(.year, from: self)
    }
    
    var month: Int {
        let cal = Calendar.current
        return cal.component(.month, from: self)
    }
    
    var day: Int {
        let cal = Calendar.current
        return cal.component(.day, from: self)
    }
}


