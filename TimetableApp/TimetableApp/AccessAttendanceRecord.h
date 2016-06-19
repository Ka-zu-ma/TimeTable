//
//  AccessAttendanceRecord.h
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/10.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessAttendanceRecord : NSObject
+(void)createAttendanceRecordTable;

//+(NSArray *)selectAttendanceRecord:(NSString *)indexPathRow attendanceCount:(NSString *)attendanceCountString absenceCount:(NSString *)absenceCountString lateCount:(NSString *)lateCountString;

+(void)insertInitialValueAttendanceRecordTable:(NSString *)indexPathRow;

+(NSArray *)selectCountAtIndexPathRow:(NSString *)indexPathRow;

+(BOOL)checkIndexPathExists:(NSString *)indexPathRow;

+(void)countUp:(NSString *)indexPathRow whichButton:(NSString *)whichButton;

+(void)createDateAndAttendanceRecord;

+(void)registerDateAndAttendanceRecord:(NSString *)attendanceRecord indexPathRow:(NSString *)indexPathRow;

+(NSArray *)selectDateRecord:(NSString *)indexPathRow;

+(void)delete:(NSString *)date attendancerecord:(NSString *)attendancerecord indexPathRow:(NSString *)indexPathRow;

+(void)updateCountDown:(NSString *)whichLabel indexPathRow:(NSString *)indexPathRow;

+(void)update:(NSString *)dateAfterEdit attendanceRecordAfterEdit:(NSString *)attendanceRecordAfterEdit dateString:(NSString *)dateString attendanceRecordString:(NSString *)attendanceRecordString indexPathRow:(NSString *)indexPathRowString;

//+(NSString *)getID:(NSString *)dateString attendancerecord:(NSString *)attendancerecordString indexPathRow:(NSString *)indexPathString;

+(void)update:(NSString *)attendanceRecordCountUp attendanceRecordCountDown:(NSString *)attendanceRecordCountDown  indexPathRow:(NSString *)indexPathRowString;


@end
