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
