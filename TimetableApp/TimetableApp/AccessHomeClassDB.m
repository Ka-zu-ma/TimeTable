//
//  AccessHomeClassDB.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/15.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "AccessHomeClassDB.h"
#import "AccessDB.h"

@implementation AccessHomeClassDB

+(void)createHomeClassTable{
    
    FMDatabase *db=[AccessDB getdb];
    
    [db open];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS home_class_table (id INTEGER PRIMARY KEY AUTOINCREMENT, class TEXT, teacher TEXT, classroom TEXT, indexPathRow INTEGER);"];
    
    [db close];
}

+(void)insertHomeClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString indexPathRow:(NSString *)indexPathRowString{
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    [db executeUpdate:@"INSERT INTO home_class_table (class, teacher, classroom, indexPathRow) VALUES  (?, ?, ?, ?);",classNameString,teacherNameString,classroomNameString,indexPathRowString];
    
    [db close];
}


@end
