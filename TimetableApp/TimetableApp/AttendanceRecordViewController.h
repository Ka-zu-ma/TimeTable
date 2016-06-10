//
//  AttendanceCountViewController.h
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/08.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendanceRecordViewController : UIViewController

@property (strong,nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIButton *attendanceButton;
@property (weak, nonatomic) IBOutlet UIButton *absenceButton;
@property (weak, nonatomic) IBOutlet UIButton *lateButton;



@end
