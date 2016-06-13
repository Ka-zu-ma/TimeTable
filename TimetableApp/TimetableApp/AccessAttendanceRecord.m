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
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS attendance_record_table (id INTEGER PRIMARY KEY AUTOINCREMENT, attendancecount INTEGER, absencecount INTEGER, latecount INTEGER, indexPathRow INTEGER);"];
    
    [db close];
}

//ある授業のindexPathがあるかチェック
+(BOOL)checkIndexPathExists:(NSString *)indexPathRow{
    
    BOOL exists = YES;
    
    NSString *indexPathRowString;
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT indexPathRow FROM attendance_record_table WHERE indexPathRow = ?;",indexPathRow];
    
    while ([results next]) {
        indexPathRowString=[results stringForColumn:@"indexPathRow"];
        
    }
    [db close];
    
    if (indexPathRowString.length == 0) {
        exists = NO;
    }
    
    NSLog(@"indexpathRowあるか:%d",exists);
    
    return exists;

}


//出欠カウント初期値をDBに登録
+(void)insertInitialValueAttendanceRecordTable:(NSString *)indexPathRow{
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    [db executeUpdate:@"INSERT INTO attendance_record_table (attendancecount, absencecount, latecount, indexPathRow) VALUES (?, ?, ?, ?);",@"0",@"0",@"0",indexPathRow];
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
+(NSArray *)selectCountAtIndexPathRow:(NSString *)indexPathRow{
    
    NSString *attendanceCountString;
    NSString *absenceCountString;
    NSString *lateCountString;
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount ,latecount FROM attendance_record_table WHERE indexPathRow = ?;",indexPathRow];
    
    while ([results next]) {
        attendanceCountString=[results stringForColumn:@"attendancecount"];
        absenceCountString=[results stringForColumn:@"absencecount"];
        lateCountString=[results stringForColumn:@"latecount"];
    }
    
    [db close];
    
    return @[attendanceCountString,absenceCountString,lateCountString];
}


//出欠カウントを1アップ
+(void)countUp:(NSString *)indexPathRow whichButton:(NSString *)whichButton{
    
    NSString *sql;
    NSInteger number;
    
//    NSLog(@"whichボタン:%@",whichButton);
    
    if ([whichButton  isEqual: @"出席ボタン"]) {
        
        sql = @"UPDATE attendance_record_table set attendancecount = ? WHERE indexPathRow = ?";
        number = 0;
        
    }else if([whichButton isEqual: @"欠席ボタン"]){
        
        sql = @"UPDATE attendance_record_table set absencecount = ? WHERE indexPathRow = ?";
        number = 1;
        
    }else if ([whichButton isEqual:@"遅刻ボタン"]){
        
        sql = @"UPDATE attendance_record_table set latecount = ? WHERE indexPathRow = ?";
        number = 2;
    }
    NSString *countBeforeUpString = [AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRow][number];
    
    NSInteger countAfterUp = countBeforeUpString.intValue + 1;
    
    NSString *countAfterUpString = [NSString stringWithFormat:@"%ld",(long)countAfterUp];
    
    
//    NSLog(@"どのボタンか:%@",whichButton);
    
    FMDatabase *db = [AccessDB getdb];
    [db open];
    
    [db executeUpdate:sql,countAfterUpString,indexPathRow];
    
    [db close];

}


@end
