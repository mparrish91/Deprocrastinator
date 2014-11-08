//
//  ViewController.m
//  Deprocrastinator
//
//  Created by malcolm on 10/23/14.
//  Copyright (c) 2014 parry. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property NSMutableArray *toDoItems;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger selectedRow;
@property NSIndexPath *indexPath;
@property NSMutableArray *selectedIndexes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.allowsMultipleSelection = YES;
    self.toDoItems = [NSMutableArray arrayWithObjects:@"clean", @"cook", @"laundry", @"shower", nil];
    self.selectedIndexes = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toDoCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.toDoItems objectAtIndex:indexPath.row];

    
    cell.accessoryType = UITableViewCellAccessoryNone;
    for (NSNumber *index in self.selectedIndexes) {
        NSUInteger num = [[self.selectedIndexes objectAtIndex:[self.selectedIndexes indexOfObject:index]] intValue];
        

        if (num == indexPath.row) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

            break;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedIndexes addObject:[NSNumber numberWithLong:indexPath.row]];
        
    }else if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.selectedIndexes removeObject:[NSNumber numberWithLong:indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Yes or No?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
        [alertView show];
        self.indexPath = indexPath;
        
    }
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.toDoItems removeObjectAtIndex:self.indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }else{
        [self.tableView setEditing:NO];
    }
}






- (IBAction)onRightGestureSwipe:(UISwipeGestureRecognizer *)gesture {
    
    CGPoint location = [gesture locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    if (indexPath) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell.textLabel.backgroundColor == [UIColor greenColor]) {
            cell.textLabel.backgroundColor = [UIColor yellowColor];
        }else if (cell.textLabel.backgroundColor == [UIColor yellowColor]){
            cell.textLabel.backgroundColor = [UIColor redColor];
        }else{
            cell.textLabel.backgroundColor = [UIColor greenColor];
        }
    
    }
}


@end
