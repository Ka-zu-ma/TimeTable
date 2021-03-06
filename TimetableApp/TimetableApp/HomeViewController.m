//
//  HomeViewController.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/02.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "HomeViewController.h"
#import "ClassViewCell.h"
#import "DayOfWeekCell.h"
#import "ClassListViewController.h"
#import "AttendanceRecordViewController.h"
#import "AccessHomeClassDB.h"

@interface HomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property NSArray *weeks;
@property NSArray *classTimes;

@property (strong,nonatomic) NSMutableDictionary *classesAndIndexPathRows;
@property (strong,nonatomic) NSMutableDictionary *classroomsAndIndexPathRows;

@end

@implementation HomeViewController

#pragma mark - ViewLifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _weeks = @[@"月",@"火",@"水",@"木",@"金"];
    _classTimes = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //セルのカスタムクラスをUICollectionViewに登録
    [_collectionView registerNib:[UINib nibWithNibName:@"ClassViewCell" bundle:nil] forCellWithReuseIdentifier:@"ClassViewCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"DayOfWeekCell" bundle:nil] forCellWithReuseIdentifier:@"DayOfWeekCell"];
    
    self.navigationItem.title = @"時間割表";
    
    //ホーム画面の授業を登録しておくDBテーブルを作成
    [AccessHomeClassDB createHomeClassTable];
    
    NSLog(@"画面横幅:%f",[[UIScreen mainScreen]bounds].size.width);
    NSLog(@"画面縦%f",[[UIScreen mainScreen]bounds].size.height);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    _classesAndIndexPathRows = [AccessHomeClassDB selectHomeClassTable][0];
    _classroomsAndIndexPathRows = [AccessHomeClassDB selectHomeClassTable][1];
    
    for (id key in [_classesAndIndexPathRows keyEnumerator]) {
        NSLog(@"Key:%@ Value:%@", key, [_classesAndIndexPathRows valueForKey:key]);
    }
    
    for (id key in [_classroomsAndIndexPathRows keyEnumerator]) {
        NSLog(@"Key:%@ Value:%@", key, [_classroomsAndIndexPathRows valueForKey:key]);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView Delegate 

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!(indexPath.section == 0)) {
        
        if (!(indexPath.row % (_weeks.count + 1) == 0)) {
            
//            UICollectionViewCell *cell=[self.collectionView cellForItemAtIndexPath:indexPath];
//
//            
            if (indexPath.row == 1 || indexPath.row == 2) {
                
    
                AttendanceRecordViewController *viewController = [[AttendanceRecordViewController alloc] init];
                
                viewController.indexPath = indexPath;

                [self.navigationController pushViewController:viewController animated:YES];
                
                return;
            }
        

        
            ClassListViewController *viewController =[[ClassListViewController alloc] init];
            viewController.indexPath = indexPath;
            
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

#pragma mark - CollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    return 2;
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return _weeks.count + 1;
    }
    
    return (_classTimes.count)*(_weeks.count + 1);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        DayOfWeekCell *dayOfWeekCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DayOfWeekCell" forIndexPath:indexPath];
        
        dayOfWeekCell.backgroundColor = [UIColor yellowColor];
        dayOfWeekCell.weekLabel.textColor = [UIColor blackColor];
        
        if (indexPath.row == 0) {
            
            dayOfWeekCell.weekLabel.text = @"";
            
            return dayOfWeekCell;
        }
        
        dayOfWeekCell.weekLabel.text = _weeks[indexPath.row - 1];
        
        
        return dayOfWeekCell;
    }
    
    ClassViewCell *classCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassViewCell" forIndexPath:indexPath];
    
    classCell.backgroundColor = [UIColor whiteColor];
//    classCell.classLabel.adjustsFontSizeToFitWidth=YES;
    
//    classCell.classTimeLabel.textColor = [UIColor blackColor];
//    classCell.classLabel.textColor = [UIColor blackColor];
//    classCell.classroomLabel.textColor = [UIColor blackColor];
    
//    classCell.classLabel.text = @"a";
//    classCell.classTimeLabel.text = @"b";
//    classCell.classroomLabel.text = @"c";
    
    if((indexPath.row) % (_weeks.count + 1) == 0){
        
        classCell.classLabel.text = @"";
        classCell.classroomLabel.text = @"";
        classCell.classTimeLabel.text = _classTimes[(indexPath.row) / (_weeks.count + 1)];
        
        return classCell;
    }
    
    classCell.classTimeLabel.text = @"";
    classCell.classLabel.text = @"いいい";
//    classCell.classroomLabel.text = @"あ";
    
//    NSLog(@"%@",classCell.classLabel.text);
    
//    classCell.classroomLabel.text = @"うううう";
//    
//    if ([_classesAndIndexPathRows.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]){
//        
////        NSLog(@"あいうえお");
//        
//        classCell.classLabel.text = (NSString *)[_classesAndIndexPathRows objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        
//        classCell.classroomLabel.text = (NSString *)[_classroomsAndIndexPathRows objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
//        
////        NSLog(@"やっほー:%@",[_classesAndIndexPathRows objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]);
//        
//        return classCell;
//    }
//    
//    classCell.classLabel.text=@"";
//    classCell.classroomLabel.text=@"";
    
    return classCell;
    
}

#pragma mark - CollectionView Layout

//セルのサイズを変更
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return CGSizeMake(20, 20);
        }
        
        //曜日のセルの大きさ
        //(20 + _weeks.count)は、セル同士の隙間を考慮している
        float widthsize = ([[UIScreen mainScreen] bounds].size.width - (20 + _weeks.count))/(_weeks.count);
        
        NSLog(@"曜日セル横幅:%f",widthsize);
        
        
        return CGSizeMake(widthsize, 20);
    }
    
    //時限のセルの大きさ
    if ((indexPath.row % (_weeks.count + 1)) == 0) {
        
        //ステータスバーの高さを考慮
        float heightsize = ([[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - self.navigationController.navigationBar.bounds.size.height - (20 + _classTimes.count)) / (_classTimes.count);
        
        return CGSizeMake(20, heightsize);
        
    }
    
    float widthsize = ([[UIScreen mainScreen]bounds].size.width - (20 + _weeks.count) )/(_weeks.count);
    
    float heightsize = ([[UIScreen mainScreen]bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - self.navigationController.navigationBar.bounds.size.height - (20 + _classTimes.count))/(_classTimes.count);
    
    return CGSizeMake(widthsize, heightsize);
   
}

//垂直方向のセル間のマージンの最小値
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.0f;
}

//水平方向のセル間のマージンの最小値
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.0f;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    
}

//ヘッダーサイズ
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}

//フッターサイズ
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(0, 0);
}

@end
