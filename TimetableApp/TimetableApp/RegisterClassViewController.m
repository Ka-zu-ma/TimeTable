//
//  RegisterClassViewController.m
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/05.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import "RegisterClassViewController.h"
#import "FMDatabase.h"

#import "AccessDB.h"

@interface RegisterClassViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *classTextField;
@property (weak, nonatomic) IBOutlet UITextField *teacherTextField;
@property (weak, nonatomic) IBOutlet UITextField *classroomTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)tapRegisterButton:(id)sender;

@end

@implementation RegisterClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"授業登録";
    
    _classTextField.delegate = self;
    _teacherTextField.delegate = self;
    _classroomTextField.delegate = self;
    
    _classTextField.text = _classNameString;
    _teacherTextField.text = _teacherNameString;
    _classroomTextField.text = _classroomNameString;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tapRegisterButton:(id)sender {
    
    NSString *classString = _classTextField.text;
    NSString *teacherString = _teacherTextField.text;
    NSString *classroomString = _classroomTextField.text;
    
    if ((classString.length != 0) && (teacherString.length != 0) && (classroomString.length != 0) ) {
        
        
//        if(![AccessDB checkClassExists:_classNameString teacherName:_teacherNameString classroomName:_classroomNameString]){
        if (_classNameString == nil && _teacherNameString == nil && _classroomNameString == nil) {
        
            //新しく授業を登録
            [AccessDB insertTable:classString teacher:teacherString classroom:classroomString];
        
        }else{
            
            [AccessDB updateClass:classString teacherNameTextField:teacherString classroomNameTextField:classroomString classNameString:_classNameString teacherNameString:_teacherNameString classroomNameString:_classroomNameString];
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"すべて入力しないと登録できません。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
    
    [alertController addAction:action];
    
    [self presentViewController:alertController animated:YES completion:nil];

}
@end
