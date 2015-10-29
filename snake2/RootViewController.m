//
//  RootViewController.m
//  snake2
//
//  Created by lanou3g on 15/8/22.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic,retain)NSMutableArray *snakeBody;
@property (nonatomic,assign)NSInteger head;
@property (nonatomic,assign)NSInteger tail;
@property (nonatomic,assign)NSInteger headFeet;
@property (nonatomic,assign)NSInteger tailFeet;
@property (nonatomic,assign)NSInteger foodHere;
@property (nonatomic,retain) NSMutableArray *up;
@property (nonatomic,retain) NSMutableArray *down;
@property (nonatomic,retain) NSMutableArray *left;
@property (nonatomic,retain) NSMutableArray *right;
@property (nonatomic,retain) NSMutableArray *foodArr;
@property (nonatomic,retain)NSTimer *snakeTime;
@end

@implementation RootViewController
-(void)dealloc
{
    self.snakeBody = nil;
    self.up = nil;
    self.down = nil;
    self.left = nil;
    self.right = nil;
    self.foodArr = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //布局backGround
//    self.view.backgroundColor = [UIColor blackColor];
    
    self.head = 160;
    self.headFeet = 1;
    self.tail = 150;
    self.tailFeet = 1;
    self.down = [NSMutableArray array];
    self.up = [NSMutableArray array];
    self.left = [NSMutableArray array];
    self.right = [NSMutableArray array];
    self.snakeBody = [NSMutableArray array];
    self.foodArr = [NSMutableArray array];
    [self layoutBackGround];
    //布局蛇身
    [self layoutSnakeBody];
    //布局食物
    [self layoutFood];
    //布局控制摁钮
    [self layoutControl];
    
}
//布局backGround
-(void)layoutBackGround
{
    
    NSInteger num = 0;
    for (int i = 0; i < 60; i ++) {
        for (int j = 0; j < 40; j ++) {
            UIView *ground = [[UIView alloc]initWithFrame:CGRectMake(0 + j * 9, 20 + i * 9, 8, 8)];
            ground.backgroundColor = [UIColor blackColor];
            [self.view addSubview:ground];
            [ground release];
            ground.tag = 101 + num++;
            if (j==0||j==39||i==0||i==59) {
                [self.snakeBody addObject:ground];
                ground.backgroundColor = [UIColor whiteColor];
                
            }
        }
    }
}
//布局蛇身
-(void)layoutSnakeBody
{
    
    for (int i = 151; i < 161; i ++) {
        UIView *snake = [self.view viewWithTag:i];
        snake.backgroundColor = [UIColor whiteColor];
        [self.snakeBody addObject:snake];
    }
    self.snakeTime = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(snakeGo:) userInfo:nil repeats:YES];
    [_snakeTime fire];
}
//布局食物
-(void)layoutFood
{
    UIView *food = [self.view viewWithTag:arc4random()%(2400) + 101];
    self.foodHere = food.tag;
    if (food.backgroundColor == [UIColor whiteColor]) {
        food = [self.view viewWithTag:arc4random()%(2400) + 101];
        self.foodHere = food.tag;
    }
    food.backgroundColor = [UIColor whiteColor];
}
//布局控制摁钮
-(void)layoutControl
{
    UIButton *upSnake = [UIButton buttonWithType:UIButtonTypeSystem];
    upSnake.frame = CGRectMake(150, 560, 50, 30);
    [upSnake setTitle:@"UP" forState:UIControlStateNormal];
    [self.view addSubview:upSnake];
    upSnake.backgroundColor = [UIColor lightGrayColor];
    [upSnake addTarget:self action:@selector(upSnake:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *downSnake = [UIButton buttonWithType:UIButtonTypeSystem];
    downSnake.frame = CGRectMake(150, 600, 50, 30);
    [downSnake setTitle:@"DOWN" forState:UIControlStateNormal];
    [self.view addSubview:downSnake];
    downSnake.backgroundColor = [UIColor lightGrayColor];
    [downSnake addTarget:self action:@selector(downSnake:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *leftSnake = [UIButton buttonWithType:UIButtonTypeSystem];
    leftSnake.frame = CGRectMake(90, 580, 50, 30);
    [leftSnake setTitle:@"LEFT" forState:UIControlStateNormal];
    [self.view addSubview:leftSnake];
    leftSnake.backgroundColor = [UIColor lightGrayColor];
    [leftSnake addTarget:self action:@selector(leftSnake:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *rightSnake = [UIButton buttonWithType:UIButtonTypeSystem];
    rightSnake.frame = CGRectMake(210, 580, 50, 30);
    [rightSnake setTitle:@"RIGHT" forState:UIControlStateNormal];
    [self.view addSubview:rightSnake];
    rightSnake.backgroundColor = [UIColor lightGrayColor];
    [rightSnake addTarget:self action:@selector(rightSnake:) forControlEvents:UIControlEventTouchUpInside];
}
//蛇移动
-(void)snakeGo:(NSTimer *)time
{
    self.head += self.headFeet;
    UIView *goHead = (UIView *)[self.view viewWithTag:self.head];
    goHead.backgroundColor = [UIColor whiteColor];
    [self.snakeBody addObject:goHead];
    self.tail += self.tailFeet;
    UIView *goTail = (UIView *)[self.view viewWithTag:self.tail];
    goTail.backgroundColor = [UIColor blackColor];
    [self.snakeBody removeObject:goTail];
    NSNumber *tail = [NSNumber numberWithInteger:self.tail];
    if ([self.up containsObject:tail]) {
        self.tailFeet = -40;
        [self.up removeObject:tail];
    }
    else if ([self.down containsObject:tail])
    {
        self.tailFeet = 40;
        [self.down removeObject:tail];
    }
    else if ([self.left containsObject:tail])
    {
        self.tailFeet = -1;
        [self.left removeObject:tail];
    }
    else if ([self.right containsObject:tail])
    {
        self.tailFeet = 1;
        [self.right removeObject:tail];
    }
    if (self.head == self.foodHere) {
        NSNumber *fh = [NSNumber numberWithInteger:self.foodHere];
        [self.foodArr addObject:fh];
        [self layoutFood];
    }
    if ([self.foodArr containsObject:tail]) {
        goTail.backgroundColor = [UIColor whiteColor];
        self.tail = self.tail - self.tailFeet;
        [self.foodArr removeObject:tail];
    }
    if (([self.snakeBody containsObject:goHead] && ([self.snakeBody indexOfObject:goHead] != self.snakeBody.count-1)) )
    {
        [self snakeDead];
    }
}
//上
-(void)upSnake:(UIButton *)button
{
    self.headFeet = -40;
    NSNumber *change = [NSNumber numberWithInteger:self.head];
    [self.up addObject:change];
}
//下
-(void)downSnake:(UIButton *)button
{
    self.headFeet = 40;
    NSNumber *change = [NSNumber numberWithInteger:self.head];
    [self.down addObject:change];
}
//左
-(void)leftSnake:(UIButton *)button
{
    self.headFeet = -1;
    NSNumber *change = [NSNumber numberWithInteger:self.head];
    [self.left addObject:change];
}
//右
-(void)rightSnake:(UIButton *)button
{
    self.headFeet = 1;
    NSNumber *change = [NSNumber numberWithInteger:self.head];
    [self.right addObject:change];
}
//死亡
-(void)snakeDead
{
    [self.snakeTime invalidate];
    UIAlertView *worning = [[UIAlertView alloc]initWithTitle:@"通知" message:@"你输了" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [worning show];
    [self.view addSubview:worning];
    [worning release];
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

@end
