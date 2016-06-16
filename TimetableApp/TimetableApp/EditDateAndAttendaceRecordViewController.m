//
//  EditDateAndAttendaceRecordViewController.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/16.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "EditDateAndAttendaceRecordViewController.h"
#import "AccessAttendanceRecord.h"

@interface EditDateAndAttendaceRecordViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong,nonatomic) NSString *afterEditDateString;//変更した後の日付



- (IBAction)changeDatePicker:(id)sender;
- (IBAction)tappedUpdateButton:(id)sender;


@end

@implementation EditDateAndAttendaceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([_attendanceRecordString isEqual:@"出席"]) {
        
        _segmentedControl.selectedSegmentIndex = 0;
        
    }else if ([_attendanceRecordString  isEqual:@"欠席"]){
        
        _segmentedControl.selectedSegmentIndex = 1;
        
    }else{
        
        _segmentedControl.selectedSegmentIndex = 2;
    }
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    _datePicker.date=[formatter dateFromString:_dateString];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeDatePicker:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    _afterEditDateString = [dateFormatter stringFromDate:_datePicker.date];
}

- (IBAction)tappedUpdateButton:(id)sender {
    
    NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    NSInteger number = _segmentedControl.selectedSegmentIndex;
    
    NSString *afterEditDateString;
    
    if (_afterEditDateString ==  nil) {
        
        //日付変更しないとき
        afterEditDateString = _dateString;
    }else{
        afterEditDateString = _afterEditDateString;
    }
    
    //出席に変更した場合
    if (number == 0) {
        
        [AccessAttendanceRecord update:afterEditDateString attendanceRecordAfterEdit:@"出席" dateString:_dateString attendanceRecordString:_attendanceRecordString indexPathRow:indexPathString];
        
        //DBの出欠カウントテーブル
        if ([_attendanceRecordString isEqual:@"出席"]) {
            
            
        }else if([_attendanceRecordString isEqual:@"欠席"]){
            
            
        }else{
            
            
        }
        
        
    //欠席に変更した場合
    }else if (number == 1){
        
        [AccessAttendanceRecord update:_afterEditDateString attendanceRecordAfterEdit:@"欠席" dateString:_dateString attendanceRecordString:_attendanceRecordString indexPathRow:indexPathString];
        
        
        
        
        
    //遅刻に変更した場合
    }else if (number == 2){
        
        [AccessAttendanceRecord update:_afterEditDateString attendanceRecordAfterEdit:@"遅刻" dateString:_dateString attendanceRecordString:_attendanceRecordString indexPathRow:indexPathString];
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];

    
    
    
}
@end
