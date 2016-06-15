//
//  AccessHomeClassDB.h
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/15.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessHomeClassDB : NSObject

+(void)createHomeClassTable;
+(void)insertHomeClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString indexPathRow:(NSString *)indexPathRowString;

+(NSArray *)selectHomeClassTable;

@end
