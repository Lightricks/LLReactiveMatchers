#import "EXPMatchers+matchValue.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface EXPMatchers_matchValueTests : TEST_SUPERCLASS
@end

@implementation EXPMatchers_matchValueTests

- (void) test_nonSignalActual {
    NSArray *actual = @[@1, @2, @3];
    
    assertFail(test_expect(actual).to.matchValue(0, ^(id value){
        return YES;
    }), @"Actual (1, 2, 3) is not a Signal");
    
    assertFail(test_expect(actual).toNot.matchValue(0, ^(id value){
        return YES;
    }), @"Actual (1, 2, 3) is not a Signal");
}

- (void) test_emptySignal {
    RACSignal *actual = RACSignal.empty;
    
    assertPass(test_expect(actual).toNot.matchValue(0, ^(id value){
        return NO;
    }));
    
    assertFail(test_expect(actual).to.matchValue(0, ^(id value){
        return NO;
    }), @"Could not match value at index 0, as only 0 values sent");
}

- (void) test_matchIndexToDamnHigh {
    RACSignal *actual = [LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]];
    
    assertPass(test_expect(actual).toNot.matchValue(10, ^(id value){
        return NO;
    }));
    
    assertFail(test_expect(actual).to.matchValue(10, ^(id value){
        return NO;
    }), @"Could not match value at index 10, as only 4 values sent");
}

- (void) test_matchPassIndex {
    RACSignal *actual = [LLReactiveMatchersFixtures values:@[@0, @1, @2, @3]];
    
    assertPass(test_expect(actual).to.matchValue(2, ^(id value){
        assertEqualObjects(@2, value);
        return YES;
    }));
    
    assertFail(test_expect(actual).toNot.matchValue(2, ^(id value){
        assertEqualObjects(@2, value);
        return YES;
    }), @"Match succeeded at index 2");
}


@end
