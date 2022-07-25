//
//  DRBThemeModel.m
//  Pods-Renren-BaseKit_Example
//
//  Created by Ming on 2019/3/23.
//

#import "DRBThemeModel.h"

@implementation DRBThemeModel
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.bundleIdentifier forKey:@"bundleIdentifier"];
    [aCoder encodeObject:self.version forKey:@"version"];
    [aCoder encodeObject:self.build forKey:@"build"];
    [aCoder encodeObject:self.groups forKey:@"groups"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.bundleIdentifier = [aDecoder decodeObjectForKey:@"bundleIdentifier"];
        self.version = [aDecoder decodeObjectForKey:@"version"];
        self.build = [aDecoder decodeObjectForKey:@"build"];
        self.groups = [aDecoder decodeObjectForKey:@"groups"];
    }
    return self;
}

- (BOOL)addGroup:(DRBThemeModelGroup *)group {
    NSMutableArray *tempArray = nil;
    if (self.groups == nil) {
        tempArray = [NSMutableArray array];
    } else {
        tempArray = [NSMutableArray arrayWithArray:self.groups];
    }
    if (tempArray == nil) {
        return NO;
    }
    [tempArray addObject:group];
    self.groups = tempArray.copy;
    return YES;
}

-(DRBThemeModelGroup *)obtainGroupWithName:(NSString *)name {
    for (DRBThemeModelGroup *group in self.groups) {
        if ([group.name isEqualToString:name]) {
            return group;
        }
    }
    return nil;
}
@end

@implementation DRBThemeModelGroup
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.items forKey:@"items"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.items = [aDecoder decodeObjectForKey:@"items"];
    }
    return self;
}

- (void)addThemeItem:(DRBThemeModelItem *__nonnull)item {
    if (self.items == nil) {
        self.items = [NSMutableArray<DRBThemeModelItem *> array];
    }
    [self.items addObject:item];
}
- (DRBThemeModelItem *)obtainItemsWithName:(NSString *)name {
    for (DRBThemeModelItem *item in self.items) {
        if ([item.name isEqualToString:name]) {
            return item;
        }
    }
    return nil;
}

@end

@interface DRBThemeModelItem ()
/** Programs */
@property (nonatomic, strong,readwrite) NSMutableArray<DRBThemeModelProgram *> *programs;
/** 当前Program */
@property (nonatomic, strong,readwrite) DRBThemeModelProgram *currentProgram;
@end

@implementation DRBThemeModelItem
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.programs forKey:@"programs"];
    [aCoder encodeObject:self.currentProgram forKey:@"currentProgram"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.programs = [aDecoder decodeObjectForKey:@"programs"];
        self.currentProgram = [aDecoder decodeObjectForKey:@"currentProgram"];
    }
    return self;
}

- (BOOL)addProgram:(DRBThemeModelProgram *)program {
    if (program.name.length < 1) {
        return NO;
    }
    
    for (DRBThemeModelProgram *oldProgram in self.programs) {
        if ([oldProgram.name isEqualToString:program.name]) {
            return NO;
        }
    }
    [self.programs addObject:program];
    return YES;
}

- (BOOL)configurationProgramWithName:(NSString *)name {
    for (DRBThemeModelProgram *program in self.programs) {
        if ([program.name isEqualToString:name]) {
            self.currentProgram = program;
            return YES;
        }
    }
    return NO;
}

- (DRBThemeModelProgram *)obtaincurrentProgram {
    return self.currentProgram;
}

- (NSMutableArray<DRBThemeModelProgram *> *)programs {
    if (!_programs) {
        NSMutableArray<DRBThemeModelProgram *> *programs = [NSMutableArray<DRBThemeModelProgram *> array];
        _programs = programs;
    }
    return _programs;
}

@end

@interface DRBThemeModelProgram ()

@end

@implementation DRBThemeModelProgram
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.colorInfo forKey:@"colorInfo"];
    [aCoder encodeObject:self.fontInfo forKey:@"fontInfo"];
    [aCoder encodeObject:self.imageInfo forKey:@"imageInfo"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.colorInfo = [aDecoder decodeObjectForKey:@"colorInfo"];
        self.fontInfo = [aDecoder decodeObjectForKey:@"fontInfo"];
        self.imageInfo = [aDecoder decodeObjectForKey:@"imageInfo"];
    }
    return self;
}

- (DRBThemeModelColorInfo *)colorInfo {
    if (!_colorInfo) {
        DRBThemeModelColorInfo *colorInfo = [DRBThemeModelColorInfo new];
        _colorInfo = colorInfo;
    }
    return _colorInfo;
}

-(DRBThemeModelFontInfo *)fontInfo {
    if (!_fontInfo) {
        DRBThemeModelFontInfo *fontInfo = [DRBThemeModelFontInfo new];
        _fontInfo = fontInfo;
    }
    return _fontInfo;
}

-(DRBThemeModelImageInfo *)imageInfo {
    if (!_imageInfo) {
        DRBThemeModelImageInfo *imageInfo = [DRBThemeModelImageInfo new];
        _imageInfo = imageInfo;
    }
    return _imageInfo;
}

@end

@implementation DRBThemeModelColorInfo
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.color forKey:@"color"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.alpha] forKey:@"alpha"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.value = [aDecoder decodeObjectForKey:@"value"];
        self.color = [aDecoder decodeObjectForKey:@"color"];
        self.alpha = [[aDecoder decodeObjectForKey:@"alpha"] floatValue];
    }
    return self;
}
@end

@implementation DRBThemeModelFontInfo
#pragma mark - NSCopying
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.glyph forKey:@"glyph"];
    [aCoder encodeObject:self.font forKey:@"font"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.weight] forKey:@"weight"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.size] forKey:@"size"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.glyph = [aDecoder decodeObjectForKey:@"glyph"];
        self.font = [aDecoder decodeObjectForKey:@"font"];
        self.weight = [[aDecoder decodeObjectForKey:@"weight"] floatValue];
        self.size = [[aDecoder decodeObjectForKey:@"size"] floatValue];
    }
    return self;
}
@end

@implementation DRBThemeModelImageInfo

#pragma mark - NSCopying
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.width] forKey:@"width"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.height] forKey:@"height"];
    [aCoder encodeObject:self.image forKey:@"image"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.width = [[aDecoder decodeObjectForKey:@"width"] floatValue];
        self.height = [[aDecoder decodeObjectForKey:@"height"] floatValue];
        self.image = [aDecoder decodeObjectForKey:@"image"];
    }
    return self;
}

@end
