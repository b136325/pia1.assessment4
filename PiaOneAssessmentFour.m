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
    % * Revision (Git tag): 0.3.1                                        *
    % *                                                                  *
    % ********************************************************************
    % *                                                                  *
    % * OVERVIEW                                                         *
    % *                                                                  *
    % * The code with this MatLab class has been divided into the follo- *
    % * -wing sections:                                                  *
    % * 1. Constants                                                     *
    % * 2. Properties                                                    *
    % * 3. Public functions, including the class constructor             *
    % * 4. Private event (callback) functions                            *
    % * 5. Private update functions (usually triggered by a callback)    *
    % * 6. Private registration functions                                *
    % * 7. Private utility functions                                     *
    % * 8. Private create GUI component functions                        *
    % *                                                                  *
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
        TITLE_POSITION = [19 757 179 26];
        TITLE_TEXT = 'PIA1 Assessment 4';        
        
        % Window constants.
        WINDOW_AUTO_RESIZE_CHILDREN = 'off';
        WINDOW_POSITION = [100 100 1280 800];
        WINDOW_TITLE = 'PIA1 Assessment 4';         
    end

    % ********************************************************************  
    % *                                                                  *
    % * 1.b CONSTANTS: Tab group and tab titles.                         *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        TAB_GROUP_POSITION = [19 19 1244 725];
        TAB_LOGGER_TITLE = 'Logger';
        TAB_REGISTRATION_TITLE = 'Register image';
    end    
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.c CONSTANTS: Target image panel and children.                  *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        
        % Target image constants.
        TARGET_IMAGE_LOAD_BUTTON_POSITION = [125 308 100 22];
        TARGET_IMAGE_LOAD_BUTTON_TITLE_DEFAULT = 'Load';
        TARGET_IMAGE_LOAD_BUTTON_TITLE_RELOAD = 'Reload';
        TARGET_IMAGE_LOAD_BUTTON_TYPE = 'push';
        
        % Target image panel constants.
        TARGET_IMAGE_PANEL_FONT_SIZE = 14; 
        TARGET_IMAGE_PANEL_POSITION = [21 21 350 534]; 
        TARGET_IMAGE_PANEL_TITLE = 'Target image';
        
        % Target image viewer.
        TARGET_IMAGE_VIEWER_POSITION = [0 350 350 147];
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.d CONSTANTS: Moving image panel and children.                  *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        
        % Moving image constants.
        MOVING_IMAGE_LOAD_BUTTON_POSITION = [125 308 100 22];
        MOVING_IMAGE_LOAD_BUTTON_TITLE_DEFAULT = 'Load';
        MOVING_IMAGE_LOAD_BUTTON_TITLE_RELOAD = 'Reload';
        MOVING_IMAGE_LOAD_BUTTON_TYPE = 'push';
        
        % Moving image panel constants.
        MOVING_IMAGE_PANEL_FONT_SIZE = 14; 
        MOVING_IMAGE_PANEL_POSITION = [396 21 350 534]; 
        MOVING_IMAGE_PANEL_TITLE = 'Moving image';
        
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
        
        % Registration knob constants.
        REGISTRATION_ITERATIONS_KNOB_POSITION = [80 260 50 50]
        REGISTRATION_RADIUS_KNOB_POSITION = [260 260 50 50]
        
        % Registration options panel constants.
        REGISTRATION_OPTIONS_PANEL_FONT_SIZE = 14;
        REGISTRATION_OPTIONS_PANEL_POSITION = [775 21 444 534];
        REGISTRATION_OPTIONS_PANEL_TITLE = 'Registration options';
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.e CONSTANTS: Logger and label.                                 *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        
        % Logger label constants.
        LOGGER_LABEL_HORIZONTAL_POSITION = 'right';
        LOGGER_LABEL_POSITION = [27 653 113 22];
        LOGGER_LABEL_TEXT = '';
        
        % Logger constants.
        LOGGER_TEXT_DEFAULT = '';
        LOGGER_POSITION = [155 378 1062 299];
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
        targetImageOriginal
        targetImageInt16
        targetImageShown
        targetImageViewer                   matlab.ui.control.UIAxes
        targetImageLoadButton               matlab.ui.control.Button
        targetImagePanel                    matlab.ui.container.Panel        
    end
        
    % ********************************************************************  
    % *                                                                  *
    % * 2.d PUBLIC PROPERTIES: Moving image panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        movingImageOriginal
        movingImageInt16
        movingImageShown
        movingImageViewer                   matlab.ui.control.UIAxes
        movingImageLoadButton               matlab.ui.control.Button
        movingImagePanel                    matlab.ui.container.Panel       
    end

    % ********************************************************************  
    % *                                                                  *
    % * 2.e PUBLIC PROPERTIES: Registration options panel.               *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        registrationCombinedImageViewer     matlab.ui.control.UIAxes
        registrationIterationsKnob          matlab.ui.control.Knob
        registrationOptionsPanel            matlab.ui.container.Panel
        registrationRadiusKnob              matlab.ui.control.Knob
        registrationRegisteredImageViewer   matlab.ui.control.UIAxes
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 2.f PUBLIC PROPERTIES: Logger.                                   *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        logger                              matlab.ui.control.Label
        loggerLabel                         matlab.ui.control.Label
    end        

    % ********************************************************************  
    % *                                                                  *
    % * 3. PUBLIC FUNCTIONS                                              *
    % *                                                                  *
    % ********************************************************************
    methods (Access = public)

        function app = PiaOneAssessmentFour
            app.info('PiaOneAssessmentFour constructor.', false);
            app.clearCommandWindow();
            
            app.createWindow();
            registerApp(app, app.window);
            runStartupFcn(app, @onStartup);

            if nargout == 0
                clear app
            end
        end

        function delete(app)
            app.info('PiaOneAssessmentFour delete.', false);
            delete(app.window)
        end
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 4. PRIVATE EVENT FUNCTIONS                                       *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)
        
        function onButtonClickLoadMovingImage(app, ~)
            app.info( ...
                'Callback: onButtonClickLoadMovingImage.', ...
                true ...
            );   

            imageFileUploadSpecification = { ...
                app.IMAGE_FILE_EXTENSIONS_WHITELIST, ...
                'All recognised image files' ...
            };
            [f, p] = uigetfile(imageFileUploadSpecification);
            
            if (ischar(p))
               app.updateMovingImageLoadButtonText( ...
                   app.MOVING_IMAGE_LOAD_BUTTON_TITLE_RELOAD ...
               );                 
               imageFilePath = [p f];
               app.updateMovingImageViewer(imageFilePath);
            end
        end
        
        function onButtonClickLoadTargetImage(app, ~)
            app.info( ...
                'Callback: onButtonClickLoadTargetImage.', ...
                true ...
            );   

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
        
        function onKnobValueChange(app, ~)
            app.register();
        end
        
        function onStartup(app)
            app.info('PiaOneAssessmentFour startup.', false); 
        end  
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 5. PRIVATE UPDATE FUNCTIONS                                      *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)

        function updateMovingImageLoadButtonText(app, updatedText)
             app.info( ...
                 'updateMovingImageLoadButtonText.', ...
                 true ...
             );
            app.movingImageLoadButton.Text = updatedText;
        end
        
        function updateMovingImageViewer(app, movingImageFilePath)
             app.info( ...
                 'updateMovingImageViewer.', ...
                 true ...
            );            
            try
                app.movingImageOriginal = app.loadImage( ...
                    movingImageFilePath ...
                );
            
                app.movingImageInt16 = app.convertToGrey( ...
                    movingImageFilePath ...
                );
                app.movingImageShown = app.movingImageInt16;
            catch error
                uialert(app.window, error.message, 'Image Error');
                return;
            end 
 
            imagesc(app.movingImageViewer, app.movingImageInt16);
            app.updateRegistrationCombinedImageViewer();
        end
  
        function updateTargetImageLoadButtonText(app, updatedText)
             app.info( ...
                 'updateTargetImageLoadButtonText.', ...
                 true ...
             );            
            app.targetImageLoadButton.Text = updatedText;
        end
        
        function updateTargetImageViewer(app, targetImageFilePath)
             app.info( ...
                 'updateTargetImageViewer.', ...
                 true ...
            );              
            try
                app.targetImageOriginal = app.loadImage( ...
                    targetImageFilePath ...
                );                
                
                app.targetImageInt16 = app.convertToGrey( ...
                    targetImageFilePath ...                
                );
                app.targetImageShown = app.targetImageInt16;
            catch error
                uialert(app.window, error.message, 'Image Error');
                return;
            end 
 
            imagesc(app.targetImageViewer, app.targetImageShown);
            app.updateRegistrationCombinedImageViewer();
        end 
        
        function updateRegistrationCombinedImageViewer(app)
            app.info( ...
                'updateRegistrationCombinedImageViewer.', ...
                true ...
           );              

           if (~isempty(app.movingImageShown) ... 
                   && ~isempty(app.targetImageShown))     
               
               pairedImage = imfuse( ...
                   app.movingImageShown, ...
                   app.targetImageShown ...
               );
               imagesc( ...
                   app.registrationCombinedImageViewer, ...
                   pairedImage ...
               );
           
               app.register();
           end   
        end 
       
        function updateRegistrationRegisteredImageViewer( ...
           app, ...
           registeredImage ...
        )
            app.info( ...
                'updateRegistrationRegisteredImageViewer.', ...
                true ...
           );              

           imagesc( ...
               app.registrationRegisteredImageViewer, ...
               registeredImage ...
           );
        end                 
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 6. PRIVATE REGISTRATION FUNCTIONS                                *
    % *                                                                  *
    % ********************************************************************        
    methods (Access = private)

        function registeredImage = register(app)            
            app.info( ...
                 'Register.', ...
                 true ...
             );
         
            [optimizer, metric] = imregconfig('multimodal');
            
            optimizer.MaximumIterations = ...
                round(app.registrationIterationsKnob.Value);
            
            optimizer.InitialRadius = ...
                app.registrationRadiusKnob.Value;

            registeredImage = imregister( ...
                app.movingImageShown, ...
                app.targetImageShown, ...
                'affine', ...
                optimizer, ...
                metric ...
            );
        
             app.updateRegistrationRegisteredImageViewer( ...
                registeredImage ...
            );        
        end               
    end     
        
    % ********************************************************************  
    % *                                                                  *
    % * 7. PRIVATE UTILITY FUNCTIONS                                     *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)

        function clearCommandWindow(app)
            app.info('Clearing the command window.', false);
            if (app.SHOULD_CLEAR_COMMAND_WINDOW == true)
               clc; 
            end    
        end
        
        function convertedImage = convertToGrey(app, imageFilePath)
            app.info('Convert to grey.', true);

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
        
        function info(app, message, shouldLogInfo)
            if (app.SHOW_INFO_FLAG == true)
                disp(message);

                if (shouldLogInfo == true)
                    loggerText = strcat( ... 
                        app.logger.Text, ...
                        '\n\', ...
                        message ...
                    );
                    app.logger.Text = loggerText;
                end                   
            end 
        end
        
        function image = loadImage(~, imageFilePath)
            try
               image = imread(imageFilePath);
            catch
                
                try
                   info = dicominfo(imageFilePath);
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
    % * 8. PRIVATE CREATE WINDOW AND CHILD COMPONENT FUNCTIONS           *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)

        function createWindow(app)
            app.info('Creating the window', false);
            
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
            app.info( ...
                'Creating the child compomnents for the window.', ...
                false ...
            );
            
            app.createChildComponentTabGroup();
            app.createChildComponentTabLogger();
            app.createChildComponentLogger();

            app.createChildComponentTabRegistration();
            app.createChildComponentInstructions();
            app.createChildComponentTitle();
            
            app.createChildComponentMovingImagePanel();
            app.createChildComponentRegistrationOptionsPanel();
            app.createChildComponentTargetImagePanel();            
        end
        
        function createChildComponentTabGroup(app)
            app.info('Creating the tabGroup child compomnent.', false);
            
            app.tabGroup = uitabgroup(app.window);
            app.tabGroup.Position = app.TAB_GROUP_POSITION;
        end
        
        function createChildComponentTabLogger(app)
            app.info('Creating the tabLogger child compomnent.', false);
            
            app.tabLogger = uitab(app.tabGroup);
            app.tabLogger.Title = app.TAB_LOGGER_TITLE;
        end
        
        function createChildComponentTabRegistration(app)
            app.info( ...
                'Creating the tabRegistration child compomnent.', ...
                false ...
            );
            
            app.tabRegistration = uitab(app.tabGroup);
            app.tabRegistration.Title = app.TAB_REGISTRATION_TITLE;
        end
        
        function createChildComponentLogger(app)
            app.info('Creating the logger child compomnent.', false);
            
            app.loggerLabel = uilabel(app.tabLogger);
            
            app.loggerLabel.HorizontalAlignment = ...
                app.LOGGER_LABEL_HORIZONTAL_POSITION;
            
            app.loggerLabel.Position = ...
                app.LOGGER_LABEL_POSITION;
            
            app.loggerLabel.Text = ...
                app.LOGGER_LABEL_TEXT;
            
            app.logger = uilabel(app.tabLogger);
            app.logger.Text = app.LOGGER_TEXT_DEFAULT;
            app.logger.Position = app.LOGGER_POSITION;
        end
        
        function createChildComponentTargetImagePanel(app)
            app.info( ...
                'Creating the targetImagePanel child compomnent.', ...
                true ...
            );
            
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
        end
        
        function createChildComponentMovingImagePanel(app)
            app.info( ...
                'Creating the movingImagePanel child compomnent.', ...
                true ...
            );
            
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
            
            app.movingImageLoadButton = uibutton( ...
                app.movingImagePanel, ...
                app.MOVING_IMAGE_LOAD_BUTTON_TYPE ...
            );
            
            app.movingImageLoadButton.Position = ...
                app.MOVING_IMAGE_LOAD_BUTTON_POSITION;
            
            app.updateMovingImageLoadButtonText( ...
                app.MOVING_IMAGE_LOAD_BUTTON_TITLE_DEFAULT ...
            );    
            
            app.movingImageLoadButton.ButtonPushedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onButtonClickLoadMovingImage, ...
                    true ...
                );            
        end
        
        function createChildComponentRegistrationOptionsPanel(app)
            app.info( ...
                'Creating registrationOptionsPanel.', ...
                true ...
            );                
        
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
            
            app.registrationIterationsKnob.Limits = [1, 1000];
            app.registrationIterationsKnob.Value = 100;
            
            app.registrationIterationsKnob.Position = ...
                app.REGISTRATION_ITERATIONS_KNOB_POSITION;
            
            app.registrationIterationsKnob.ValueChangedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onKnobValueChange, ...
                    true ...
                );  
            
            app.registrationRadiusKnob = ...
                uiknob(app.registrationOptionsPanel);
            
            app.registrationRadiusKnob.Limits = [0.001, 0.01];
            app.registrationRadiusKnob.Value = 0.0063;
            
            app.registrationRadiusKnob.Position = ...
                app.REGISTRATION_RADIUS_KNOB_POSITION;
            
            app.registrationRadiusKnob.ValueChangedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onKnobValueChange, ...
                    true ...
                );  
            
        end
        
        function createChildComponentInstructions(app)
            app.info( ...
                'Creating the instructions child compomnent.', ...
                true ...
            );
            
            app.instructions = uilabel(app.tabRegistration);
            app.instructions.Position = app.INSTRUCTIONS_POSITION;
            app.instructions.Text = app.INSTRUCTIONS_TEXT;
        end
        
        function createChildComponentTitle(app)
            app.info( ...
                'Creating the title child compomnent.', ...
                true ...
            );
            
            app.title = uilabel(app.window);
            app.title.FontSize = app.TITLE_FONT_SIZE;
            app.title.Position = app.TITLE_POSITION;
            app.title.Text = app.TITLE_TEXT;
        end
    end    
end
