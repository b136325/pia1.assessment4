classdef PiaOneAssessmentFour < matlab.apps.AppBase

    % ********************************************************************  
    % *                                                                  *
    % * ASSESSMENT 4                                                     *
    % *                                                                  *
    % * Student ID: S1888637                                             *
    % * Date: 30th November 2019                                         *
    % *                                                                  *
    % ********************************************************************
    % *                                                                  *
    % * DEVELOPMENT INFO                                                 *
    % *                                                                  *
    % * MatLab version: R2019b                                           *
    % * OS: Mac OS Catalina (10.15)                                      *
    % *                                                                  *
    % * Revision (Git tag): 0.4.2                                        *
    % *                                                                  *
    % ********************************************************************
    % *                                                                  *
    % * OVERVIEW                                                         *
    % *                                                                  *
    % * The code with this MatLab class has been divided into the follo- *
    % * -wing sections:                                                  *
    % *                                                                  *    
    % * 1. Constants                                                     *
    % * 2. Properties                                                    *
    % * 3. Public functions, including the class constructor             *
    % * 4. Private event (callback) functions                            *
    % * 5. Private update functions (usually triggered by a callback)    *
    % * 6. Private registration functions                                *
    % * 7. Private filter functions                                      *    
    % * 8. Private utility functions                                     *
    % * 9. Private create GUI component functions                        *
    % *                                                                  *
    % ********************************************************************
    % *                                                                  *
    % * KEY OPERATIONS                                                   *
    % *                                                                  *
    % *                                                                  *
    % * 1. Loading the target image                                      *
    % *                                                                  *    
    % * On the left hand side of the screen (once the app is running)    *
    % * the user may load a 'target' image by clicking on a button,      *
    % * which is stored as 'app.targetImageLoadButton'. Doing so         *
    % * triggers the 'onButtonClickLoadTargetImag' function, which makes *
    % * use of the pre-defined MatLab command, 'uigetfile', to display a *
    % * file browser. Once a user has selected a file, control is passed *
    % * to 'updateTargetImageViewer' which updates the GUI with the      *
    % * image selected by the user.                                      *
    % *                                                                  *
    % * Please note that a whitelist of image extensions appropriate for *
    % * this application has been defined within the class constant      *
    % * IMAGE_FILE_EXTENSIONS_WHITELIST.                                 *
    % *                                                                  *
    % *                                                                  *
    % * 2. Filtering the intensity of the loaded target image            *
    % *                                                                  *
    % * The target image can be filtered (once the app is running) by    *
    % * changing the value of the filter related drop down GUI component.*
    % * When the value changes, the 'onDropDownChange' callback function *
    % * is triggered, and it applies the appropriate filter (via a       *
    % * secondary call) to a copy of the original target image. It then  *
    % * displays the copy via 'updateTargetImageViewer'.                 *
    % *                                                                  *
    % * Currently, the available filters are Gaussian and Med, and they  *    
    % * are handled by 'applyTargetGaussianFilter' and                   *
    % * 'applyTargetMedFilter' functions, respectively.                  *
    % *                                                                  *    
    % *                                                                  *
    % * 3. Auto generation of the moving image                           *   
    % *                                                                  *    
    % * Once a target image has been loaded (or modified by the selection*
    % * of a filter) the associated moving image is automatically        *
    % * generated via a call to the 'updateMovingImageViewer' function.  *
    % * This creates a distored version of the target image using the    *
    % * pre-defined MatLab functions 'affine2d' and 'imwarp', an example *
    % * of whose usage can be found within the MatLab documentation at   *
    % * the following address: `https://uk.mathworks.com/help/images/use-*
    % * phase-correlation-as-preprocessing-step-in-registration.html`.   * 
    % *                                                                  *
    % * Once created the moving image will be shown in the second image  *
    % * placeholder from the left (within the GUI).                      *
    % *                                                                  *    
    % *                                                                  *
    % * 4. Registration estimate                                         *
    % *                                                                  *
    % * Once the moving image has been generated, a registration estimate*
    % * will be produced by the 'generateRegistrationEstimate' function, *
    % * and 'updateRegistrationCombinedImageViewer' will be called to    *
    % * display a composite of the moving and the estimated images.      *
    % *                                                                  *
    % * The combined image will be shown in the top right hand side of   *
    % * of the GUI.                                                      *
    % *                                                                  *    
    % *                                                                  *
    % * 5. Registration                                                  *
    % *                                                                  * 
    % * Once the registration estimate has been generated, as described  *
    % * immediately above, the registration process will be concluded    *
    % * via a call to the 'register' function.                           *
    % *                                                                  * 
    % * The specificity of the registration process can be manipulated   *
    % * via two GUI 'knobs', which alter the maximum number of iterations*
    % * and the maximum step length of the optimizer used by the call to *
    % * imregister.                                                      *
    % *                                                                  *     
    % * The registered image will be shown in the bottom right hand side *
    % * of the GUI.                                                      *    
    % *                                                                  *         
    % ********************************************************************
    % *                                                                  *
    % * KNOWN BUGS                                                       *
    % *                                                                  *
    % * 1. File browser opening behind the main window. This appears to  *
    % * be a consequence of using a .m. rather than an app related file  *
    % * type.                                                            *
    % ********************************************************************    
    
    % ********************************************************************  
    % *                                                                  *
    % * 1. CONSTANTS.                                                    *
    % *                                                                  *
    % ********************************************************************
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.a Flag (or boolean) constants.                                 *
    % *                                                                  *
    % ********************************************************************
    properties (Access = private)
        SHOULD_CLEAR_COMMAND_WINDOW = true;
        SHOW_INFO_FLAG = true;             
    end

    % ********************************************************************  
    % *                                                                  *
    % * 1.b Image file constants.                                        *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        INITIAL_RADIUS_REDUCTION_FACTOR = 3.5;
        INITIAL_RADIUS_INCREASE_FACTOR = 3;
        IMAGE_FILE_EXTENSIONS_WHITELIST = ...
            '*.dcm;*.gif;*.jpeg;*.jpg;*.png;*.tif;*.tiff;';
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.a CONSTANTS: Instructions, title and window.                   *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)        
        % Instruction constants.
        INSTRUCTIONS_POSITION = [30 658 68 22];
        INSTRUCTIONS_TEXT = 'Instructions';
        
        % Title constants.
        TITLE_FONT_SIZE = 20;
        TITLE_POSITION = [19 757 400 26];
        TITLE_TEXT = 'PIA1 Assessment 4 - Student ID: S1888637.';        
        
        % Window constants.
        WINDOW_AUTO_RESIZE_CHILDREN = 'off';
        WINDOW_POSITION = [100 100 1280 800];
        WINDOW_TITLE = 'PIA1 Assessment 4 - Student ID: S1888637.';         
    end

    % ********************************************************************  
    % *                                                                  *
    % * 1.b CONSTANTS: Tab group and tab titles.                         *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        TAB_GROUP_POSITION = [19 19 1244 725];
        TAB_REGISTRATION_TITLE = ...
            strcat( ...
                'Register an automatically generated "moving" ', ...
                ' image and manipulate the intensity of the ', ...
                ' "target" image.' ...
            );
    end    
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.c CONSTANTS: Target image panel and children.                  *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)

        % Target image filter drop down constants.
        TARGET_IMAGE_FILTER_DROP_DOWN_POSITION = [125 208 100 22];
        TARGET_IMAGE_FILTER_DROP_DOWN_ITEMS = ...
            {'Original', 'Gaussian', 'Med'};
        
        % Target image constants.
        TARGET_IMAGE_LOAD_BUTTON_POSITION = [125 308 100 22];
        TARGET_IMAGE_LOAD_BUTTON_TITLE_DEFAULT = 'Load';
        TARGET_IMAGE_LOAD_BUTTON_TITLE_RELOAD = 'Reload';
        TARGET_IMAGE_LOAD_BUTTON_TYPE = 'push';
        
        % Target image panel constants.
        TARGET_IMAGE_PANEL_FONT_SIZE = 14; 
        TARGET_IMAGE_PANEL_POSITION = [21 21 350 534]; 
        TARGET_IMAGE_PANEL_TITLE = '1. Load the "target" image.';
        
        % Target image viewer.
        TARGET_IMAGE_VIEWER_POSITION = [0 350 350 147];
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.d CONSTANTS: Moving image panel and children.                  *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        % Image manipulation constants.
        MOVING_IMAGE_MANIPULATION_SC = 2.3;
        MOVING_IMAGE_MANIPULATION_SH = 0.5;        
        MOVING_IMAGE_MANIPULATION_THETA = 170;
        
        % Moving image panel constants.
        MOVING_IMAGE_PANEL_FONT_SIZE = 14; 
        MOVING_IMAGE_PANEL_POSITION = [396 21 350 534]; 
        MOVING_IMAGE_PANEL_TITLE = ...
            '2. An automatically generated "moving" image.';
        
        % Moving image viewer constants.
        MOVING_IMAGE_VIEWER_POSITION = [1 350 349 147];
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.e CONSTANTS: Registration options panel and children.          *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        
        % Registration image constants.     
        REGISTRATION_COMBINED_IMAGE_VIEWER_POSITION = [2 350 349 147];
        REGISTRATION_REGISTERED_IMAGE_VIEWER_POSITION = [2 050 349 147];
        
        % Registration iteration knob constants.
        REGISTRATION_ITERATIONS_KNOB_DEFAULT = 100;
        REGISTRATION_ITERATIONS_KNOW_LIMITS = [1, 1000];
        REGISTRATION_ITERATIONS_KNOB_POSITION = [80 260 50 50];

        % Registration max step knob constants.        
        REGISTRATION_MAX_STEP_KNOB_DEFAULT = 0.0625;
        REGISTRATION_MAX_STEP_KNOB_POSITION = [260 260 50 50];
        REGISTRATION_MAX_STEP_KNOW_LIMITS = [0.01, 1];
        
        % Registration options panel constants.
        REGISTRATION_OPTIONS_PANEL_FONT_SIZE = 14;
        REGISTRATION_OPTIONS_PANEL_POSITION = [775 21 444 534];
        REGISTRATION_OPTIONS_PANEL_TITLE = ...
            '3. Estimated registration for the "moving" image.';
        
        REGISTRATION_LABEL_FONT_SIZE = 14;  
        REGISTRATION_LABEL_POSITION = [10 150 349 147];
        REGISTRATION_LABEL_TEXT = '4. The registered image.';        
    end
    
    % ********************************************************************
    % *                                                                  *
    % * 1.f CONSTANTS: Filtering properties.                             *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        GAUSSIAN_FILTER_HSIZE = 5;
        GAUSSIAN_FILTER_SIGMA = 2;
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 2. PROPERTIES.                                                   *
    % *                                                                  *
    % ********************************************************************
    
    % ********************************************************************  
    % *                                                                  *
    % * 2.a PUBLIC PROPERTIES: Instructions, title and window.           *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        instructions                        matlab.ui.control.Label
        title                               matlab.ui.control.Label
        window                              matlab.ui.Figure
    end

    % ********************************************************************  
    % *                                                                  *
    % * 2.b PUBLIC PROPERTIES: Tab group and tabs.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        tabGroup                            matlab.ui.container.TabGroup
        tabLogger                           matlab.ui.container.Tab
        tabRegistration                     matlab.ui.container.Tab
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 2.c PUBLIC PROPERTIES: Target image panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        targetImage
        targetImageFilterDropDown           matlab.ui.control.DropDown        
        targetImageLoadButton               matlab.ui.control.Button 
        targetImageOriginal
        targetImagePanel                    matlab.ui.container.Panel 
        targetImageViewer                   matlab.ui.control.UIAxes        
    end
        
    % ********************************************************************  
    % *                                                                  *
    % * 2.d PUBLIC PROPERTIES: Moving image panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        movingImage
        movingImageViewer                   matlab.ui.control.UIAxes
        movingImagePanel                    matlab.ui.container.Panel       
    end

    % ********************************************************************  
    % *                                                                  *
    % * 2.e PUBLIC PROPERTIES: Registration options panel.               *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        registrationCombinedImageViewer     matlab.ui.control.UIAxes
        registrationEstimate
        registrationIterationsKnob          matlab.ui.control.Knob
        registrationOptionsPanel            matlab.ui.container.Panel
        registrationMaxStepKnob             matlab.ui.control.Knob
        registrationRegisteredImageLabel    matlab.ui.control.Label
        registrationRegisteredImageViewer   matlab.ui.control.UIAxes

    end       

    % ********************************************************************  
    % *                                                                  *
    % * 3. PUBLIC FUNCTIONS                                              *
    % *                                                                  *
    % ********************************************************************
    methods (Access = public)

        % PiaOneAssessmentFour
        %
        % The public constructor for the class.
        %
        function app = PiaOneAssessmentFour
            app.info('PiaOneAssessmentFour constructor.');
            app.clearCommandWindow();

            % Create the window and the child GUI components
            % and then register them as an app.
            app.createWindow();
            registerApp(app, app.window);
            runStartupFcn(app, @onStartup);

            if nargout == 0
                clear app
            end
        end

        function delete(app)
            app.info('PiaOneAssessmentFour delete.');
            delete(app.window)
        end
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 4. PRIVATE EVENT FUNCTIONS (A to Z)                              *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)
        
        % onButtonClickLoadTargetImage 
        % 
        % A callback function which will be triggered when a user clicks
        % to upload an image.
        %        
        function onButtonClickLoadTargetImage(app, ~)
            app.info('Callback: onButtonClickLoadTargetImage.');   

            imageFileUploadSpecification = { ...
                app.IMAGE_FILE_EXTENSIONS_WHITELIST, ...
                'All recognised image files' ...
            };
            [f, p] = uigetfile(imageFileUploadSpecification);          
            
            if (ischar(p))
               app.updateTargetImageLoadButtonText( ...
                   app.TARGET_IMAGE_LOAD_BUTTON_TITLE_RELOAD ...
               );                    
               targetImageFilePath = [p f];
               app.updateTargetImageViewer(targetImageFilePath);
            end
        end
        
        % onDropDownChange 
        %
        % A callback function which will be triggered when the GUI drop
        % down selection of 'intensity filters' is changed by a user.
        %             
        function onDropDownChange(app, valueChangedObject)
            app.info('onDropDownChang');
            
            switch valueChangedObject.Value          
                case "Gaussian"
                    app.applyTargetGaussianFilter();
                case "Original"
                    app.updateTargetImageViewer(false);
                case "Med"    
                   app.applyTargetMedFilter();
            end
        end    
        
        % onKnobValueChange
        %
        % A callback function which will be triggered when the values
        % associated with either or the 'registration' related knob GUI
        % components change.
        %             
        function onKnobValueChange(app, ~)
            app.info('onKnobValueChange');
            app.register();
        end
        
        % onStartup 
        %
        %A callback function registered with 'runStartupFcn' from within
        % the constructor. It is triggered when the app starts and simply
        % logs a message to the Command Window with the name of the app.
        %           
        function onStartup(app)
            app.info('PiaOneAssessmentFour startup.'); 
        end  
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 5. PRIVATE UPDATE FUNCTIONS (A to Z)                             *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)
        
        % updateMovingImageViewer 
        %
        % A function the receives the target image as a param and
        % manipulates a copy of that image to produce the moving image.
        % The moving image is then added into the appropriate GUI
        % component.
        %               
        function updateMovingImageViewer(app, targetImage)
            app.info('updateMovingImageViewer.');            

            theta = app.MOVING_IMAGE_MANIPULATION_THETA;
            rotation = [ ...
                cosd(theta) sind(theta) 0;... 
                sind(theta) cosd(theta) 0;... 
                0 0 1 ...
            ]; 
            sc = app.MOVING_IMAGE_MANIPULATION_SC;
            scale = [sc 0 0; 0 sc 0; 0 0 1]; 
            
            sh = app.MOVING_IMAGE_MANIPULATION_SH;
            shear = [1 sh 0; 0 1 0; 0 0 1]; 

            tform = affine2d(shear * scale * rotation);
       
            app.movingImage = imwarp(targetImage, tform);
            
            app.movingImage = app.movingImage + ...
                uint8(10*rand(size(app.movingImage)));
            
            imagesc(app.movingImageViewer, app.movingImage);
        end
  
        % updateTargetImageLoadButtonText 
        %
        % A function that updates the text within the load button.
        %               
        function updateTargetImageLoadButtonText(app, updatedText)
            app.info('updateTargetImageLoadButtonText.');            
            app.targetImageLoadButton.Text = updatedText;
        end
        
        % updateTargetImageViewer 
        %
        % A function the receives the path to the target image,
        % targetImageFilePath, and then attempts to load the image.
        % If successful, the image is then loaded into the appropriate GUI
        % component.
        %         
        function updateTargetImageViewer(app, targetImageFilePath)
            app.info('updateTargetImageViewer.');
            app.info(targetImageFilePath);
            
            if (ischar(targetImageFilePath))
                try
                    app.targetImageOriginal = app.loadImage( ...
                        targetImageFilePath ...
                    );                

                catch error
                    uialert(app.window, error.message, 'Image Error');
                    return;
                end
            end
            
            app.targetImage = app.targetImageOriginal;
            imagesc(app.targetImageViewer, app.targetImage);
            app.updateMovingImageViewer(app.targetImage);
            
            app.generateRegistrationEstimate();
            app.updateRegistrationCombinedImageViewer();
            app.register();
        end 
        
        % updateRegistrationCombinedImageViewer
        %
        % A function that updates the GUI component used to display the
        % 'combined' moving and moving regsitration images.
        %               
        function updateRegistrationCombinedImageViewer(app)
            app.info('updateRegistrationCombinedImageViewer.');              
               
            targetFixed = imref2d(size(app.targetImage));

            movingRegistrationImage = imwarp( ...
                app.movingImage, ...
                app.registrationEstimate, ...
                'OutputView', ...
                targetFixed ...
            );
       
           imagesc( ...
               app.registrationCombinedImageViewer, ...
               movingRegistrationImage ...
           );
        end 
       
        % updateRegistrationRegisteredImageViewer
        %
        % A function that updates the GUI component used to display the
        % registered moving image.
        %                      
        function updateRegistrationRegisteredImageViewer( ...
           app, ...
           registeredImage ...
        )
            app.info('updateRegistrationRegisteredImageViewer.');

           imagesc( ...
               app.registrationRegisteredImageViewer, ...
               registeredImage ...
           );
        end                 
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 6. PRIVATE REGISTRATION FUNCTIONS (A to Z)                       *
    % *                                                                  *
    % ********************************************************************        
    methods (Access = private)
        
        % generateRegistrationEstimate
        %
        % A function that may be called to generate the registration
        % estimate for the moving image.
        %          
        function generateRegistrationEstimate(app)
            app.registrationEstimate = imregcorr( ...
                app.movingImage, ...
                app.targetImage ...
            );
        end    

        % register
        %
        % A function that may be called to register the moving image
        % against the target image with regard to the user defined values
        % of MaximumIterations and MaximumStepLength.
        %          
        function registeredImage = register(app)            
            app.info('Register.');
         
            [optimizer, metric] = imregconfig('monomodal');
            
            optimizer.MaximumIterations = ...
                round(app.registrationIterationsKnob.Value);
            
            optimizer.MaximumStepLength = ...
                app.registrationMaxStepKnob.Value;

            registeredImage = imregister( ...
                app.movingImage, ...
                app.targetImage, ...
                'affine', ...
                optimizer, ...
                metric, ...
                'InitialTransformation', ...
                app.registrationEstimate ...
            );
        
             app.updateRegistrationRegisteredImageViewer( ...
                registeredImage ...
            );        
        end               
    end     

    % ********************************************************************  
    % *                                                                  *
    % * 7. PRIVATE FILTER FUNCTIONS (A to Z)                             *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)
        
        % applyTargetGaussianFilter
        %
        % A function that may be called to apply a Gaussian filter to the
        % target image. Please note that the target image displayed at any
        % point in time is always stored as 'app.targetImage'. In contrast
        % 'app.targetImageOriginal' contains the originally loaded image.
        % This approach enables the filters to be applied repeatedly to
        % the original.
        %            
        function applyTargetGaussianFilter(app)
            app.info('applyTargetGaussianFilter');
            
            filter = fspecial( ...
                "gaussian", ...
                app.GAUSSIAN_FILTER_HSIZE, ...
                app.GAUSSIAN_FILTER_SIGMA ...
            );
        
            app.targetImage = imfilter( ...
                app.targetImageOriginal, ...
                filter, ...
                "replicate" ...
             );
        end
        
        % applyTargetMedFilter
        %
        % A function that may be called to apply a Med filter to the
        % target image.
        %         
        function applyTargetMedFilter(app) 
            app.info('applyTargetMedFilter');
            app.targetImage = medfilt2(app.targetImageOriginal);
        end         
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 8. PRIVATE UTILITY FUNCTIONS (A to Z)                            *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)

        % clearCommandWindow
        %
        % When the value of the class constant SHOULD_CLEAR_COMMAND_WINDOW
        % is true, calling this function will clear the command window.
        %          
        function clearCommandWindow(app)
            app.info('Clearing the command window');
            if (app.SHOULD_CLEAR_COMMAND_WINDOW == true)
               clc; 
            end    
        end
        
        % convertToGrey
        %
        % A common 'conversion' function that attempts to load an image
        % (with regard to the received imageFilePath param) and then
        % attempts to convert the image to greyscale based upon the number
        % of channels within the image, along with the presence or absence 
        % of an image map.
        %
        % @TODO At present this function is not being called as a part of
        %       the loading process. Once this function has been tested,
        %       successfully, and possibly refactored, too, call it from
        %       the 'loadImage' function defined below.
        %           
        function convertedImage = convertToGrey(app, imageFilePath)
            app.info('Convert to grey.');

            [imageToConvert, map] = imread(imageFilePath);   
            [~, ~, numberOfColourChannels] = size(imageToConvert);
            
            if (numberOfColourChannels == 3)
                convertedImage = rgb2gray(imageToConvert);
                
            elseif (numberOfColourChannels == 1 && isempty(map))
                convertedImage = imageToConvert;
                                
            elseif (numberOfColourChannels == 1 && not(isempty(map)))           
                convertedImage = ind2gray(imageToConvert, map); 
            end
        end
        
        % info
        %
        % When the value of the class constant SHOW_INFO_FLAG is true, 
        % log the received message param to the command window.
        %            
        function info(app, message)
            if (app.SHOW_INFO_FLAG == true)
                disp(message);                  
            end 
        end
        
        % loadImage
        % 
        % Load the image defined by the imageFilePath param.
        %
        % @TODO At present the app supports images whose extensions are 
        %       defined within the IMAGE_FILE_EXTENSIONS_WHITELIST
        %       class constant.
        %
        %       Currently IMAGE_FILE_EXTENSIONS_WHITELIST supports:
        %           *.dcm;
        %           *.gif;
        %           *.jpeg;
        %           *.jpg;
        %           *.png;
        %           *.tif;
        %           *.tiff;
        %
        %      Please note, however, that while *.dcm files load,
        %      a further piece of code will be required to handle 
        %      layers within the volume.
        %          
        function image = loadImage(app, imageFilePath)
            app.info('LoadImage.');
            app.info(imageFilePath);
            
            try
               image = imread(imageFilePath);
            catch
                
                try
                   image = dicomread(imageFilePath);
                catch
                    
                    try
                        image = niftiread(imageFilePath);
                    catch exception
                        uialert( ...
                            app.window, ...
                            exception.message, ...
                            'Image load error' ...
                        );
                        return;
                    end    
                end    
            end    
        end      
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 9. PRIVATE CREATE WINDOW AND CHILD COMPONENT FUNCTIONS           *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)

        function createWindow(app)
            app.info('Creating the window');
            
            app.window ...
                = uifigure('Visible', 'off');
            
            app.window.AutoResizeChildren = ...
                app.WINDOW_AUTO_RESIZE_CHILDREN;
            
            app.window.Position = app.WINDOW_POSITION;         
            app.window.Name = app.WINDOW_TITLE;
            app.createChildComponents()
            app.window.Visible = 'on';
        end
        
        function createChildComponents(app)
            app.info('Creating the child compomnents for the window.');
            
            app.createChildComponentTabGroup();

            app.createChildComponentTabRegistration();
            app.createChildComponentInstructions();
            app.createChildComponentTitle();
            
            app.createChildComponentMovingImagePanel();
            app.createChildComponentRegistrationOptionsPanel();
            app.createChildComponentTargetImagePanel();            
        end
        
        function createChildComponentTabGroup(app)
            app.info('Creating the tabGroup child compomnent.');
            
            app.tabGroup = uitabgroup(app.window);
            app.tabGroup.Position = app.TAB_GROUP_POSITION;
        end
        
        function createChildComponentTabRegistration(app)
            app.info('Creating the tabRegistration child compomnent.');
            
            app.tabRegistration = uitab(app.tabGroup);
            app.tabRegistration.Title = app.TAB_REGISTRATION_TITLE;
        end
        
        function createChildComponentTargetImagePanel(app)
            app.info('Creating the targetImagePanel child compomnent.');
            
            app.targetImagePanel = ...
                uipanel(app.tabRegistration);
            
            app.targetImagePanel.Title = ...
                app.TARGET_IMAGE_PANEL_TITLE;
            
            app.targetImagePanel.FontSize = ...
                app.TARGET_IMAGE_PANEL_FONT_SIZE;
            
            app.targetImagePanel.Position = ...
                app.TARGET_IMAGE_PANEL_POSITION;

            app.targetImageViewer = ...
                uiaxes(app.targetImagePanel);
            
            app.targetImageViewer.Position = ...
                app.TARGET_IMAGE_VIEWER_POSITION;

            app.targetImageViewer.XTick = [];
            app.targetImageViewer.XTickLabel = {'[ ]'};
            app.targetImageViewer.YTick = [];
            
            app.targetImageLoadButton = uibutton( ...
                app.targetImagePanel, ...
                app.TARGET_IMAGE_LOAD_BUTTON_TYPE ...
            );
            
            app.targetImageLoadButton.Position = ...
                app.TARGET_IMAGE_LOAD_BUTTON_POSITION;
            
            app.updateTargetImageLoadButtonText( ...
                app.TARGET_IMAGE_LOAD_BUTTON_TITLE_DEFAULT ...
            );    
            
            app.targetImageLoadButton.ButtonPushedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onButtonClickLoadTargetImage, ...
                    true ...
                );
            
            app.targetImageFilterDropDown = ...
                uidropdown(app.targetImagePanel);
             
            app.targetImageFilterDropDown.Position = ...
                app.TARGET_IMAGE_FILTER_DROP_DOWN_POSITION;     
        
            app.targetImageFilterDropDown.Items = ...
                 app.TARGET_IMAGE_FILTER_DROP_DOWN_ITEMS;  
             
            app.targetImageFilterDropDown.ValueChangedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onDropDownChange, ...
                    true ...
                );
            
        end
        
        function createChildComponentMovingImagePanel(app)
            app.info('Creating the movingImagePanel child compomnent.');
            
            app.movingImagePanel = ...
                uipanel(app.tabRegistration);
            
            app.movingImagePanel.Title = ...
                app.MOVING_IMAGE_PANEL_TITLE;
            
            app.movingImagePanel.FontSize = ...
                app.MOVING_IMAGE_PANEL_FONT_SIZE;
            
            app.movingImagePanel.Position = ...
                app.MOVING_IMAGE_PANEL_POSITION;

            app.movingImageViewer = ...
                uiaxes(app.movingImagePanel);
            
            app.movingImageViewer.Position = ...
                app.MOVING_IMAGE_VIEWER_POSITION;

            app.movingImageViewer.XTick = [];
            app.movingImageViewer.XTickLabel = {'[ ]'};
            app.movingImageViewer.YTick = [];
                       
        end
        
        function createChildComponentRegistrationOptionsPanel(app)
            app.info('Creating registrationOptionsPanel.');                
        
            app.registrationOptionsPanel = ...
                uipanel(app.tabRegistration);
            
            app.registrationOptionsPanel.Title = ...
                app.REGISTRATION_OPTIONS_PANEL_TITLE;
            
            app.registrationOptionsPanel.FontSize = ...
                app.REGISTRATION_OPTIONS_PANEL_FONT_SIZE;
            
            app.registrationOptionsPanel.Position = ...
                app.REGISTRATION_OPTIONS_PANEL_POSITION;  
            
            app.registrationCombinedImageViewer = ...
                uiaxes(app.registrationOptionsPanel);
            
            app.registrationCombinedImageViewer.Position = ...
                app.REGISTRATION_COMBINED_IMAGE_VIEWER_POSITION;

            app.registrationCombinedImageViewer.XTick = [];
            app.registrationCombinedImageViewer.XTickLabel = {'[ ]'};
            app.registrationCombinedImageViewer.YTick = [];
            
            app.registrationRegisteredImageViewer = ...
                uiaxes(app.registrationOptionsPanel);
            
            app.registrationRegisteredImageViewer.Position = ...
                app.REGISTRATION_REGISTERED_IMAGE_VIEWER_POSITION;

            app.registrationRegisteredImageViewer.XTick = [];
            app.registrationRegisteredImageViewer.XTickLabel = {'[ ]'};
            app.registrationRegisteredImageViewer.YTick = [];
            
            app.registrationIterationsKnob = ...
                uiknob(app.registrationOptionsPanel);
            
            app.registrationIterationsKnob.Limits = ...
                app.REGISTRATION_ITERATIONS_KNOW_LIMITS;
            
            app.registrationIterationsKnob.Value = ...
                app.REGISTRATION_ITERATIONS_KNOB_DEFAULT;
            
            app.registrationIterationsKnob.Position = ...
                app.REGISTRATION_ITERATIONS_KNOB_POSITION;
            
            app.registrationIterationsKnob.ValueChangedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onKnobValueChange, ...
                    true ...
                );  
            
            app.registrationMaxStepKnob = ...
                uiknob(app.registrationOptionsPanel);
            
            app.registrationMaxStepKnob.Limits = ...
                app.REGISTRATION_MAX_STEP_KNOW_LIMITS;
            
            app.registrationMaxStepKnob.Value = ...
                app.REGISTRATION_MAX_STEP_KNOB_DEFAULT;
            
            app.registrationMaxStepKnob.Position = ...
                app.REGISTRATION_MAX_STEP_KNOB_POSITION;
            
            app.registrationMaxStepKnob.ValueChangedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onKnobValueChange, ...
                    true ...
                );
            
            app.registrationRegisteredImageLabel = ...
                uilabel(app.registrationOptionsPanel);
            
            app.registrationRegisteredImageLabel.FontSize = ...
                app.REGISTRATION_LABEL_FONT_SIZE;
            
            app.registrationRegisteredImageLabel.Position = ...
                app.REGISTRATION_LABEL_POSITION;         
            
        end
        
        function createChildComponentInstructions(app)
            app.info('Creating the instructions child compomnent.');
            
            app.instructions = uilabel(app.tabRegistration);
            app.instructions.Position = app.INSTRUCTIONS_POSITION;
            app.instructions.Text = app.INSTRUCTIONS_TEXT;
        end
        
        function createChildComponentTitle(app)
            app.info('Creating the title child compomnent.');
            
            app.title = uilabel(app.window);
            app.title.FontSize = app.TITLE_FONT_SIZE;
            app.title.Position = app.TITLE_POSITION;
            app.title.Text = app.TITLE_TEXT;
        end
    end    
end
