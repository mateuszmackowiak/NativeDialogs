/*
 * NativeDialogs
 *
 * Created by Mateusz Mackowiak on 02.02.2013.
 * Copyright (c) 2013 __MyCompanyName__. All rights reserved.
 */

#import "FlashRuntimeExtensions.h"
#import "NativeDialogControler.h"
#import "SVProgressHUD.h"
#import "SlideNotification.h"

#define MYDEBUG

#pragma mark - dialog methods


DEFINE_ANE_FUNCTION(showAlertWithTitleAndMessage){
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.

    const uint8_t *title;
    uint32_t stringLength;
    const uint8_t *message;
    const uint8_t *closeLabel;
    const uint8_t *otherLabels;
    
    //Turn our actionscrpt code into native code.
    FREGetObjectAsUTF8(argv[0], &stringLength, &title);
    FREGetObjectAsUTF8(argv[1], &stringLength, &message);
    FREGetObjectAsUTF8(argv[2], &stringLength, &closeLabel);
    FREGetObjectAsUTF8(argv[3], &stringLength, &otherLabels);
    
    //Create our Strings for our Alert.
    NSString *titleString = [NSString stringWithUTF8String:(char*)title];
    NSString *messageString = [NSString stringWithUTF8String:(char*)message];
    NSString *closeLabelString = [NSString stringWithUTF8String:(char*)closeLabel];
    NSString *otherLabelsString = [NSString stringWithUTF8String:(char*)otherLabels];
    
    
    [nativeDialogController showAlertWithTitle:titleString
                      message:messageString
                   closeLabel:closeLabelString
                  otherLabels:otherLabelsString];
    return NULL;
}

