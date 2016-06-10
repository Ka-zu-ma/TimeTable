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

+(void)insertInitialValueCountUpRecordTable:(NSString *)indexPathRow;

+(NSArray *)selectCountAtIndexPath:(NSString *)indexPathRow;

@end
