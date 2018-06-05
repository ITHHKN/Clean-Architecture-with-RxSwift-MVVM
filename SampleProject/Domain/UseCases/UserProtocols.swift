//
//  NewsProtocols.swift
//  SampleProject
//
//  Created by Hasnain on 4/4/18.
//  Copyright © 2018 Hasnain Haider. All rights reserved.
//

import RxSwift
import Foundation

protocol NewsProtocols {
  
  //
  // Fetch user list from api protocol
  //
  
    func fetchUserList() -> Observable<userServiceResponse>
}
