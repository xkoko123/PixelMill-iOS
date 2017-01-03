//
//  AYMessage.h
//  PixelMill
//
//  Created by GoGo on 03/01/2017.
//  Copyright © 2017 tygogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AYMessage : NSObject

@property(nonatomic,strong)NSString *from_user;
@property(nonatomic,assign)NSInteger from_id;
@property(nonatomic,assign)NSInteger paint_id;
@property(nonatomic,assign)NSInteger comment_id;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,strong)NSString *text;
@property(nonatomic,assign)BOOL readed;

@end
