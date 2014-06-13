//
//  PendindTests+ObjC.m
//  Quick
//
//  Created by Tiago Bastos on 6/13/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import <Quick/Quick.h>

QuickSpecBegin(PendingTestsObjC)

qck_describe(@"contains a pending block", ^{
    qck_pending(@"contains an it block", ^{
        qck_it(@"fails", ^{
            XCTAssertTrue(false, @"expected to be true");
        });
    });
});

QuickSpecEnd
