//
//  VC4.m
//  列表
//
//  Created by zhangyangyang on 2022/6/9.
//

#import "VC4.h"
#import "ZYYTableViewCell.h"

@interface VC4 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *tests;
@end

@implementation VC4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    
    _tests = @[@"wowowowo", @"你你你你你你",@"7777777",@"上下来回滑动tableview的",@"会看到区别，第一种程序界面不会出",
               @"但是第二种就不是了",@"会出现字体叠加现象",@"更确切的是多个label的",@"它就不会再重新请求资",@"为什么呢"];
    
    // 刷新
    [NSTimer scheduledTimerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
        
        [self.myTableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

// 存在 cell 复用重叠问题
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[ZYYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%d个",indexPath.row];

    UILabel *labelTest = [[UILabel alloc]init];
    [labelTest setFrame:CGRectMake(2, 2, 80, 40)];
    [labelTest setBackgroundColor:[UIColor clearColor]]; //之所以这里背景设为透明，就是为了后面让大家看到cell上叠加的label。
    [labelTest setTag:1];
    [[cell contentView] addSubview:labelTest];
    [labelTest setText:[self.tests objectAtIndex:indexPath.row]];
    return cell;
}

/*
修复 cell 复用问题
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[ZYYTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        UILabel *labelTest = [[UILabel alloc]init];
        [labelTest setFrame:CGRectMake(2, 2, 80, 40)];
        [labelTest setBackgroundColor:[UIColor clearColor]]; //之所以这里背景设为透明，就是为了后面让大家看到cell上叠加的label。
        [labelTest setTag:1];
        [[cell contentView] addSubview:labelTest];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第%d个",indexPath.row];
    UILabel *label1 = (UILabel*)[cell viewWithTag:1];
    [label1 setText:[self.tests objectAtIndex:indexPath.row]];
    return cell;
}
*/

@end
