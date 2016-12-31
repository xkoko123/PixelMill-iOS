//
//  AYPaint.h
//  PixelMill
//
//  Created by GoGo on 30/12/2016.
//  Copyright © 2016 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYPaint : NSObject


- (instancetype)initWithID:(NSInteger)pid Image:(NSString*)image describe:(NSString*)describe author:(NSString*)author;

-(instancetype)initWithDict:(NSDictionary*)dict;

+(NSMutableArray*)paintsWithArray:(NSArray*)array;

@property (nonatomic, assign)NSInteger pid;
@property (nonatomic, strong)NSString *image;
@property (nonatomic, strong)NSString *describe;
@property (nonatomic, strong)NSString *author;

@end
