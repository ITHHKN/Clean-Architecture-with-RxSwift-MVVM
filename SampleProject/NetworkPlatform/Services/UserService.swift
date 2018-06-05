//
//  SocialMediaService.swift
//  SampleProject
//
//  Created by Hasnain on 4/4/18.
//  Copyright © 2018 Hasnain Haider. All rights reserved.
//

import RxSwift
import Foundation
import EVReflection


open class UserService : NSObject , NewsProtocols {
  
  //
  // Fetch user list 
  //
  
  func fetchUserList() -> Observable<userServiceResponse> {
    
    return Observable<userServiceResponse>.create { observer in
      
      BaseApiClient.baseApi.repository.fetch(url: APICommunicationURLs.getUserList(), response:userServiceResponse.self).asObservable()
        
        .subscribe(onNext: { baseObject in
          let  newsEntity = baseObject as! userServiceResponse
          observer.onNext(newsEntity)
          observer.on(.completed)
          
        })
      
      return Disposables.create() // useful when disposable mechanism is not necessary
    }
    
  }
}

//
// Response Model
//
open class userServiceResponse  : BaseResponseForModels {
  
  var payload = [User]()
  
  required public init() {}
}



