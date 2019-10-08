#import <XCTest/XCTest.h>
#import "ObjcModule/ObjcModule.h"

@interface Tests: XCTestCase
@end

@implementation Tests
- (void)test {
  XCTAssertEqual(text, @"Hello, World!");
}
@end
