#import "EXPMatchers+sendValues.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LLReactiveMatchersMessageBuilder.h"
#import "LLReactiveMatchersHelpers.h"
#import "LLSignalTestRecorder.h"

EXPMatcherImplementationBegin(sendValues, (NSArray *expected))

__block LLSignalTestRecorder *actualRecorder = nil;
__block LLSignalTestRecorder *expectedRecorder = nil;

void (^subscribe)(void) = ^{
    if(!actualRecorder) {
        actualRecorder = LLRMRecorderForObject(actual);
    }
    if(!expectedRecorder) {
        expectedRecorder = LLRMRecorderForObject(expected);
    }
};

prerequisite(^BOOL{
    return LLRMCorrectClassesForActual(actual) && LLRMCorrectClassesForValues(expected);
});

match(^BOOL{
    subscribe();
    return LLRMContainsAllValuesEqual(actualRecorder, expectedRecorder);
});

failureMessageForTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    if(!LLRMCorrectClassesForValues(expected)) {
      return [LLReactiveMatchersMessageBuilder expectedShouldBeOfClass:NSArray.class];
    }

    return [[[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] renderActualValues] expected:expectedRecorder] renderExpectedValues] build];
});

failureMessageForNotTo(^NSString *{
    if(!LLRMCorrectClassesForActual(actual)) {
        return [LLReactiveMatchersMessageBuilder actualNotCorrectClass:actual];
    }
    
    return [[[[[[[LLReactiveMatchersMessageBuilder message] actual:actualRecorder] renderActualValues] expected:expectedRecorder] renderExpectedValues] renderExpectedNot] build];
});

EXPMatcherImplementationEnd