DEFINE_ANE_FUNCTION(showListDialog){
    NativeDialogControler *nativeDialogController = functionData;
    
    //Temporary values to hold our actionscript code.
    uint32_t stringLength;
    const uint8_t *title;
    const uint8_t *message;
    
    
    NSString *titleString = nil;
    NSString *messageString =nil;
    
    if(argv[0] && (FREGetObjectAsUTF8(argv[0], &stringLength, &title)==FRE_OK)){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    if(argv[1] && (FREGetObjectAsUTF8(argv[1], &stringLength, &message)==FRE_OK)){
        messageString = [NSString stringWithUTF8String:(char*)message];
    }
    
    [nativeDialogController showSelectDialogWithTitle:titleString message:messageString options:argv[3] checked: argv[4] buttons:argv[2] ];

    return NULL;
}


DEFINE_ANE_FUNCTION(showTextInputDialog)
{
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.
    uint32_t stringLength;
    const uint8_t *title;
    const uint8_t *message;
    
    //Create our Strings for our Alert.
    
    
    NSString *titleString = nil;
    NSString *messageString =nil;
    
    if(argv[0] &&  (FREGetObjectAsUTF8(argv[0], &stringLength, &title)==FRE_OK)){
        titleString = [NSString stringWithUTF8String:(char*)title];
    }
    if(argv[1] &&  FREGetObjectAsUTF8(argv[1], &stringLength, &message)==FRE_OK){
        messageString = [NSString stringWithUTF8String:(char*)message];
    }
    [nativeDialogController showTextInputDialog:titleString message:messageString textInputs:argv[2] buttons:argv[3]];
    
    
    return nil;
}

DEFINE_ANE_FUNCTION(isShowing){
    NativeDialogControler *nativeDialogController = functionData;

    FREObject returnVal;
    FRENewObjectFromBool([nativeDialogController isShowing], &returnVal);
    
    return returnVal;
}



DEFINE_ANE_FUNCTION(updateMessage){
    NativeDialogControler *nativeDialogController = functionData;
    
    uint32_t messageLength;
    const uint8_t *message;
    
    //Turn our actionscrpt code into native code.
    FREGetObjectAsUTF8(argv[0], &messageLength, &message);
    
    [nativeDialogController updateMessage:[NSString stringWithUTF8String:(char*)message]];
    return nil;
}




DEFINE_ANE_FUNCTION(updateTitle){
    NativeDialogControler *nativeDialogController = functionData;
    
    uint32_t titleLength;
    const uint8_t *title;
    
    //Turn our actionscrpt code into native code.
    FREGetObjectAsUTF8(argv[0], &titleLength, &title);
    
    [nativeDialogController updateTitle:[NSString stringWithUTF8String:(char*)title]];
    return nil;
}



DEFINE_ANE_FUNCTION(shake){
     NativeDialogControler *nativeDialogController = functionData;
    [nativeDialogController shake];
    return nil;
}

DEFINE_ANE_FUNCTION(dismiss){
    NativeDialogControler *nativeDialogController = functionData;
    int32_t index;
    FREGetObjectAsInt32(argv[0], &index);
    
    [nativeDialogController dismissWithButtonIndex:index];
    [SVProgressHUD dismiss];
    return nil;
}


DEFINE_ANE_FUNCTION(showProgressPopup){
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.
    uint32_t stringLength;
    
    const uint8_t *title = nil;
    const uint8_t *message = nil;
    double progressParam;
    
    uint32_t showActivityValue, cancleble;
    int32_t style,theme;
    //Turn our actionscrpt code into native code.
    FREGetObjectAsDouble(argv[0], &progressParam);
    ///Secondary progress ignored
    FREGetObjectAsInt32(argv[2], &style);
    if(argv[3])
        FREGetObjectAsUTF8(argv[3], &stringLength, &title);
    if(argv[4])
        FREGetObjectAsUTF8(argv[4], &stringLength, &message);
    FREGetObjectAsBool(argv[5], &cancleble);
    FREGetObjectAsBool(argv[6], &showActivityValue);
    FREGetObjectAsInt32(argv[7], &theme);
    
    //Create our Strings for our Alert.
    NSInteger styleValue=(NSInteger)style;
    NSString *titleString = nil;
    if(title)
        titleString = [NSString stringWithUTF8String:(char*)title];
    NSString *messageString = nil;
    if(message)
        messageString =[NSString stringWithUTF8String:(char*)message];
    
    NSNumber *progressValue =[NSNumber numberWithDouble:progressParam];
    
    if(theme == 2){
        if(messageString && ![messageString isEqualToString:@""])
            if(cancleble)
                [SVProgressHUD showWithStatus:messageString];
            else
                [SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeBlack];
            else {
                if (cancleble)
                    [SVProgressHUD show];
                else
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            }
    
    }else if(theme == 3){
        if(messageString && ![messageString isEqualToString:@""])
            if(cancleble)
                [SVProgressHUD showWithStatus:messageString];
            else
                [SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeClear];
            else {
                if (cancleble)
                    [SVProgressHUD show];
                else
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
            }
    }else if(theme == 4){
        if(messageString && ![messageString isEqualToString:@""])
            if(cancleble)
                [SVProgressHUD showWithStatus:messageString];
            else
                [SVProgressHUD showWithStatus:messageString maskType:SVProgressHUDMaskTypeGradient];
            else {
                if (cancleble)
                    [SVProgressHUD show];
                else
                    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
            }
    }else{

        [nativeDialogController showProgressPopup:titleString
                           style:styleValue
                         message:messageString
                        progress:progressValue
                    showActivity:showActivityValue
                       cancleble:cancleble];
    }
    return nil;
}
DEFINE_ANE_FUNCTION(updateProgress){
    NativeDialogControler *nativeDialogController = functionData;
    //Temporary values to hold our actionscript code.
    double perc;
    //Turn our actionscrpt code into native code.
    if(FREGetObjectAsDouble(argv[0], &perc)==FRE_OK)
        [nativeDialogController updateProgress:perc];
    //Create our Strings for our Alert.
    return nil;
}

DEFINE_ANE_FUNCTION(showDatePicker){
    NativeDialogControler *nativeDialogController = functionData;
    uint32_t stringLength;
    
    const uint8_t *title = nil;
    const uint8_t *message = nil;
    const uint8_t *style = nil;
    
    FREGetObjectAsUTF8(argv[0], &stringLength, &title);
    FREGetObjectAsUTF8(argv[1], &stringLength, &message);
    
    FREGetObjectAsUTF8(argv[4], &stringLength, &style);
    
    double date;
    FREGetObjectAsDouble(argv[2], &date);
    
    NSString *titleString = nil;
    if(title)
        titleString = [NSString stringWithUTF8String:(char*)title];
    NSString *messageString = nil;
    if(message)
        messageString =[NSString stringWithUTF8String:(char*)message];
    
    
    [nativeDialogController showDatePickerWithTitle:titleString andMessage:messageString andDate:date andStyle:style andButtons:argv[3]];
    uint32_t cancelable;
    FREGetObjectAsBool(argv[6], &cancelable);
    [nativeDialogController setCancelable:cancelable];
    return nil;
}
DEFINE_ANE_FUNCTION(setDate){
    NativeDialogControler *nativeDialogController = functionData;
    
    double timeStamp;
    FREGetObjectAsDouble(argv[0], &timeStamp);

    [nativeDialogController updateDateWithTimestamp:timeStamp];
    return nil;
}

DEFINE_ANE_FUNCTION(setCancelable){
    NativeDialogControler *nativeDialogController = functionData;
    
    uint32_t cancelable;
    FREGetObjectAsBool(argv[0], &cancelable);
    
    [nativeDialogController setCancelable:cancelable];
    return nil;
}

#pragma mark - Toast


FREObject showToast(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    if(argc<2 || !argv || !argv[0] || !argv[1])
        return nil;
    
    uint32_t messageLength;
    const uint8_t *message;
    double dur;
    FREGetObjectAsDouble(argv[1], &dur);
    
    FREGetObjectAsUTF8(argv[0], &messageLength, &message);
    
    NSString* messageString = [NSString stringWithUTF8String:(char*)message];
    
    float duration = [SlideNotification SHORT];
    if(dur==1)
        duration = [SlideNotification LONG];
    
    #ifdef MYDEBUG
        NSLog(@" durration %f",dur);
    #endif
    
    if(messageString && ![messageString isEqualToString:@""]){

        [SlideNotification showMessage2:messageString duration:duration];
    }
    
    
    return nil;
}



#pragma mark - ANE setup

static const char * LIST_DIALOG_CONTEXT ="ListDialogContext";
static const char * ALERT_CONTEXT ="NativeAlertContext";
static const char * TEXT_INPUT_CONTEXT ="TextInputDialogContext";
static const char * PROGRESS_CONTEXT = "ProgressContext";
static const char * TOAST_CONTEXT = "ToastContext";
static const char * DATE_PICKER_CONTEX = "DatePickerDialogContext";

/* NativeDialogsContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void NativeDialogsContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    #ifdef MYDEBUG
        NSLog(@"Entering NativeDialogsContextInitializer()");
        NSLog(@"context %s",ctxType);
    #endif
    *numFunctionsToTest = 0;

    if(strcmp((const char *)ctxType, LIST_DIALOG_CONTEXT)==0)
    {
        *numFunctionsToTest = 6;
    }
    else if(strcmp((const char *)ctxType, ALERT_CONTEXT)==0)
    {
        *numFunctionsToTest = 6;
    }
    else if(strcmp((const char *)ctxType, TEXT_INPUT_CONTEXT)==0)
    {
        *numFunctionsToTest = 5;
    }
    else if(strcmp((const char *)ctxType, PROGRESS_CONTEXT)==0)
    {
        *numFunctionsToTest = 7;
    }else if(strcmp((const char *)ctxType, TOAST_CONTEXT)==0)
    {
        *numFunctionsToTest = 1;
    }else if(strcmp((const char *)ctxType, DATE_PICKER_CONTEX)==0)
    {
        *numFunctionsToTest = 8;
    }

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));

    NativeDialogControler* nativeDialogController = [[NativeDialogControler alloc]init];
    nativeDialogController.freContext = ctx;
    
    FRESetContextNativeData( ctx, nativeDialogController );
    
    if(strcmp((const char *)ctxType, LIST_DIALOG_CONTEXT)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "show";
        func[1].functionData = nativeDialogController;
        func[1].function = &showListDialog;
        
        func[2].name = (const uint8_t*) "updateTitle";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateTitle;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "shake";
        func[4].functionData = nativeDialogController;
        func[4].function = &shake;
        
        func[5].name = (const uint8_t*) "updateMessage";
        func[5].functionData = nativeDialogController;
        func[5].function = &updateMessage;
        
    }else if(strcmp((const char *)ctxType, ALERT_CONTEXT)==0){
        
        
        func[0].name = (const uint8_t *) "showAlertWithTitleAndMessage";
        func[0].functionData = nativeDialogController;
        func[0].function = &showAlertWithTitleAndMessage;
        
        func[1].name = (const uint8_t*) "isShowing";
        func[1].functionData = nativeDialogController;
        func[1].function = &isShowing;
        
        func[2].name = (const uint8_t*) "updateMessage";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateMessage;
        
        func[3].name = (const uint8_t*) "updateTitle";
        func[3].functionData = nativeDialogController;
        func[3].function = &updateTitle;
        
        func[4].name = (const uint8_t*) "shake";
        func[4].functionData = nativeDialogController;
        func[4].function = &shake;
        
        func[5].name = (const uint8_t*) "dismiss";
        func[5].functionData = nativeDialogController;
        func[5].function = &dismiss;
    }
    else if(strcmp((const char *)ctxType, TEXT_INPUT_CONTEXT)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "show";
        func[1].functionData = nativeDialogController;
        func[1].function = &showTextInputDialog;
        
        func[2].name = (const uint8_t*) "updateTitle";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateTitle;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "shake";
        func[4].functionData = nativeDialogController;
        func[4].function = &shake;
        
    }
    else if(strcmp((const char *)ctxType, DATE_PICKER_CONTEX)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "show";
        func[1].functionData = nativeDialogController;
        func[1].function = &showDatePicker;
        
        func[2].name = (const uint8_t*) "setDate";
        func[2].functionData = nativeDialogController;
        func[2].function = &setDate;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "updateMessage";
        func[4].functionData = nativeDialogController;
        func[4].function = &updateMessage;
        
        func[5].name = (const uint8_t*) "updateTitle";
        func[5].functionData = nativeDialogController;
        func[5].function = &updateTitle;
        
        func[6].name = (const uint8_t*) "shake";
        func[6].functionData = nativeDialogController;
        func[6].function = &shake;
        
        func[7].name = (const uint8_t*) "setCancelable";
        func[7].functionData = nativeDialogController;
        func[7].function = &setCancelable;
        
    }
    else if(strcmp((const char *)ctxType, PROGRESS_CONTEXT)==0){
        
        func[0].name = (const uint8_t*) "isShowing";
        func[0].functionData = nativeDialogController;
        func[0].function = &isShowing;
        
        func[1].name = (const uint8_t *) "showProgressPopup";
        func[1].functionData = nativeDialogController;
        func[1].function = &showProgressPopup;
        
        func[2].name = (const uint8_t*) "updateProgress";
        func[2].functionData = nativeDialogController;
        func[2].function = &updateProgress;
        
        func[3].name = (const uint8_t*) "dismiss";
        func[3].functionData = nativeDialogController;
        func[3].function = &dismiss;
        
        func[4].name = (const uint8_t*) "updateMessage";
        func[4].functionData = nativeDialogController;
        func[4].function = &updateMessage;
        
        func[5].name = (const uint8_t*) "updateTitle";
        func[5].functionData = nativeDialogController;
        func[5].function = &updateTitle;
        
        func[6].name = (const uint8_t*) "shake";
        func[6].functionData = nativeDialogController;
        func[6].function = &shake;
        
    }else if(strcmp((const char *)ctxType, TOAST_CONTEXT)==0){
        
        func[0].name = (const uint8_t *) "Toast";
        func[0].functionData = NULL;
        func[0].function = &showToast;
    }
    
    *functionsToSet = func;

    #ifdef MYDEBUG
        NSLog(@"Exiting NativeDialogsContextInitializer()");
    #endif
}

void NativeDialogsExtFinalizer(void* extData)
{
   
    return;
}



/* NativeDialogsContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void NativeDialogsContextFinalizer(FREContext ctx) 
{
    NativeDialogControler* nativeDialogController;
    FREGetContextNativeData(ctx, (void**)&nativeDialogController);
    
    if(nativeDialogController){
        [nativeDialogController release];
    }
    

    return;
}

/* NativeDialogsExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml
 */
void NativeDialogsExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    #ifdef MYDEBUG
        NSLog(@"Entering NativeDialogsExtInitializer()");
    #endif
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &NativeDialogsContextInitializer;
    *ctxFinalizerToSet = &NativeDialogsContextFinalizer;
    
    #ifdef MYDEBUG
        NSLog(@"Exiting NativeDialogsExtInitializer()");
    #endif
}

