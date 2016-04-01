//
//  LCIMContactListController.m
//  LeanCloudIMKit-iOS
//
//  Created by ElonChan on 16/2/22.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import "LCIMContactListController.h"
#import "LCIMContactCell.h"
#import "LCIMKit_Internal.h"
#import "LCIMUser.h"
#import "LCIMUserSystemService.h"
#import "LCIMContactManager.h"
#import "LCIMKitExample.h"

static NSString *const LCIMContactListControllerIdentifier = @"LCIMContactListControllerIdentifier";

@interface LCIMContactListController ()

@property (nonatomic, strong) NSDictionary *sections;
@property (nonatomic, strong) NSArray *sortedSectionTitles;

@end

@implementation LCIMContactListController

#pragma mark -
#pragma mark - UIViewController Life

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系人";
    [self.tableView registerNib:[UINib nibWithNibName:@"LCIMContactCell" bundle:nil]
         forCellReuseIdentifier:LCIMContactListControllerIdentifier];
    self.tableView.separatorColor =[UIColor colorWithWhite:1.f*0xdf/0xff alpha:1.f];
    if ([self.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    [self.navigationItem setTitle:@"联系人"];
    
    if (self.mode == LCIMContactListModeNormal) {
        self.navigationItem.title = @"联系人";
        //TODO:
//        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索"
//                                                                                 style:UIBarButtonItemStylePlain
//                                                                                target:self
//                                                                                action:@selector(searchBarButtonItemPressed:)];
        
    } else {
        self.navigationItem.title = @"选择联系人";
        
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                        target:self
                                                                                        action:@selector(doneBarButtonItemPressed:)];
        
        self.navigationItem.rightBarButtonItem = doneButtonItem;
        [self.tableView setEditing:YES animated:NO];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.presentingViewController) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                          target:self
                                                                                          action:@selector(cancelBarButtonItemPressed:)];
        
        self.navigationItem.leftBarButtonItem = cancelButtonItem;
    }
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _sections = nil;
    _sortedSectionTitles = nil;
}

#pragma mark - tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)self.sortedSectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)section];
    NSArray *array = self.sections[sectionKey];
    return (NSInteger)array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCIMContactCell *cell = [tableView dequeueReusableCellWithIdentifier:LCIMContactListControllerIdentifier
                                                         forIndexPath:indexPath];
    
    NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
    NSArray *array = self.sections[sectionKey];
    NSString *peerId = array[(NSUInteger)indexPath.row];
    NSError *error = nil;
    cell.identifier = peerId;
    __block NSString *displayName = nil;
    __block NSURL *avatorURL = nil;
    [[LCIMUserSystemService sharedInstance] getCachedProfileIfExists:peerId name:&displayName avatorURL:&avatorURL error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    if (!displayName) {
        displayName = peerId;
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(cell) weakCell = cell;
        [[LCIMUserSystemService sharedInstance] getProfileInBackgroundForUserId:peerId callback:^(id<LCIMUserModelDelegate> user, NSError *error) {
            if (!error && [weakCell.identifier isEqualToString:user.userId]) {
                NSIndexPath *indexPath_ = [weakSelf.tableView indexPathForCell:weakCell];
                if (!indexPath_) {
                    return;
                }
                dispatch_async(dispatch_get_main_queue(),^{
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath_] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }];
    }
    NSString *subTitle = [NSString stringWithFormat:@"UserId:%@",peerId];
    [cell configureWithAvatorURL:avatorURL title:displayName subtitle:subTitle];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sortedSectionTitles[(NSUInteger)section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sortedSectionTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == LCIMContactListModeMultipleSelection) {
        return;
    }
    if (self.mode == LCIMContactListModeSingleSelection) {
        // 取消选中之前已选中的 cell
        NSMutableArray *selectedRows = [[tableView indexPathsForSelectedRows] mutableCopy];
        [selectedRows removeObject:indexPath];
        for (NSIndexPath *indexPath in selectedRows) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
    NSArray *array = self.sections[sectionKey];
    NSString *peerId = array[(NSUInteger)indexPath.row];
    [LCIMKitExample exampleOpenConversationViewControllerWithPeerId:peerId fromNavigationController:self.tabBarController.navigationController];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == LCIMContactListModeMultipleSelection || self.mode == LCIMContactListModeSingleSelection) {
        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.mode == LCIMContactListModeNormal) {
        NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
        NSMutableArray *array = self.sections[sectionKey];
        NSString *peerId = array[(NSUInteger)indexPath.row];
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //TODO:Add Alert
            // UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解除好友关系吗" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            // alertView.tag = indexPath.row;
            // [alertView show];
            [[LCIMContactManager defaultManager] removeContactForPeerId:peerId];
            [array removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
}

#pragma mark - Data

- (NSDictionary *)sections
{
    if (!_sections) {
        NSMutableDictionary *sections = [NSMutableDictionary dictionary];
        NSArray *personIDs = [[LCIMContactManager defaultManager] fetchContactPeerIds];
        for (NSString *userID in personIDs) {
            if ([self.excludedPersonIDs containsObject:userID]) {
                continue;
            }
            
            NSString *indexKey = [self indexTitleForName:userID];
            NSMutableArray *names = sections[indexKey];
            if (!names) {
                names = [NSMutableArray array];
                sections[indexKey] = names;
            }
            [names addObject:userID];
        }
        _sections = sections;
    }
    
    return _sections;
}

- (NSArray *)sortedSectionTitles
{
    if (!_sortedSectionTitles) {
        _sortedSectionTitles = [[self.sections allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }
    return _sortedSectionTitles;
}

- (NSString *)indexTitleForName:(NSString *)name {
    static NSString *otherKey = @"#";
    if (!name) {
        return otherKey;
    }
    
    NSMutableString *mutableString = [NSMutableString stringWithString:[name substringToIndex:1]];
    CFMutableStringRef mutableStringRef = (__bridge CFMutableStringRef)mutableString;
    CFStringTransform(mutableStringRef, nil, kCFStringTransformToLatin, NO);
    CFStringTransform(mutableStringRef, nil, kCFStringTransformStripCombiningMarks, NO);
    
    NSString *key = [[mutableString uppercaseString] substringToIndex:1];
    unichar capital = [key characterAtIndex:0];
    if (capital >= 'A' && capital <= 'Z') {
        return key;
    }
    return otherKey;
}

- (void)cancelBarButtonItemPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)doneBarButtonItemPressed:(id)sender {
    NSMutableArray *selectedIDs = [NSMutableArray array];
    NSArray *indexPathsForSelectedRows = [self.tableView indexPathsForSelectedRows];
    for (NSIndexPath *indexPath in indexPathsForSelectedRows) {
        NSString *sectionKey = self.sortedSectionTitles[(NSUInteger)indexPath.section];
        NSArray *array = self.sections[sectionKey];
        NSString *personId = array[(NSUInteger)indexPath.row];
        if (personId) {
            [selectedIDs addObject:personId];
        }
    }
    if ([self.delegate respondsToSelector:@selector(contactListController:didSelectPeerIds:)]) {
        [self.delegate contactListController:self didSelectPeerIds:[selectedIDs copy]];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//TODO:
//- (void)searchBarButtonItemPressed:(id)sender {
//    LCIMSearchContactViewController *controller = [[LCIMSearchContactViewController alloc] init];
//    [self.tabBarController.navigationController pushViewController:controller                                                       animated:YES];
//}
- (void)refresh {
    //TODO: add refesh
}

@end