//
//  ViewController.m
//  KVOTest
//
//  Created by Sunell on 2018/11/2.
//  Copyright © 2018 Sunell. All rights reserved.
//

#import "ViewController.h"
#import "Animal.h"

@interface ViewController ()
{
    Animal *animal;
    __weak IBOutlet UILabel *label;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    animal = [[Animal alloc] init];
    [animal addObserver:self forKeyPath:@"animalName" options:NSKeyValueObservingOptionNew context:nil];
    /**
     kvo在监听对象的成员变量时，底层实现是：
     运行时会生成一个继承自Animal的类，名为NSKVONotifying_Animal，然后重写被监控的属性setter方法，该方法里面会调用willChangeValueForKey和didChangeValueForKey方法，其实就是记录旧值和新值，这两个方法调用完后系统默认会回调到observeValueForKeyPath这个方法里面
     
     如果不想自动触发kvo，可以在被监听对象里面重写类方法+(BOOL)automaticallyNotifiesObserversForKey，return NO，这样在改变被监听属性值时不会回调到observeValueForKeyPath方法中
     不想自动触发，可以手动触发，前提是关闭了自动触发（上面的return NO），然后在对被监听的属性赋值前加上方法[animal willChangeValueForKey:@"animalName"];，赋值后加上方法[animal didChangeValueForKey:@"animalName"];，这样就会回调到observeValueForKeyPath方法中
     */
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    static int count = 0;
    count ++;
//    [animal setValue:[NSString stringWithFormat:@"%d",count] forKey:@"animalName"];
    //该方法是记录旧值
    [animal willChangeValueForKey:@"animalName"];
    animal.animalName = @"手动调用";
//    记录新值
    [animal didChangeValueForKey:@"animalName"];
}



-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@\n%@",change,keyPath);
    if ([keyPath isEqualToString:@"animalName"]) {
//        当animal对象中的成员变量发生变化后回调这里，必须要通过.点语法或者kvc来改变animal属性的值才会回调，也就是必须调用该属性的setter方法，使用_下划线属性的方式赋值是不会回调到这里的
        label.text = [change objectForKey:NSKeyValueChangeNewKey];
        NSString *name = [animal valueForKey:@"animalName"];
        NSLog(@"%@",name);
        
//        造成无线循环
//        [animal setValue:@"不能在回调内部改变被监听成员变量的值，这样将造成死循环" forKey:@"animalName"];
    }
}

@end
