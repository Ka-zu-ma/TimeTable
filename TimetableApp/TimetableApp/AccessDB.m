//
//  AccessDB.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/06.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "AccessDB.h"


@implementation AccessDB

//DB接続
+(FMDatabase *)getdb{

    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *dbPathString=paths[0];

    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"timetable.db"]];
    
     NSLog(@"DBの場所:%@",[dbPathString stringByAppendingPathComponent:@"timetable.db"]);
    
    return db;
}

//テーブル作成
+(void)createTable{
    
    FMDatabase *db = [AccessDB getdb];
    
    [db open];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS classtable (id INTEGER PRIMARY KEY, class TEXT, teacher TEXT, classroom TEXT)"];
    
    [db close];
}

//データ挿入
+(void)insertTable:(NSString *)classString teacher:(NSString *)teacherString classroom:(NSString *)classroomString{
    
    FMDatabase *db = [AccessDB getdb];
    
    [db open];
    
    [db executeUpdate:@"INSERT INTO classtable (class, teacher, classroom) VALUES (?, ?, ?);",classString,teacherString,classroomString];
    
    [db close];

}

//データ取得
+(NSArray *)selectTable{
    
    NSMutableArray *classes = [[NSMutableArray alloc] init];
    NSMutableArray *teachers = [[NSMutableArray alloc] init];
    NSMutableArray *classrooms = [[NSMutableArray alloc] init];
    
    FMDatabase *db = [AccessDB getdb];
    
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT class, teacher, classroom FROM classtable;"];
    while ([results next]) {
        
        [classes addObject:[results stringForColumn:@"class"]];
        [teachers addObject:[results stringForColumn:@"teacher"]];
        [classrooms addObject:[results stringForColumn:@"classroom"]];
    }
    
    [db close];
    
    return @[classes,teachers,classrooms];
    
}

//ある授業の教室を取得
+(NSString *)selectClassroom:(NSString *)classNameString teacherName:(NSString *)teacherNameString{
    
    NSString *classroomNameString;
    
    FMDatabase *db = [AccessDB getdb];
    
    [db open];
        
    FMResultSet *results=[db executeQuery:@"SELECT classroom FROM classtable WHERE class = ? AND teacher = ?;",classNameString,teacherNameString];
        
    while ([results next]) {
            classroomNameString=[results stringForColumn:@"classroom"];
    }
    
    [db close];
        
    return classroomNameString;
}

//ある授業データを更新
+(void)updateClass:(NSString *)classNameTextField teacherNameTextField:(NSString *)teacherNameTextField  classroomNameTextField:(NSString *)classroomNameTextField classNameString:(NSString *)classNameString teacherNameString:(NSString *)teacherNameString classroomNameString:(NSString *)classroomNameString{
    
    FMDatabase *db = [AccessDB getdb];
    
    [db open];
    
    [db executeUpdate:@"UPDATE classtable SET class = ?, teacher = ?, classroom = ? WHERE class = ? AND teacher = ? AND classroom = ?;",classNameTextField,teacherNameTextField,classroomNameTextField,classNameString,teacherNameString,classroomNameString];
    
    [db close];
}

//ある授業のデータが存在しているかの判定
+(BOOL)checkClassExists:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString{
    
    BOOL exists = YES;
    
    NSString *classString;
    NSString *teacherString;
    NSString *classroomString;
    
    FMDatabase *db = [AccessDB getdb];
    
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT class, teacher, classroom FROM classtable WHERE class = ? AND teacher = ? AND classroom = ?;",classNameString,teacherNameString,classroomNameString];
    
    while ([results next]) {
        
        classString = [results stringForColumn:@"class"];
        teacherString =[results stringForColumn:@"teacher"];
        classroomString = [results stringForColumn:@"classroom"];
    }
    
    [db close];
    
    if (classString.length == 0 && teacherString.length == 0 && classroomString.length == 0) {
        
        exists = NO;
    }
    
    return exists;
}

//データ削除
+(void)deleteData:(NSString *)classNameString teacherName:(NSString *)teacherNameString{
    
    FMDatabase *db = [AccessDB getdb];
    
    [db open];
    
    [db executeUpdate:@"DELETE FROM classtable WHERE class = ? AND teacher = ?",classNameString,teacherNameString];
    
    [db close];
}


@end
