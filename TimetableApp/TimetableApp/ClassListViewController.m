//
//  ClassListViewController.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/02.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "ClassListViewController.h"
#import "ClassTableCell.h"
#import "RegisterClassViewController.h"
#import "AccessDB.h"
#import "AccessHomeClassDB.h"

@interface ClassListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *classes;
@property NSMutableArray *teachers;

@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ClassTableCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.title = @"授業一覧";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddButton)];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [AccessDB createTable];
    
    _classes = [AccessDB selectTable][0];
    _teachers = [AccessDB selectTable][1];
    
    [self.tableView reloadData];
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _classes.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ClassTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = _classes[indexPath.row];
    cell.detailTextLabel.text = _teachers[indexPath.row];
    
    cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return cell;
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark - TableViewDelegate

//これを実装することで、左スワイプ可能になる。中身の処理は何も書かなくてOK
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //削除ボタン
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        [AccessDB deleteData:cell.textLabel.text teacherName:cell.detailTextLabel.text];
        
        [_classes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    //編集ボタン
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        RegisterClassViewController *viewController = [[RegisterClassViewController alloc] init];
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        viewController.classNameString = cell.textLabel.text;
        viewController.teacherNameString = cell.detailTextLabel.text;
        
        viewController.classroomNameString = [AccessDB selectClassroom:cell.textLabel.text teacherName:cell.detailTextLabel.text];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }];
    
    editAction.backgroundColor = [UIColor blueColor];
    
    return @[deleteAction,editAction];    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    
    [AccessHomeClassDB insertHomeClassTable:cell.textLabel.text teacherName:cell.detailTextLabel.text classroomName:[AccessDB selectClassroomOfClass:cell.textLabel.text teacherName:cell.detailTextLabel.text] indexPathRow:[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Original

-(void)didTapAddButton{
    
    RegisterClassViewController *viewController = [[RegisterClassViewController alloc] init];
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
