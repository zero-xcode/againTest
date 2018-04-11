//
//  ViewController.m
//  头条
//
//  Created by 林宇 on 2018/4/3.
//  Copyright © 2018年 林宇. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"
#import "UIColor+Hex.h"
#define YCKScreenW [UIScreen mainScreen].bounds.size.width
#define YCKScreenH [UIScreen mainScreen].bounds.size.height

static const int NormalRed = 0;
static const int NormalGreen = 0;
static const int NormalBlue = 0;

static const int SelectedRed = 255;
static const int SelectedGreen = 99;
static const int SelectedBlue = 93;


@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic,copy)NSArray *array;
@property (nonatomic,strong)UIScrollView *titleScrollView;
@property (nonatomic,strong)UIScrollView *contentScollView;
@property (nonatomic,weak)UIButton *selectedButton;
@property (nonatomic,strong)NSMutableArray *buttons;

@property (nonatomic, assign) int red;
@property (nonatomic, assign) int green;
@property (nonatomic, assign) int blue;

@end

@implementation ViewController
-(NSArray*)array
{
    if (!_array) {
        _array = [NSArray array];
        _array = @[@"第一",@"第二",@"第三",@"第四",@"第五",@"第六",@"第七",@"第八",@"第九"];
    }
    return _array;
}
-(UIScrollView*)titleScrollView
{
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 44)];
        _titleScrollView.contentSize = CGSizeMake(self.array.count*80+20, 0);
    }
    return _titleScrollView;
}
-(UIScrollView*)contentScollView
{
    if (!_contentScollView) {
        _contentScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height-104)];
        _contentScollView.contentSize = CGSizeMake(self.array.count*self.view.frame.size.width, 0);
        _contentScollView.pagingEnabled = YES;
        _contentScollView.delegate = self;
    }
    return _contentScollView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.contentScollView];
    [self createTitleButton];
    [self addChildViewControllers];
    [self createContainer];
}
- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

-(void)createTitleButton
{
    for (int i = 0; i < self.array.count; i++) {
        UIButton *button  =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[NSString stringWithFormat:@"%@",self.array[i]] forState:UIControlStateNormal];
        button.frame = CGRectMake(i*80+20, 0, 60, 40);
        button.tag = 10000+i;
        [button setTitleColor:[UIColor colorWithRed:NormalRed green:NormalGreen blue:NormalBlue alpha:1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:SelectedRed/255.0 green:SelectedGreen/255.0 blue:SelectedBlue/255.0 alpha:1.0] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttons addObject:button];

        if (button.tag == 10000) {
            button.selected = YES;
            self.selectedButton = button;
        }
        [self.titleScrollView addSubview:button];
        
    }
}
-(void)addChildViewControllers
{
    for (int i = 0; i < self.array.count; i++) {
        FirstViewController *first = [[FirstViewController alloc]init];
        [self addChildViewController:first];
    }
}
-(void)createContainer
{
    for (int i = 0; i < self.childViewControllers.count; i++) {
        FirstViewController *first = self.childViewControllers[i];
        first.view.frame = CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.contentScollView addSubview:first.view];
    }
}
-(void)buttonclicked:(UIButton*)button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    NSLog(@"--------%@-----%d",self.selectedButton,self.selectedButton.selected);

    self.selectedButton = button;
    NSLog(@"========%@=====%d",self.selectedButton,self.selectedButton.selected);

    NSInteger i = button.tag-10000;
    [self setUpOneChildViewController:i];
    CGFloat x = i*[[UIScreen mainScreen]bounds].size.width;
    
    self.contentScollView.contentOffset = CGPointMake(x, 0);
    [self setupTitleCenter:button];
    
    
    NSLog(@"Current method: %@",NSStringFromSelector(_cmd));

    

}
- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * [[UIScreen mainScreen]bounds].size.width;
    FirstViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height - self.contentScollView.frame.origin.y);
    [self.contentScollView addSubview:vc.view];

    
}
- (void)setupTitleCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - [[UIScreen mainScreen]bounds].size.width * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - [[UIScreen mainScreen]bounds].size.width;
    if (maxOffset < 0) {
        offset = 0;
    }else
    {
        
        if (offset > maxOffset)
        {
            offset = maxOffset;
        }
    }
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScollView.contentOffset.x / self.view.frame.size.width;

    [self buttonclicked:self.buttons[i]];
    NSLog(@"Current method: %@",NSStringFromSelector(_cmd));

}
// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
