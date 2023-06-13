//
//  SunCalendarViewCell.swift
//  
//
//  Created by TAnine on 2023/06/05.
//

import UIKit

class SunCalendarViewCell: UICollectionViewCell {
    var check: Int = 0
    
    private lazy var label: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
//    static let reuseIdentifier = "SunCalendarViewCell"
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        print("open")
//        print("1")
//        self.backView.backgroundColor = .red
        // Initialization code
//        self.layout()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("1")
        self.layout()
//        self.dayText.text = "\(check)"
    }
//
    required init?(coder: NSCoder) {
        fatalError("ERROR init(coder:)")
    }
    
    
    private func layout() {
//        self.backView.backgroundColor = .black
        [
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//            label.topAnchor.constraint(equalTo: view.topAnchor),
//            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ].forEach {
            $0.isActive = true
        }
    }

}
