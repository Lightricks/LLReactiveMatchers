// Copyright (c) 2015 Lightricks. All rights reserved.
// Created by Barak Yoresh.

#import "EXPMatchers+deliverValuesOnThread.h"

#import <Expecta/NSValue+Expecta.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "LLReactiveMatchersHelpers.h"

EXPMatcherImplementationBegin(deliverValuesOnThread, (NSThread *expected)) {
  __block NSString *prerequisiteErrorMessage;
  __block LLSignalTestRecorder *actualRecorder = nil;
  
  void (^subscribe)() = ^{
    if(!actualRecorder) {
      actualRecorder = LLRMRecorderForObject(actual);
    }
  };
  
  prerequisite(^BOOL{
    if (!expected) {
      prerequisiteErrorMessage = @"Expected thread is nil";
    }
    if (![expected isKindOfClass:[NSThread class]] && expected != nil) {
      prerequisiteErrorMessage = [NSString stringWithFormat:@"Expected thread %@ is not NSThread",
                                  expected];
    }
    return !prerequisiteErrorMessage;
  });
  
  match(^BOOL{
    subscribe();
    
    return [[actualRecorder operatingThreads] containsObject:expected];
  });
  
  failureMessageForTo(^NSString *{
    if (prerequisiteErrorMessage) {
      return prerequisiteErrorMessage;
    }
    if ([actualRecorder operatingThreadsCount]) {
      return [NSString stringWithFormat:@"First failure: expected values to be delivered on thread "
              "%@ but %@ were delivered on threads %@", expected, [actualRecorder values],
              [actualRecorder operatingThreads]];
    } else {
      return [NSString stringWithFormat:@"First failure: expected values to be delivered on thread "
              "%@ but no values were delivered.", expected];
    }
  });
  
  failureMessageForNotTo(^NSString *{
    if (prerequisiteErrorMessage) {
      return prerequisiteErrorMessage;
    }
    return [NSString stringWithFormat:@"First failure: expected values to not be delivered on "
            "thread %@ but %@ were delivered on threads %@", expected, [actualRecorder values],
            [actualRecorder operatingThreads]];
  });
}

EXPMatcherImplementationEnd
