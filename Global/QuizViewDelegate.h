

#ifndef GuidedVideo_QuizViewDelegate_h
#define GuidedVideo_QuizViewDelegate_h


@protocol QuizViewDelegate <NSObject>

@optional
- (BOOL)isEditableButtonAtTag:(NSInteger)tag;

@end

#endif
