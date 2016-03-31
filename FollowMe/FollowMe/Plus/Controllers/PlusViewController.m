//
//  PlusViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "PlusViewController.h"
#import "RRSendMessageViewController.h"
#import "UICollectionViewCellPhoto.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobFile.h>
@interface PlusViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UITextView *message;
@property (nonatomic, strong) UICollectionView *myCollection;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation PlusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"记录";
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.message = [[UITextView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width / 2)];
    self.message.editable = false;
    self.message.backgroundColor = [UIColor whiteColor];
    self.message.text = @"请点击下方按钮，添加自己的生活点滴";
    self.message.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.message];
    
    
    //创建一个layout布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向,垂直方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    layout.itemSize = CGSizeMake(self.view.frame.size.width / 4 - 2, self.view.frame.size.width / 4 - 2);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;

    //section的边距
   // layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.myCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kWidth/2+30, kWidth, kWidth/2) collectionViewLayout:layout];
    self.myCollection.delegate = self;
    self.myCollection.dataSource = self;
    self.myCollection.backgroundColor = [UIColor clearColor];
     [self.myCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"photo"];
    [self.view addSubview:self.myCollection];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(30, kWidth + 50, kWidth-60, 50)];
    [sendButton setTitle:@"添加生活点滴" forState:UIControlStateNormal];
    sendButton.layer.borderWidth = 2.0;
    sendButton.layer.cornerRadius = 25;
    sendButton.clipsToBounds = YES;
    [sendButton setTitleColor:kMainColor forState:UIControlStateNormal];
    sendButton.backgroundColor = [UIColor whiteColor];
    sendButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [sendButton addTarget:self action:@selector(newMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:sendButton];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"8"]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.myCollection reloadData];
}
- (void) newMessage {
    RRSendMessageViewController *controller = [[RRSendMessageViewController alloc] init];
    
    [controller presentController:self blockCompletion:^(RRMessageModel *model, BOOL isCancel) {
        if (isCancel == true) {
            self.message.text = @"";
        }
        else {
            self.message.text = model.text;
            WLZLog(@"%@", model.photos);
            self.array = model.photos;
            [self addArray:model.text];
        }
        [controller dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)addArray:(NSString *)string{
    BmobUser *user = [BmobUser getCurrentUser];
    WLZLog(@"%@", user.username);
    NSMutableArray *allArray = [NSMutableArray arrayWithArray:[user objectForKey:@"array"]];
       NSMutableArray *titleArray = [NSMutableArray arrayWithArray:[user objectForKey:@"titlwArray"]];
    WLZLog(@"%@", titleArray);
    NSMutableArray *imageArray = [NSMutableArray new];
    for (UIImage *image in self.array) {
        NSData *imageData = UIImagePNGRepresentation(image);
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *imagePath = [documentPath stringByAppendingString:@"/image.da"];
        //写入
        [imageData writeToFile:imagePath atomically:YES];
        BmobFile *file1 = [[BmobFile alloc] initWithFilePath:imagePath];
        [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
            //如果文件保存成功，则把文件添加到filetype列
            if (isSuccessful) {
                [user setObject:file1  forKey:@"filetype"];
                [user setObject:file1.url forKey:@"imageUrl"];
                [imageArray addObject:file1.url];
                [user updateInBackground];
                //打印file文件的url地址
                [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
            }else{
                //进行处理
            }
            if (imageArray) {
                [allArray addObject:imageArray];
            }else{
                [allArray addObject:@[@"http://file.bmob.cn/M03/05/18/oYYBAFb6hRuAIYwqAABd6nKUys06100.da"]];
            }

        }];
    }
    if ([string isEqualToString:@""]) {
        [titleArray addObject:string];
    }else{
        [titleArray addObject:@[@"记录生活点滴"]];
    }
    WLZLog(@"%@", titleArray);
    [user setObject:titleArray forKey:@"titlwArray"];
    [user setObject:allArray forKey:@"array"];
    NSLog(@"%lu", imageArray.count);

    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            WLZLog(@"%d", isSuccessful);
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"保存失败,请检查自己是否登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [alert show];
        }
    }];

    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    WLZLog(@"%ld", self.array.count);
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(3, 0, kWidth/4-10, kWidth/4-10)];
    view.image = self.array[indexPath.row];
    [cell addSubview:view];
    return cell;
}

- (NSMutableArray *)array{
    if (_array == nil) {
        self.array = [NSMutableArray new];
    }
    return _array;
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
