//
//  Animal.m
//  KVOTest
//
//  Created by Sunell on 2018/11/2.
//  Copyright © 2018 Sunell. All rights reserved.
//

#import "Animal.h"
#import "Dog.h"

@implementation Animal
{
    NSString *name;
    Dog *dog;
}

-(instancetype)init{
    if (self == [super init]) {
        
    }
    return self;
}

-(id)valueForUndefinedKey:(NSString *)key{
    NSLog(@"找不到key回调这里");
    return nil;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"设置的key找不到回调这里");
}

+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key{
    BOOL automatic = NO;
    if ([key isEqualToString:@"animalName"]) {
        
        return automatic;
    }
    else {
        automatic = [super automaticallyNotifiesObserversForKey:key];
    }
    return automatic;
}

@end
