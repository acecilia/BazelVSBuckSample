#import <XCTest/XCTest.h>
#import "ObjcModule/ObjcModule.h"

@interface ObjcModuleTests: XCTestCase
@end

@implementation ObjcModuleTests
- (void)test {
  XCTAssertEqual(text, @"Hello, World!");
}
@end
