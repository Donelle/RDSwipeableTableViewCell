//
//  RDCustomViewController.h
//  HelloWorld
//
//  Created by Donelle Sanders Jr on 12/14/13.
//  Copyright (c) 2013 Donelle Sanders Jr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RDCustomViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
