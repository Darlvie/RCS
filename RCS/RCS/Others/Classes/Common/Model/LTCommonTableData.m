//
//  LTCommonTableData.m
//  RCS
//
//  Created by zyq on 15/12/22.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTCommonTableData.h"

#define DefaultUIRowHeight  50.f
#define DefaultUIHeaderHeight  44.f
#define DefaultUIFooterHeight  44.f

@implementation LTCommonTableSection

- (instancetype)initWithDict:(NSDictionary *)dict {
    if ([dict[Disable] boolValue]) {
        return nil;
    }
    
    if (self = [super init]) {
        _headerTitle = dict[HeaderTitle];
        _footerTitle = dict[FooterTitle];
        _uiFooterHeight = [dict[FooterHeight] floatValue];
        _uiHeaderHeight = [dict[HeaderHeight] floatValue];
        _uiHeaderHeight = _uiHeaderHeight ? _uiHeaderHeight : DefaultUIHeaderHeight;
        _uiFooterHeight = _uiFooterHeight ? _uiFooterHeight : DefaultUIFooterHeight;
        _rows = [LTCommonTableRow rowsWithData:dict[RowContent]];

    }
    return self;
}

+ (NSArray *)sectionsWithData:(NSArray *)data {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            LTCommonTableSection *section = [[LTCommonTableSection alloc] initWithDict:dict];
            if (section) {
                [array addObject:section];
            }
        }
    }
    return array;
}

@end

@implementation LTCommonTableRow

- (instancetype)initWithDict:(NSDictionary *)dict {
    if ([dict[Disable] boolValue]) {
        return nil;
    }
    
    if (self = [super init]) {
        _title          = dict[Title];
        _detailTitle    = dict[DetailTitle];
        _cellClassName  = dict[CellClass];
        _cellActionName = dict[CellAction];
        _uiRowHeight    = dict[RowHeight] ? [dict[RowHeight] floatValue] : DefaultUIRowHeight;
        _extraInfo      = dict[ExtraInfo];
        _sepLeftEdge    = [dict[SepLeftEdge] floatValue];
        _showAccessory  = [dict[ShowAccessory] boolValue];
        _forbidSelect   = [dict[ForbidSelect] boolValue];

    }
    return self;
}

+ (NSArray *)rowsWithData:(NSArray *)data {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:data.count];
    for (NSDictionary *dict in data) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            LTCommonTableRow *row = [[LTCommonTableRow alloc] initWithDict:dict];
            if (row) {
                [array addObject:row];
            }
        }
    }
    return array;
}

@end


















