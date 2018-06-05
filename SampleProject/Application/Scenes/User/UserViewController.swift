//
//  UserViewController.swift
//  SampleProject
//
//  Created by Hasnain on 4/4/18.
//  Copyright © 2018 Hasnain Haider. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class UserViewController: BaseViewController{
  
  //
  // Mark -- Properties
  //
  @IBOutlet weak var tableView: UITableView!

  // Dispose Bag
  var disposeBag = DisposeBag()
  var tasks :Variable<[User]> = Variable([])
  
  
  //
  //Mark -- View model 
  //
  lazy var viewModel: UserViewModel = {
    return UserViewModel()
  }()

  //
  // Mark -- View Life Cycle
  //
  override  func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override  func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
    bindViewModel()
    bindTableView()
    
    viewModel.initFetch() // "Fetch News api call"
    
  }
  
  private func configureTableView(){
    
    self.tableView.delegate = nil
    self.tableView.dataSource = nil
    
    self.tableView.estimatedRowHeight = 100
    self.tableView.rowHeight = UITableViewAutomaticDimension
    self.tableView.register(UINib(nibName: "UserTableViewCell",bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
    
  }
  
  private func bindViewModel(){
    
    viewModel.didReceivedResponse.asObserver().bind {  (result) in
      self.tasks.value.append(contentsOf: result.payload)
      }.disposed(by: disposeBag)
    
  }
  
  private func bindTableView() {
    tasks.asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: "UserTableViewCell", cellType: UserTableViewCell.self)) { row, element, cell in
        cell.fill(entity: element, IndextPathRow: row)
      }.disposed(by: disposeBag)
  }
}



