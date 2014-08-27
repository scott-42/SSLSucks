//  Created by Scott Gustafson on 3/14/14.
//  Copyright (c) 2014 Garlic Software LLC. All rights reserved.
//

#import "HTTPSViewController.h"

@interface HTTPSViewController () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *state;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *cctype;
@property (weak, nonatomic) IBOutlet UITextField *ccnumber;
@property (weak, nonatomic) IBOutlet UITextField *ccexpiremonth;
@property (weak, nonatomic) IBOutlet UITextField *ccexpireyear;
@property (weak, nonatomic) IBOutlet UITextField *cccvv2;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end

@implementation HTTPSViewController

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.scroller setContentSize:self.scroller.frame.size];
	[self.scroller setContentInset:UIEdgeInsetsZero];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification*)aNotification {
	NSDictionary* info = [aNotification userInfo];
	CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
	NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		self.scroller.contentInset = contentInsets;
		self.scroller.scrollIndicatorInsets = contentInsets;
	} completion:nil];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
	UIEdgeInsets contentInsets = UIEdgeInsetsZero;
	NSDictionary* info = [aNotification userInfo];
	NSTimeInterval duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
		self.scroller.contentInset = contentInsets;
		self.scroller.scrollIndicatorInsets = contentInsets;
	} completion:nil];
}

#pragma mark - Text Input

- (IBAction)nameEndEditing:(id)sender {
	[self.address becomeFirstResponder];
}

- (IBAction)addressEndEditing:(id)sender {
	[self.city becomeFirstResponder];
}

- (IBAction)cityEndEditing:(id)sender {
	[self.state becomeFirstResponder];
}

- (IBAction)stateEndEditing:(id)sender {
	[self.phone becomeFirstResponder];
}

- (IBAction)phoneNumberEndEditing:(id)sender {
	[self.cctype becomeFirstResponder];
}

- (IBAction)ccTypeEndEditing:(id)sender {
	[self.ccnumber becomeFirstResponder];
}

- (IBAction)ccNumberEndEditing:(id)sender {
	[self.ccexpiremonth becomeFirstResponder];
}

- (IBAction)ccExpireMonthEndEditing:(id)sender {
	[self.ccexpireyear becomeFirstResponder];
}

- (IBAction)ccExpireYearEndEditing:(id)sender {
	[self.cccvv2 becomeFirstResponder];
}

- (IBAction)lastItemDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)sendButtonHit:(id)sender {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.garlicsoftware.com/scott/responder.cgi"]];
	
	[request setHTTPMethod:@"POST"];
	[request addValue:[self.name text] forHTTPHeaderField:@"X-CUSTOM-Name"];
	[request addValue:[self.address text] forHTTPHeaderField:@"X-CUSTOM-Address"];
	[request addValue:[self.city text] forHTTPHeaderField:@"X-CUSTOM-City"];
	[request addValue:[self.state text] forHTTPHeaderField:@"X-CUSTOM-State"];
	[request addValue:[self.phone text] forHTTPHeaderField:@"X-CUSTOM-Phone"];
	[request addValue:[self.cctype text] forHTTPHeaderField:@"X-CUSTOM-CCType"];
	[request addValue:[self.ccnumber text] forHTTPHeaderField:@"X-CUSTOM-CCNumber"];
	[request addValue:[self.ccexpiremonth text] forHTTPHeaderField:@"X-CUSTOM-CCExpireMonth"];
	[request addValue:[self.ccexpireyear text] forHTTPHeaderField:@"X-CUSTOM-CCExpireYear"];
	[request addValue:[self.cccvv2 text] forHTTPHeaderField:@"X-CUSTOM-CCCVV2"];

	[NSURLConnection connectionWithRequest:request delegate:self];

	// for demonstration purposes, this code is removed from the app
	// this allows me to connect to a proxy with a self-signed certificate
//	NSURLResponse *response;
//	NSError *error;
//	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//	
//	if (data) {
////		NSLog(@"data: %@", data);
//		NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//		NSLog(@"%@", string);
//	}
////	NSLog(@"response: %@", response);
//	if (error) {
//		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please retry" message:@"An error occured sending the data." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		NSLog(@"error: %@", error);
//	} else {
//		UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message Sent" message:@"The data has been sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alert show];
//		[[self navigationController] popToRootViewControllerAnimated:YES];
//	}
}

#pragma mark - NSURLConnectionDelegate

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	
//	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSString *html = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
	NSLog(@"data: %@", html);
}

@end
