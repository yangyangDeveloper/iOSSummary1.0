//
//  VC1.m
//  性能优化
//
//  Created by zhangyangyang on 2022/6/17.
//

#import "VC1.h"

@interface VC1 () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *items;
@end

@implementation VC1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    [self.view addSubview:self.tableview];
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 1000; i++) {
        [array  addObject:@{@"name": [self randomName], @"image": [self randomAvatar]}];
    }
    self.items = array;
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (NSString *)randomName
{
    NSArray *first = @[@"Alice", @"Bob", @"Bill", @"Charles", @"Dan", @"Dave", @"Ethan", @"Frank"];
    //NSArray *first = @[@"me", @"me", @"me", @"me", @"me", @"me", @"me", @"me"];
    NSArray *last = @[@"Appleseed", @"Bandicoot", @"Caravan", @"Dabble", @"Ernest", @"Fortune"];
    NSUInteger index1 = (rand()/(double)INT_MAX) * [first count];
    NSUInteger index2 = (rand()/(double)INT_MAX) * [last count];
    return [NSString stringWithFormat:@"%@ %@", first[index1], last[index2]];
}

- (NSString *)randomAvatar
{
   // NSArray *images = @[@"Snowman", @"Igloo", @"Cone", @"Spaceship", @"Anchor", @"Key"];
    NSArray *images = @[@"me", @"me", @"me", @"me", @"me", @"me", @"me", @"me"];
    NSUInteger index = (rand()/(double)INT_MAX) * [images count];
    return images[index];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *item = self.items[indexPath.row];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:item[@"image"] ofType:@"png"];
    
    //set image and text
    cell.imageView.image = [UIImage imageWithContentsOfFile:filePath];
    cell.textLabel.text = item[@"name"];
    
    //set image shadow
    cell.imageView.layer.shadowOffset = CGSizeMake(0, 5);
    cell.imageView.layer.shadowOpacity = 0.75;
    cell.clipsToBounds = YES;
    
    //set text shadow
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.layer.shadowOffset = CGSizeMake(0, 2);
    cell.textLabel.layer.shadowOpacity = 0.5;
    return cell;
}

@end
