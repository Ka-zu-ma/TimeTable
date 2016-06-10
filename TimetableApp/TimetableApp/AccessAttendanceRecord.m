//
//  AccessAttendanceRecord.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/10.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "AccessAttendanceRecord.h"
#import "AccessDB.h"

@implementation AccessAttendanceRecord

+(void)createAttendanceRecordTable{
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS attendance_record_table (id INTEGER PRIMARY KEY AUTOINCREMENT, attendancecount INTEGER, absencecount INTEGER, latecount INTEGER, indexPath INTEGER);"];
    
    [db close];
}

+(void)insertInitialValueCountUpRecordTable:(NSString *)indexPathRow{
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    [db executeUpdate:@"INSERT INTO attendance_record_table (attendancecount, absencecount, latecount, indexPath) VALUES (?, ?, ?, ?);",@"0",@"0",@"0",indexPathRow];
    [db close];
    
}

//+(NSArray *)selectAttendanceRecord:(NSString *)indexPathRow attendanceCount:(NSString *)attendanceCountString absenceCount:(NSString *)absenceCountString lateCount:(NSString *)lateCountString{
//    
//    FMDatabase *db=[AccessDB getdb];
//    [db open];
//    
//    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount ,latecount FROM attendance_record_table WHERE indexPath = ?;",indexPathRow];
//    
//    while ([results next]) {
//        attendanceCountString=[results stringForColumn:@"attendancecount"];
//        absenceCountString=[results stringForColumn:@"absencecount"];
//        lateCountString=[results stringForColumn:@"latecount"];
//    }
//    
//    [db close];
//    
//    return @[attendanceCountString,absenceCountString,lateCountString];
//}

//ある授業の出欠カウントを取得
+(NSArray *)selectCountAtIndexPath:(NSString *)indexPathRow{
    
    NSString *attendanceCountString;
    NSString *absenceCountString;
    NSString *lateCountString;
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount ,latecount FROM attendance_record_table WHERE indexPath = ?;",indexPathRow];
    
    while ([results next]) {
        attendanceCountString=[results stringForColumn:@"attendancecount"];
        absenceCountString=[results stringForColumn:@"absencecount"];
        lateCountString=[results stringForColumn:@"latecount"];
    }
    
    [db close];
    
    return @[attendanceCountString,absenceCountString,lateCountString];
}



@end
