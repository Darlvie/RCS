//
//  LTGroupedDataCollection.h
//  RCS
//
//  Created by zyq on 15/12/18.
//  Copyright © 2015年 BGXT. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol LTGroupedMemberProtocol <NSObject>

- (NSString *)groupTitle;
- (NSString *)memberId;
- (id)sortKey;

@end

@interface LTGroupedDataCollection : NSObject

@property (nonatomic,strong) NSArray *members;
@property (nonatomic,copy) NSComparator groupTitleComparator;
@property (nonatomic,copy) NSComparator groupMemberComparator;
@property (nonatomic,strong,readonly) NSArray *sortedGroupTitles;

- (void)addGroupMember:(id<LTGroupedMemberProtocol>)member;

- (void)removerGroupMember:(id<LTGroupedMemberProtocol>)member;

- (void)addGroupAboveWithTitle:(NSString *)title members:(NSArray *)members;

- (NSString *)titleOfGroup:(NSInteger)groupIndex;

- (NSArray *)membersOfGroup:(NSInteger)groupIndex;

- (id<LTGroupedMemberProtocol>)memberOfIndex:(NSIndexPath *)indexPath;

- (id<LTGroupedMemberProtocol>)memberOfId:(NSString *)uid;

- (NSInteger)groupCount;

- (NSInteger)memberCountOfGroup:(NSInteger)groupIndex;


@end
