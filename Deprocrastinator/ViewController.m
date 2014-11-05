//
//  ViewController.m
//  Deprocrastinator
//
//  Created by malcolm on 10/23/14.
//  Copyright (c) 2014 parry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *toDoItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger selectedRow;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.toDoItems = [NSMutableArray arrayWithObjects:@"clean", @"cook", @"laundry", @"shower", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.toDoItems objectAtIndex:indexPath.row];
    
    if (indexPath.row == self.selectedRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selected = YES;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selected = NO;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.toDoItems.count;
}
- (IBAction)onAddButtonPressed:(id)sender {
    
    NSString *newToDoItem = self.textField.text;
    [self.toDoItems addObject:newToDoItem];
    [self.tableView reloadData];
    
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    
}

- (IBAction)onEditButtonPressed:(UIButton*)sender {
    [sender setTitle:@"Done" forState:UIControlStateNormal];
    [self.tableView setEditing:YES animated:YES];

    
    if ([sender.titleLabel.text isEqual: @"Done"]) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = indexPath.row;
    [self.tableView reloadData];
}



- (IBAction)onRightGestureSwipe:(id)sender {
    
}


@end
