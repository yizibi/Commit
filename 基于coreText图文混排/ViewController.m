//
//  ViewController.m
//  基于coreText图文混排
//
//  Created by hspcadmin on 2017/8/10.
//  Copyright © 2017年 hspcadmin. All rights reserved.
//

#import "ViewController.h"
#import "LXCTTextData.h"
#import "LXCTFrameSettingConfig.h"
#import "LXCTDisplayView.h"
#import "LXCTFrameSeting.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet LXCTDisplayView *titleView;

@property (weak, nonatomic) IBOutlet LXCTDisplayView *ctView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    LXCTFrameSettingConfig *configTitle = [[LXCTFrameSettingConfig alloc] init];
//    configTitle.ct_textColor = [UIColor purpleColor];
//    configTitle.ct_width = self.ctView.bounds.size.width;
//    LXCTTextData *dataTitle = [LXCTFrameSeting frameSettingWithContent:@"Hello liluxin! I love U" config:configTitle];
//    
//    self.titleView.data = dataTitle;
//    self.titleView.lx_height = dataTitle.ct_Height;
    
    LXCTFrameSettingConfig *config = [[LXCTFrameSettingConfig alloc] init];
    config.ct_width = self.ctView.lx_width;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
    LXCTTextData *data = [LXCTFrameSeting frameSettingWithTempleFilePath:path config:config];
    self.ctView.data = data;
    self.ctView.lx_height = data.ct_Height;
    self.ctView.backgroundColor = [UIColor whiteColor];
    
    
    
}


- (void)lx_simpleTestCoretext{
    
    
    LXCTFrameSettingConfig *config = [[LXCTFrameSettingConfig alloc] init];
    config.ct_width = self.ctView.lx_width;
    config.ct_textColor = [UIColor blackColor];
    
    
    NSString *content =
    @"对于上面的例子，我们给 CTFrameParser 增加了一个将 NSString 转 "
    " 换为 CoreTextData 的方法。"
    " 但这样的实现方式有很多局限性，因为整个内容虽然可以定制字体 "
    " 大小，颜色，行高等信息，但是却不能支持定制内容中的某一部分。"
    " 例如，如果我们只想让内容的前三个字显示成红色，而其它文字显 "
    " 示成黑色，那么就办不到了。"
    "\n\n"
    " 解决的办法很简单，我们让`CTFrameParser`支持接受 "
    "NSAttributeString 作为参数，然后在 NSAttributeString 中设置好 "
    " 我们想要的信息。";
    
    NSDictionary *attributes = [LXCTFrameSeting attributesWithConfig:config];
    
    NSMutableAttributedString *attrbuteString = [[NSMutableAttributedString alloc] initWithString:content attributes:attributes];
    
    [attrbuteString addAttribute:(__bridge id)kCTForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 7)];
    
    LXCTTextData *data = [LXCTFrameSeting frameSettingWithAttributedContent:attrbuteString config:config];
    
    self.ctView.data = data;
    self.ctView.lx_height = data.ct_Height;
    self.ctView.backgroundColor = [UIColor yellowColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
