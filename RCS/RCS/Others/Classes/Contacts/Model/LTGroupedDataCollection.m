//
//  LTGroupedDataCollection.m
//  RCS
//
//  Created by zyq on 15/12/18.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import "LTGroupedDataCollection.h"
#import "NIMSDK.h"

@interface Pair : NSObject

@property (nonatomic,strong) id first;
@property (nonatomic,strong) id second;
@end

@implementation Pair

- (instancetype)initWithFirst:(id)first second:(id)second {
    if (self = [super init]) {
        _first = first;
        _second = second;
    }
    return self;
}

@end

@interface LTGroupedDataCollection ()
{
    NSMutableOrderedSet *_specialGroupTitles;
    NSMutableOrderedSet *_specialGroups;
    NSMutableOrderedSet *_groupTitles;
    NSMutableOrderedSet *_groups;
}

@end

@implementation LTGroupedDataCollection

- (instancetype)init {
    if (self = [super init]) {
        _specialGroupTitles = [[NSMutableOrderedSet alloc] init];
        _specialGroups = [[NSMutableOrderedSet alloc] init];
        _groupTitles = [[NSMutableOrderedSet alloc] init];
        _groups = [[NSMutableOrderedSet alloc] init];
    }
    return self;
}

- (NSArray *)sortedGroupTitles {
    return [_groupTitles array];
}

- (void)setMembers:(NSArray *)members {
    NSMutableDictionary *tmp = [NSMutableDictionary dictionary];
    NSString *me = [[NIMSDK sharedSDK].loginManager currentAccount];
    for (id<LTGroupedMemberProtocol> member in members) {
        if ([[member memberId] isEqualToString:me]) {
            continue;
        }
        
        NSString *groupTitle = [member groupTitle];
        NSMutableArray *groupMembers = [tmp objectForKey:groupTitle];
        if (!groupMembers) {
            groupMembers = [NSMutableArray array];
        }
        [groupMembers addObject:member];
        [tmp setObject:groupMembers forKey:groupTitle];
    }
    
    [_groupTitles removeAllObjects];
    [_groups removeAllObjects];
    
    [tmp enumerateKeysAndObjectsUsingBlock:^(NSString *groupTitle,NSMutableArray *groupedMembers, BOOL *stop) {
        if (groupTitle.length) {
            unichar character = [groupTitle characterAtIndex:0];
            if (character >= 'A' && character <= 'Z') {
                [_groupTitles addObject:groupTitle];
            } else {
                [_groupTitles addObject:@"#"];
            }
            [_groups addObject:[[Pair alloc] initWithFirst:groupTitle second:groupedMembers]];
        }
    }];
    [self sort];
}

- (void)addGroupMember:(id<LTGroupedMemberProtocol>)member {
    NSString *groupTitle = [member groupTitle];
    NSInteger groupIndex = [_groupTitles indexOfObject:groupTitle];
    Pair *pair = [_groups objectAtIndex:groupIndex];
    if (!pair) {
        NSMutableArray *members = [NSMutableArray array];
        pair = [[Pair alloc] initWithFirst:groupTitle second:members];
    }
    NSMutableArray *members = pair.second;
    [members addObject:member];
    [_groupTitles addObject:groupTitle];
    [_groups addObject:pair];
    [self sort];
}

- (void)removerGroupMember:(id<LTGroupedMemberProtocol>)member {
    NSString *groupTitle = [member groupTitle];
    NSInteger groupIndex = [_groupTitles indexOfObject:groupTitle];
    Pair *pair = [_groups objectAtIndex:groupIndex];
    [pair.second removeObject:member];
    if (![pair.second count]) {
        [_groups removeObject:pair];
    }
    [self sort];
}

- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members {
    Pair *pair = [[Pair alloc] initWithFirst:title second:members];
    [_specialGroupTitles addObject:title];
    [_specialGroups addObject:pair];
}

- (NSString *)titleOfGroup:(NSInteger)groupIndex {
    if (groupIndex >= 0 && groupIndex < _specialGroupTitles.count) {
        return [_specialGroupTitles objectAtIndex:groupIndex];
    }
    groupIndex -= _specialGroupTitles.count;
    if (groupIndex >= 0 && groupIndex < _groupTitles.count) {
        return [_groupTitles objectAtIndex:groupIndex];
    }
    return nil;
}

- (NSArray *)membersOfGroup:(NSInteger)groupIndex {
    if (groupIndex >= 0 && groupIndex < _specialGroups.count) {
        Pair *pair = [_specialGroups objectAtIndex:groupIndex];
        return pair.second;
    }
    groupIndex -= _specialGroups.count;
    if (groupIndex >= 0 && groupIndex < _groups.count) {
        Pair *pair = [_groups objectAtIndex:groupIndex];
        return pair.second;
    }
    return nil;
}

- (id<LTGroupedMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath {
    NSArray *members = nil;
    NSInteger groupIndex = indexPath.section;
    if (groupIndex >= 0 && groupIndex < _specialGroups.count) {
        Pair *pair = [_specialGroups objectAtIndex:groupIndex];
        members = pair.second;
    }
    groupIndex -= _specialGroups.count;
    if (groupIndex >= 0 && groupIndex < _groups.count) {
        Pair *pair = [_groups objectAtIndex:groupIndex];
        members = pair.second;
    }
    NSInteger memberIndex = indexPath.row;
    if (memberIndex < 0 || memberIndex >= members.count) {
        return nil;
    }
    return [members objectAtIndex:memberIndex];
}

- (id<LTGroupedMemberProtocol>)memberOfId:(NSString *)uid {
    for (Pair *pair in _groups) {
        NSArray *members = pair.second;
        for (id<LTGroupedMemberProtocol> member in members) {
            if ([[member memberId] isEqualToString:uid]) {
                return member;
            }
        }
    }
    return nil;
}

- (NSInteger)groupCount {
    return _specialGroupTitles.count + _groupTitles.count;
}

- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex {
    NSArray *members = nil;
    if (groupIndex >= 0 && _specialGroups.count) {
        Pair *pair = [_specialGroups objectAtIndex:groupIndex];
        members = pair.second;
    }
    groupIndex -= _specialGroups.count;
    if (groupIndex >= 0 && groupIndex < _groups.count) {
        Pair *pair = [_groups objectAtIndex:groupIndex];
        members  = pair.second;
    }
    return members.count;
}

- (void)sort {
    [self sortGroupTitle];
    [self sortGroupMember];
}

- (void)sortGroupTitle {
    [_groupTitles sortUsingComparator:_groupTitleComparator];
    [_groups sortUsingComparator:^NSComparisonResult(Pair *pair1, Pair *pair2) {
        return _groupTitleComparator(pair1.first,pair2.first);
    }];
}

- (void)sortGroupMember {
    [_groups enumerateObjectsUsingBlock:^(Pair *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *groupMembers = obj.second;
        [groupMembers sortUsingComparator:^NSComparisonResult(id<LTGroupedMemberProtocol> member1, id<LTGroupedMemberProtocol> member2) {
            return _groupMemberComparator([member1 sortKey],[member2 sortKey]);
        }];
    }];
}

- (void)setGroupTitleComparator:(NSComparator)groupTitleComparator {
    _groupTitleComparator = groupTitleComparator;
    [self sortGroupTitle];
}

- (void)setGroupMemberComparator:(NSComparator)groupMemberComparator {
    _groupMemberComparator = groupMemberComparator;
    [self sortGroupMember];
}












@end
