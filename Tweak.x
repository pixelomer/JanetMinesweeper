#import <UIKit/UIKit.h>

@interface RCTView : UIView
@end

@interface JanetMinesweeper_GestureRecognizerTarget : NSObject
@end

@interface DCDChatInput : UITextView
- (UIViewController *)_viewControllerForAncestor;
@end

@implementation JanetMinesweeper_GestureRecognizerTarget

+ (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		UIView *commonSubview = (
			recognizer.view // Send
			.superview // Send
			.superview // Upload a media file
		);
		DCDChatInput *input = (
			commonSubview // Upload a media file
			.subviews[2] // System keyboard
			.subviews[0] // (no description)
			.subviews[0] // (no description)
		);
		NSLog(@"Input: %@", input);
		UIAlertController* alert = [UIAlertController
			alertControllerWithTitle:@"Insert minesweeper command?"
			message:nil
			preferredStyle:UIAlertControllerStyleAlert
		];
		[alert addAction:[UIAlertAction
			actionWithTitle:@"Yes"
			style:UIAlertActionStyleDefault
			handler:^(UIAlertAction * action){
				int safeX = arc4random_uniform(4) + 3;
				int safeY = arc4random_uniform(4) + 3;
				const int FIELD_SIZE = 13;
				const int BOMB_CELL = 9;
				uint8_t field[FIELD_SIZE][FIELD_SIZE];
				memset(field, 0, sizeof(field));
				int bombCount = 0;
				while (bombCount < FIELD_SIZE) {
					int bombX = arc4random_uniform(FIELD_SIZE);
					int bombY = arc4random_uniform(FIELD_SIZE);
					if ((field[bombX][bombY] == BOMB_CELL) ||
						(abs(bombX - safeX) < 2) || 
						(abs(bombY - safeY) < 2))
					{
						continue;
					}
					field[bombX][bombY] = BOMB_CELL;
					bombCount++;
				}

				for (int x=0; x<FIELD_SIZE; x++) {
					for (int y=0; y<FIELD_SIZE; y++) {
						if (field[x][y] == BOMB_CELL) continue;
						for (int sx = x-1; sx <= x+1; sx++) {
							if ((sx < 0) || (sx >= FIELD_SIZE)) continue;
							for (int sy = y-1; sy <= y+1; sy++) {
								if ((sy < 0) || (sy >= FIELD_SIZE)) continue;
								if (field[sx][sy] == BOMB_CELL) {
									field[x][y]++;
								}
							}
						}
					}
				}
				
				const char *emojis[] = {
					"zero", "one", "two", "three", "four",
					"five", "six", "seven", "eight", "bomb"
				};

				NSMutableString *text = [NSMutableString new];
				[text appendFormat:@"!userconf show ```\nMinesweeper! (%dx%d)\n```\n", FIELD_SIZE, FIELD_SIZE];
				for (int x=0; x<FIELD_SIZE; x++) {
					for (int y=0; y<FIELD_SIZE; y++) {
						const char *spoiler = ((x == safeX) && (y == safeY)) ? "" : "||";
						[text appendFormat:@"%s:%s:%s", spoiler, emojis[field[x][y]], spoiler];
					}
					[text appendFormat:@"\n"];
				}

				[text appendFormat:@"```\nGenerated by @pixelomer's tweak\n```"];

				input.text = text.copy;
			}
		]];
		[alert addAction:[UIAlertAction
			actionWithTitle:@"No"
			style:UIAlertActionStyleCancel
			handler:nil
		]];
		[input._viewControllerForAncestor
			presentViewController:alert
			animated:YES
			completion:nil
		];
	}
}

@end

%hook RCTView

- (void)didMoveToWindow {
	if ([self.accessibilityLabel isEqualToString:@"Send"] && self.backgroundColor) {
		UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc]
			initWithTarget:[JanetMinesweeper_GestureRecognizerTarget class]
			action:@selector(handleLongPress:)
		];
		[self addGestureRecognizer:recognizer];
	}
	%orig;
}

%end