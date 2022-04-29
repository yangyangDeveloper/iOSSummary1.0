//
//  VC4.m
//  MethodSwizzling
//
//  Created by zhangyangyang on 2022/4/29.
//

#import "VC4.h"
#import "ZYYUITableview.h"
#import "UITableView+Swizzling.h"

@interface VC4 ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ZYYUITableview *tableview;

@end

@implementation VC4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview = [[ZYYUITableview alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    // [_tableView registerClass:[CustomCell class] forCellReuseIdentifier:kCellIdentify];
    self.tableview.reloadBlock = ^{
        NSLog(@"yangyang刷新");
    };
    
    [self.tableview reloadData];
    
    [self performSelector:@selector(reload) withObject:nil afterDelay:2.0];
}

- (void)reload {
    NSLog(@"%s",__func__);
    [self.tableview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     /重用cell 第一种方式
     这种方式需要配合上面的 注册cell   这种方式返回的cell  一定不为空
     获取重用的cell，如果没有重用的cell，将自动使用提供的class类创建cell并返回
     CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
     */
    
    // 重用cell 第二种方式
    // 这种方式获取的cell可能位空 所以需要加上 判nil处理
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"cell%d", indexPath.row];
    return  cell;
}

@end
