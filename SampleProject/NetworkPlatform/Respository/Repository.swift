//
//  Repository.swift
//  SampleProject
//
//  Created by Hasnain on 4/23/18.
//  Copyright © 2018 Hasnain Haider. All rights reserved.
//

import RxSwift
import Foundation
import EVReflection
import Alamofire


open class Repository : BaseRepository {
  
  typealias T = BaseResponseForModels
  
  func fetch<T>(url: String, paramsIfAny: [String : String] = ["":""], authenticationType: AuthenticationType = .Normal , response: T.Type) -> Observable<BaseResponseForModels> where T : BaseResponseForModels {
    
    return Observable<BaseResponseForModels>.create { observer in
      
      var baseResponse = BaseResponseForModels()

      BaseApiClient.baseApi.apiCommunication.manager?.request(
        url,
        method :.get,
        parameters: paramsIfAny,
        encoding: URLEncoding.default,
        headers: nil
        )
        .responseString(completionHandler: { (dataResponse: DataResponse<String>) in
          
          guard let response = dataResponse.response else {
            // invalid response
            return
          }
          
          guard let responseString = dataResponse.result.value else {
            //nil value
            return
          }
          
          AppHelper.appDelegate.SampleProjectLog.debug(String(format: "URL ----> %@\n", url))
          AppHelper.appDelegate.SampleProjectLog.debug(String(format: "result ----> %@\n", dataResponse.result.value!))
          AppHelper.appDelegate.SampleProjectLog.severe(String(format: "response.statusCode ----> %i\n", response.statusCode))
          
          let statusCode = response.statusCode
          var successCall = false
          
          switch statusCode {
          case HttpStatusCode.Http200_OK.rawValue ... (HttpStatusCode.Http300_MultipleChoices.rawValue - 1):
            successCall = true
            break
          default:
            successCall = false
            break
          }
          
          var apiBaseResponse: APIBaseResponse?
          apiBaseResponse = APIBaseResponse.init(response: responseString, statusCode: statusCode, success: successCall)
          
          if !apiBaseResponse!.handleErrorsIfAny(response: apiBaseResponse) {
            
            EVReflection.setBundleIdentifier(BaseResponseForModels.self)
            baseResponse = T(json: apiBaseResponse?.responseString)
            
          }
          
          observer.onNext(baseResponse) // send respone to listner
          observer.on(.completed) // completed the response as completed
          
        })
      return Disposables.create {}
    }
  }
}

