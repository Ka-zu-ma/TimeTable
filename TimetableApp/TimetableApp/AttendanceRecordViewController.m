//
//  AttendanceCountViewController.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/08.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "AttendanceRecordViewController.h"
#import "AttendanceRecordCell.h"
#import "AccessAttendanceRecord.h"

@interface AttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tappedAttendanceButton:(id)sender;
- (IBAction)tappedAbsenceButton:(id)sender;
- (IBAction)tappedLateButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *countView;

@end

@implementation AttendanceRecordViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //出席ボタン
    //枠線色
    [[_attendanceButton layer] setBorderColor:[[UIColor redColor]CGColor]];
    //枠線太さ
    [[_attendanceButton layer] setBorderWidth:1.0];
    //枠線角丸
    [[_attendanceButton layer] setCornerRadius:8.0];
    [_attendanceButton setClipsToBounds:YES];
    
    [[_absenceButton layer] setBorderColor:[[UIColor blueColor]CGColor]];
    
    [[_absenceButton layer] setBorderWidth:1.0];
    
    [[_absenceButton layer] setCornerRadius:10.0];
    [_absenceButton setClipsToBounds:YES];
    
    [[_lateButton layer] setBorderColor:[[UIColor greenColor]CGColor]];
    
    [[_lateButton layer] setBorderWidth:1.0];
    
    [[_lateButton layer] setCornerRadius:10.0];
    [_lateButton setClipsToBounds:YES];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AttendanceRecordCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    //出席記録テーブル作成
    [AccessAttendanceRecord createAttendanceRecordTable];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    if (![AccessAttendanceRecord checkIndexPathExists:indexPathRowString]) {
        
        //出欠カウント初期値をDBに登録
        [AccessAttendanceRecord insertInitialValueAttendanceRecordTable:indexPathRowString];
    }
    
    //ある授業の出欠カウント取得
//    [AccessAttendanceRecord selectCountAtIndexPath:indexPathRowString];
    
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    //出欠カウントボタンに値をセット
    [_attendanceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][0] forState:UIControlStateNormal];
    
    [_absenceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][1] forState:UIControlStateNormal];
    
    [_lateButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][2] forState:UIControlStateNormal];
    
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TableViewDelegate

//編集モードを呼び出す
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
//        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        
        
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
//        RegisterClassViewController *viewController = [[RegisterClassViewController alloc] init];
        
//        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        
//        [self.navigationController pushViewController:viewController animated:YES];
        
    }];
    
    editAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction,editAction];
    
    
}

//セクション高さ
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}




#pragma mark - TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AttendanceRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"日にち";
    cell.detailTextLabel.text =@"出席状況";
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}



//出席カウントを1アップ
- (IBAction)tappedAttendanceButton:(id)sender {
    
    NSString *whichButton = @"出席ボタン";
    
    
    [AccessAttendanceRecord countUp:[NSString stringWithFormat:@"%ld",_indexPath.row] whichButton:whichButton];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    [_attendanceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][0] forState:UIControlStateNormal];
    
//    NSLog(@"おされた");
    
    
}
//欠席カウントを1アップ
- (IBAction)tappedAbsenceButton:(id)sender {
    
     NSString *whichButton = @"欠席ボタン";
    
    [AccessAttendanceRecord countUp:[NSString stringWithFormat:@"%ld",_indexPath.row] whichButton:whichButton];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    [_absenceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][1] forState:UIControlStateNormal];
    
    
    
//    NSLog(@"欠席おされた");
    
}

//遅刻カウントを1アップ
- (IBAction)tappedLateButton:(id)sender {
    
     NSString *whichButton = @"遅刻ボタン";
    [AccessAttendanceRecord countUp:[NSString stringWithFormat:@"%ld",_indexPath.row] whichButton:whichButton];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    [_lateButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][2] forState:UIControlStateNormal];
    
}
@end
