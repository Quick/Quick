//
//  NimbleSpec.m
//  Nimble
//
//  Created by Brian Ivan Gesiak on 6/24/14.
//  Copyright (c) 2014 Brian Ivan Gesiak. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

static NSTimeInterval NimbleSpecTimeout = 0.01;

QuickSpecBegin(NimbleSpec)

qck_describe(@"expectations in Objective-C", ^{
    qck_describe(@"beNil", ^{
        qck_it(@"matches for nil values", ^{
            [nmb_expect(nil).to beNil];
            [nmb_expect(@"Joffrey Baratheon").notTo beNil];

            [nmb_expectBlock(^NSObject *{ return nil; }).will beNil];
            [nmb_expectBlock(^{ return @"Joffrey Baratheon"; }).willNot beNil];
        });
    });

    qck_describe(@"beTrue", ^{
        qck_it(@"matches for truthy values", ^{
            [nmb_expect(@YES).to beTrue];
            [nmb_expect(@NO).toNot beTrue];

            [[nmb_expectBlock(^{ return @YES; }) willBefore:NimbleSpecTimeout] beTrue];
            [[nmb_expectBlock(^{ return @NO; }) willNotBefore:NimbleSpecTimeout] beTrue];
        });
    });

    qck_describe(@"beFalse", ^{
        qck_it(@"matches for falsy values", ^{
            [nmb_expect(@NO).to beFalse];
            [nmb_expect(@YES).toNot beFalse];

            [[nmb_expectBlock(^{ return @NO; }) willBefore:NimbleSpecTimeout] beFalse];
            [[nmb_expectBlock(^{ return @YES; }) willNotBefore:NimbleSpecTimeout] beFalse];
        });
    });

    qck_describe(@"contain", ^{
        qck_it(@"matches for collections that contain the specified value", ^{
            [nmb_expect((@[@"one", @"two"])).to nmb_contain:@"one"];
            [nmb_expect((@[@"one", @"two"])).toNot nmb_contain:@"three"];

            [[nmb_expectBlock((^{ return @[@"one", @"two"]; })) willBefore:NimbleSpecTimeout] nmb_contain:@"one"];
            [[nmb_expectBlock((^{ return @[@"one", @"two"]; })) willNotBefore:NimbleSpecTimeout] nmb_contain:@"three"];
        });
    });

    qck_describe(@"equal", ^{
        qck_it(@"matches for equal values", ^{
            [nmb_expect(@"Lannister").to nmb_equal:@"Lannister"];
            [nmb_expect(@"Baratheon").toNot nmb_equal:@"Lannister"];

            [[nmb_expectBlock(^{ return @"Lannister"; }) willBefore:NimbleSpecTimeout] nmb_equal:@"Lannister"];
            [[nmb_expectBlock(^{ return @"Baratheon"; }) willNotBefore:NimbleSpecTimeout] nmb_equal:@"Lannister"];
        });
    });
});

QuickSpecEnd
