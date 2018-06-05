//
//  UserViewModel.swift
//  SampleProject
//
//  Created by Hasnain on 4/10/18.
//  Copyright © 2018 Hasnain Haider. All rights reserved.
//

import RxSwift
import Foundation

final class UserViewModel  {
  
  //
  // Dispose Bag
  //
  var disposeBag = DisposeBag()
  
  //
  // Publish observers
  //
  let didReceivedResponse = PublishSubject<userServiceResponse>()
  
  //
  // server api call 
  //
  func initFetch() {
    
    BaseApiClient.baseApi.userService.fetchUserList().asObservable()
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { usersList in
        self.didReceivedResponse.onNext(usersList) // after success response pass user list to view
      }).disposed(by: disposeBag)
  }
  
}
