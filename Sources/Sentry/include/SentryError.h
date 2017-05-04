//
//  SentryError.h
//  Sentry
//
//  Created by Daniel Griesser on 03/05/2017.
//  Copyright © 2017 Sentry. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Sentry/SentryDefines.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SentryError) {
    kUnknownError = -1,
    kInvalidDSNError = 100,
    kInvalidCrashReportError = 101
};

SENTRY_EXTERN NSError *_Nullable NSErrorFromSentryError(SentryError error, NSString *description);

SENTRY_EXTERN NSString *const SentryErrorDomain;

NS_ASSUME_NONNULL_END