//
//  ClassViewCell.h
//  TimetableApp
//
//  Created by 宮崎数磨 on 2016/06/02.
//  Copyright © 2016年 Miyazaki Kazuma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classroomLabel;

@end
