//
//  XMConverNoteCell.h
//  fmapp
//
//  Created by runzhiqiu on 16/1/23.
//  Copyright © 2016年 yk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XmConverNotesModel,XMConverNoteCell;
@protocol XMConverNoteCellDelegate <NSObject>

@optional
-(void)ConverNoteCellDidSelectconverDelete:(XMConverNoteCell *)convertNote;

@end

@interface XMConverNoteCell : UITableViewCell

@property (nonatomic, strong) XmConverNotesModel * noteModel;
@property (weak, nonatomic) IBOutlet UIButton *converDelete;

@property (nonatomic, weak) id <XMConverNoteCellDelegate> delegate;

-(void)setUpConverDeleteButtonLayer;
@end
