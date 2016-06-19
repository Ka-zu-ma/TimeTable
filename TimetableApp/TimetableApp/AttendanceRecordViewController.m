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
#import "EditDateAndAttendaceRecordViewController.h"

@interface AttendanceRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)tappedAttendanceButton:(id)sender;
- (IBAction)tappedAbsenceButton:(id)sender;
- (IBAction)tappedLateButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *countView;

@property (strong,nonatomic) NSMutableArray *dates;
@property (strong,nonatomic) NSMutableArray *attendanceRecord;

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
    
    //出欠日付テーブル作成
    [AccessAttendanceRecord createDateAndAttendanceRecord];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    //出欠カウントボタンに値をセット
    [_attendanceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][0] forState:UIControlStateNormal];
    
    [_absenceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][1] forState:UIControlStateNormal];
    
    [_lateButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][2] forState:UIControlStateNormal];
    
    
    //DBから出欠日付データ取得
    _dates = [AccessAttendanceRecord selectDateRecord:indexPathRowString][0];
    _attendanceRecord = [AccessAttendanceRecord selectDateRecord:indexPathRowString][1];
    
    [self.tableView reloadData];
    

    
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
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        //出欠データ削除
        [AccessAttendanceRecord delete:cell.textLabel.text attendancerecord:cell.detailTextLabel.text indexPathRow:indexPathRowString];
        
        
        [AccessAttendanceRecord updateCountDown:cell.detailTextLabel.text indexPathRow:indexPathRowString];
        
        [_dates removeObjectAtIndex:indexPath.row];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //出欠カウント更新
        [self viewWillAppear:YES];
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        EditDateAndAttendaceRecordViewController *viewController = [[EditDateAndAttendaceRecordViewController alloc] init];
        
        viewController.dateString = cell.textLabel.text;
        viewController.attendanceRecordString = cell.detailTextLabel.text;
        viewController.indexPath = _indexPath;
        
        [self.navigationController pushViewController:viewController animated:YES];
        
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
    
    cell.textLabel.text = _dates[indexPath.row];
    cell.detailTextLabel.text = _attendanceRecord[indexPath.row];
    
    if ([_attendanceRecord[indexPath.row] isEqual:@"出席"]) {
        
        cell.detailTextLabel.textColor = [UIColor redColor];
        
    }else if ([_attendanceRecord[indexPath.row] isEqual:@"欠席"]){
        
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
    }else{
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dates.count;
}



//出席カウントを1アップ
- (IBAction)tappedAttendanceButton:(id)sender {
    
    //同じ日に１回までしかボタンを押せなくしたい。
    if ([_dates containsObject:[self getToday]]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"同じ日にカウントを２回以上押せません。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    NSString *whichButton = @"出席ボタン";
    
    [AccessAttendanceRecord countUp:[NSString stringWithFormat:@"%ld",_indexPath.row] whichButton:whichButton];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    [_attendanceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][0] forState:UIControlStateNormal];
    
    //DBに出席日付登録
    [AccessAttendanceRecord registerDateAndAttendanceRecord:@"出席" indexPathRow:indexPathRowString];
    
    _dates = [AccessAttendanceRecord selectDateRecord:indexPathRowString][0];
    _attendanceRecord = [AccessAttendanceRecord selectDateRecord:indexPathRowString][1];
    
    [self.tableView reloadData];

    
//    NSLog(@"おされた");
    
    
}
//欠席カウントを1アップ
- (IBAction)tappedAbsenceButton:(id)sender {
    
    //同じ日に１回までしかボタンを押せなくしたい。
    if ([_dates containsObject:[self getToday]]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"同じ日にカウントを２回以上押せません。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }

    
     NSString *whichButton = @"欠席ボタン";
    
    [AccessAttendanceRecord countUp:[NSString stringWithFormat:@"%ld",_indexPath.row] whichButton:whichButton];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    [_absenceButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][1] forState:UIControlStateNormal];
    
    //DBに欠席日付登録
    [AccessAttendanceRecord registerDateAndAttendanceRecord:@"欠席" indexPathRow:indexPathRowString];
    
    _dates = [AccessAttendanceRecord selectDateRecord:indexPathRowString][0];
    _attendanceRecord = [AccessAttendanceRecord selectDateRecord:indexPathRowString][1];
    [self.tableView reloadData];

    
//    NSLog(@"欠席おされた");
    
}

//遅刻カウントを1アップ
- (IBAction)tappedLateButton:(id)sender {
    
    //同じ日に１回までしかボタンを押せなくしたい。
    if ([_dates containsObject:[self getToday]]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"同じ日にカウントを２回以上押せません。" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
        
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }

    
     NSString *whichButton = @"遅刻ボタン";
    [AccessAttendanceRecord countUp:[NSString stringWithFormat:@"%ld",_indexPath.row] whichButton:whichButton];
    
    NSString *indexPathRowString=[NSString stringWithFormat:@"%ld",_indexPath.row];
    
    [_lateButton setTitle:[AccessAttendanceRecord selectCountAtIndexPathRow:indexPathRowString][2] forState:UIControlStateNormal];
    
    //DBに遅刻日付登録
    [AccessAttendanceRecord registerDateAndAttendanceRecord:@"遅刻" indexPathRow:indexPathRowString];
    
    _dates = [AccessAttendanceRecord selectDateRecord:indexPathRowString][0];
    _attendanceRecord = [AccessAttendanceRecord selectDateRecord:indexPathRowString][1];
    [self.tableView reloadData];

}

-(NSString *)getToday{
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSString *stringTime=[format stringFromDate:[NSDate date]];
    return stringTime;
}




@end
