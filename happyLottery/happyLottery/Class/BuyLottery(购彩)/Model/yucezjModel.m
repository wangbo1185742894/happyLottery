



#import "yucezjModel.h"

@implementation yucezjModel


-(id)initWith:(NSDictionary*)dic{
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dic];
    }
    
    return self;
}

-(void)setValue:(id)value forKey:(NSString *)key{
    NSString *strValue = [NSString stringWithFormat:@"%@",value];
    [super setValue:strValue forKey:key];
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"* %@,",key);
}

@end


