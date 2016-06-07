//
//  AccessDB.h
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/06.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface AccessDB : NSObject
+(FMDatabase *)getdb;
+(void)createTable;

+(void)insertTable:(NSString *)classString teacher:(NSString *)teacherString classroom:(NSString *)classroomString;
+(NSArray *)selectTable;

+(void)deleteData:(NSString *)classNameString teacherName:(NSString *)teacherNameString;

+(NSString *)selectClassroom:(NSString *)classNameString teacherName:(NSString *)teacherNameString;

+(BOOL)checkClassExists:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString;
+(void)updateClass:(NSString *)classNameTextField teacherNameTextField:(NSString *)teacherNameTextField  classroomNameTextField:(NSString *)classroomNameTextField classNameString:(NSString *)classNameString teacherNameString:(NSString *)teacherNameString classroomNameString:(NSString *)classroomNameString;

@end
