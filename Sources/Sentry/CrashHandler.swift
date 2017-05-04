//
//  CrashHandler.swift
//  Sentry
//
//  Created by Josh Holtz on 1/13/16.
//
//

import Foundation

public protocol CrashHandler: EventProperties {
    
    init(client: SentryClient)
    
    var breadcrumbsSerialized: BreadcrumbStore.SerializedType? { get set }
    func startCrashReporting()
    func sendAllReports()
}