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

//出欠記録テーブル作成
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

//出席、欠席、遅刻カウントのうち、どれか1アップし、どれか1ダウン
+(void)update:(NSString *)attendanceRecordCountUp attendanceRecordCountDown:(NSString *)attendanceRecordCountDown  indexPathRow:(NSString *)indexPathRowString{
    
    FMDatabase *db = [AccessDB getdb];
    [db open];
    
    
    
//    [db executeUpdate:sql,countAfterUpString,indexPathRow];
    
    [db close];
    
    
}

//日付出欠テーブル作成
+(void)createDateAndAttendanceRecord{
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS date_record_table (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, attendancerecord TEXT, indexPathRow INTEGER);"];
    
    [db close];
}

//日付と出欠記録登録
+(void)registerDateAndAttendanceRecord:(NSString *)attendanceRecord indexPathRow:(NSString *)indexPathRow{
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSString *stringTime=[format stringFromDate:[NSDate date]];
    
    FMDatabase *db=[AccessDB getdb];
    [db open];

    [db executeUpdate:@"INSERT INTO date_record_table (date, attendancerecord, indexPathRow) VALUES (?, ?, ?);",stringTime,attendanceRecord,indexPathRow];
    
    [db close];
}

//日付出欠データ取得
+(NSArray *)selectDateRecord:(NSString *)indexPathRow{
    
    NSMutableArray *dates=[[NSMutableArray alloc]init];
    NSMutableArray *attendanceRecord=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM date_record_table WHERE indexPathRow=?;",indexPathRow];
    
    while ([results next]) {
        [dates addObject:[results stringForColumn:@"date"]];
        [attendanceRecord addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    
    [db close];
    
    return @[dates,attendanceRecord];
}

//出欠データを削除
+(void)delete:(NSString *)date attendancerecord:(NSString *)attendancerecord indexPathRow:(NSString *)indexPathRow{
    
    
    
    FMDatabase *db=[AccessDB getdb];
    [db open];
    
    [db executeUpdate:@"DELETE FROM date_record_table WHERE date = ? AND attendancerecord = ? AND indexPathRow = ?",date,attendancerecord,indexPathRow];
    
    [db close];
}

//カウント1下げる
+(void)updateCountDown:(NSString *)whichLabel indexPathRow:(NSString *)indexPathRow{
    
    NSString *sql;
    NSInteger number;
    
    //    NSLog(@"whichボタン:%@",whichButton);
    
    if ([whichLabel  isEqual: @"出席"]) {
        
        sql = @"UPDATE attendance_record_table set attendancecount = ? WHERE indexPathRow = ?";
        number = 0;
        
    }else if([whichLabel isEqual: @"欠席"]){
        
        sql = @"UPDATE attendance_record_table set absencecount = ? WHERE indexPathRow = ?";
        number = 1;
        
    }else if ([whichLabel isEqual:@"遅刻"]){
        
        sql = @"UPDATE attendance_record_table set latecount = ? WHERE indexPathRow = ?";
        number = 2;
    }
    NSString *countBeforeUpString = [AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRow][number];
    
    NSInteger countAfterUp = countBeforeUpString.intValue - 1;
    
    NSString *countAfterUpString = [NSString stringWithFormat:@"%ld",(long)countAfterUp];
    
    
    //    NSLog(@"どのボタンか:%@",whichButton);
    
    FMDatabase *db = [AccessDB getdb];
    [db open];
    
    [db executeUpdate:sql,countAfterUpString,indexPathRow];
    
    [db close];
    
}

//日付、出欠記録を更新
+(void)update:(NSString *)dateAfterEdit attendanceRecordAfterEdit:(NSString *)attendanceRecordAfterEdit dateString:(NSString *)dateString attendanceRecordString:(NSString *)attendanceRecordString indexPathRow:(NSString *)indexPathRowString{
    
    FMDatabase *db = [AccessDB getdb];
    [db open];
    
    [db executeUpdate:@"UPDATE date_record_table SET date = ?, attendancerecord = ? WHERE date = ? AND attendancerecord = ? AND indexPathRow = ?;",dateAfterEdit,attendanceRecordAfterEdit,dateString,attendanceRecordString,indexPathRowString];
    
    [db close];
    
}

@end
