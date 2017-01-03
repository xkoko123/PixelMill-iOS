//
//  AYPaint.m
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import "AYPaint.h"

@implementation AYPaint


- (instancetype)initWithID:(NSInteger)pid Image:(NSString*)image describe:(NSString*)describe author:(NSString*)author
{
    self = [super init];
    if (self) {
        self.pid = pid;
        self.image = image;
        self.describe = describe;
        self.author = author;
    }
    return self;
}

-(instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.pid = [dict[@"id"] integerValue];
        self.image = dict[@"image"];
        self.describe = dict[@"describe"];
        self.author = dict[@"author"];
        self.author_id = [dict[@"author_id"] integerValue];
        self.like_count = [dict[@"like_count"] integerValue];
        if ([dict[@"like"] integerValue] == 0) {
            self.liked = NO;
        }else{
            self.liked = YES;
        }
        if ([dict[@"follow"] integerValue] == 0) {
            NSLog(@"没关注");
            self.followed = NO;
        }else{
            NSLog(@"关注");
            self.followed = YES;
        }
    }
    return self;
}

+(NSMutableArray *)paintsWithArray:(NSArray *)array
{
    NSMutableArray *am = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in array) {
        AYPaint *paint = [[AYPaint alloc] initWithDict:dict];
        [am addObject:paint];
    }
    return am;
}

@end
