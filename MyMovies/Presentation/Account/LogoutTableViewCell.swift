//
//  LogoutTableViewCell.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class LogoutTableViewCell: UITableViewCell {
  
  public static let identifier = "LogoutTableViewCell"
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  private func setupUI() {
    textLabel?.text = "Sign out"
    textLabel?.textAlignment = .center
    textLabel?.textColor = .red
  }
}
