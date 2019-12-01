classdef PiaOneAssessmentFour < matlab.apps.AppBase

    % ********************************************************************  
    % *                                                                  *
    % * ASSESSMENT 4                                                     *
    % *                                                                  *
    % * Student ID: S1888637                                             *
    % * Date: 30th November 2019                                         *
    % *                                                                  *
    % * Version (Git tag): 0.2.2                                         *
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
        IMAGE_FILE_EXTENSIONS_WHITELIST = '*.jpg;*.tif;*.png;*.gif';
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.a CONSTANTS: Instructions, title and window.                   *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        INSTRUCTIONS_POSITION = [30 658 68 22];
        INSTRUCTIONS_TEXT = 'Instructions';
        
        TITLE_FONT_SIZE = 20;
        TITLE_POSITION = [19 757 179 26];
        TITLE_TEXT = 'PIA1 Assessment 4';        
       
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
    % * 1.c CONSTANTS: Target image panel.                               *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        TARGET_IMAGE_LOAD_BUTTON_POSITION = [125 308 100 22];
        TARGET_IMAGE_LOAD_BUTTON_TITLE_DEFAULT = 'Load';
        TARGET_IMAGE_LOAD_BUTTON_TITLE_RELOAD = 'Reload';
        TARGET_IMAGE_LOAD_BUTTON_TYPE = 'push';
        
        TARGET_IMAGE_PANEL_FONT_SIZE = 14; 
        TARGET_IMAGE_PANEL_POSITION = [21 21 350 534]; 
        TARGET_IMAGE_PANEL_TITLE = 'Target image';
        
        TARGET_IMAGE_VIEWER_POSITION = [0 350 350 147];
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.d CONSTANTS: Moving image panel.                               *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        MOVING_IMAGE_LOAD_BUTTON_POSITION = [125 308 100 22];
        MOVING_IMAGE_LOAD_BUTTON_TITLE_DEFAULT = 'Load';
        MOVING_IMAGE_LOAD_BUTTON_TITLE_RELOAD = 'Reload';
        MOVING_IMAGE_LOAD_BUTTON_TYPE = 'push';
        
        MOVING_IMAGE_PANEL_FONT_SIZE = 14; 
        MOVING_IMAGE_PANEL_POSITION = [396 21 350 534]; 
        MOVING_IMAGE_PANEL_TITLE = 'Moving image';
        
        MOVING_IMAGE_VIEWER_POSITION = [1 350 349 147];
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.e CONSTANTS: Registration options panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        REGISTER_BUTTON_POSITION = [125 308 100 22];
        REGISTER_BUTTON_TITLE_DEFAULT = 'Register';
        REGISTER_BUTTON_TYPE = 'push';        
        
        REGISTRATION_COMBINED_IMAGE_VIEWER_POSITION = [2 350 349 147];
        REGISTRATION_REGISTERED_IMAGE_VIEWER_POSITION = [2 050 349 147];
        
        REGISTRATION_ITERATIONS_KNOB_POSITION = [2 300 50 50]
        REGISTRATION_RADIUS_KNOB_POSITION = [100 300 50 50]
        
        REGISTRATION_OPTIONS_PANEL_FONT_SIZE = 14;
        REGISTRATION_OPTIONS_PANEL_POSITION = [775 21 444 534];
        REGISTRATION_OPTIONS_PANEL_TITLE = 'Registration options';
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.e CONSTANTS: Logger.                                           *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        LOGGER_LABEL_HORIZONTAL_POSITION = 'right';
        LOGGER_LABEL_POSITION = [27 653 113 22];
        LOGGER_LABEL_TEXT = '';

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
    % * 1.a PUBLIC PROPERTIES: Instructions, title and window.           *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        instructions                        matlab.ui.control.Label
        title                               matlab.ui.control.Label
        window                              matlab.ui.Figure
    end

    % ********************************************************************  
    % *                                                                  *
    % * 1.b PUBLIC PROPERTIES: Tab group and tabs.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        tabGroup                            matlab.ui.container.TabGroup
        tabLogger                           matlab.ui.container.Tab
        tabRegistration                     matlab.ui.container.Tab
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.c PUBLIC PROPERTIES: Target image panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        targetImage                 
        targetImageViewer                   matlab.ui.control.UIAxes
        targetImageLoadButton               matlab.ui.control.Button
        targetImagePanel                    matlab.ui.container.Panel        
    end
        
    % ********************************************************************  
    % *                                                                  *
    % * 1.d PUBLIC PROPERTIES: Moving image panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        movingImage                 
        movingImageViewer                   matlab.ui.control.UIAxes
        movingImageLoadButton               matlab.ui.control.Button
        movingImagePanel                    matlab.ui.container.Panel       
    end

    % ********************************************************************  
    % *                                                                  *
    % * 1.e PUBLIC PROPERTIES: Registration options panel.               *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        registerButton                      matlab.ui.control.Button
        registrationCombinedImageViewer     matlab.ui.control.UIAxes
        registrationIterationsKnob          matlab.ui.control.Knob
        registrationOptionsPanel            matlab.ui.container.Panel
        registrationRadiusKnob              matlab.ui.control.Knob
        registrationRegisteredImageViewer   matlab.ui.control.UIAxes
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.f PUBLIC PROPERTIES: Logger.                                   *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        logger                              matlab.ui.control.Label
        loggerLabel                         matlab.ui.control.Label
    end        

    % ********************************************************************  
    % *                                                                  *
    % * 2. PUBLIC FUNCTIONS                                              *
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
            app.info('Delete app.', false);
            delete(app.window)
        end
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 3. PRIVATE CREATE WINDOW AND CHILD COMPONENT FUNCTIONS           *
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
            
                        app.registerButton = uibutton( ...
                app.registrationOptionsPanel, ...
                app.REGISTER_BUTTON_TYPE ...
            );
        
            app.registerButton.Position = ...
                app.REGISTER_BUTTON_POSITION;
            
            app.registerButton.Text = ...
                app.REGISTER_BUTTON_TITLE_DEFAULT;  
            
            app.registerButton.ButtonPushedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onButtonClickRegister, ...
                    true ...
                ); 
            
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
            
            app.registrationIterationsKnob.Position = ...
                app.REGISTRATION_ITERATIONS_KNOB_POSITION;
            
            app.registrationRadiusKnob = ...
                uiknob(app.registrationOptionsPanel);
            
            app.registrationRadiusKnob.Position = ...
                app.REGISTRATION_RADIUS_KNOB_POSITION;            
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
        
        function onStartup(app)
            app.info('Startup function.', false); 
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
                app.movingImage = imread(movingImageFilePath);
            catch error
                uialert(app.window, error.message, 'Image Error');
                return;
            end 
 
            imagesc(app.movingImageViewer, app.movingImage);
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
                app.targetImage = imread(targetImageFilePath);
            catch error
                uialert(app.window, error.message, 'Image Error');
                return;
            end 
 
            imagesc(app.targetImageViewer, app.targetImage);
            app.updateRegistrationCombinedImageViewer();
        end
        
        function updateRegistrationCombinedImageViewer(app)
             app.info( ...
                 'updateRegistrationCombinedImageViewer.', ...
                 true ...
            );              

            if (~isempty(app.movingImage) && ~isempty(app.targetImage))     
                pairedImage = imfuse( ...
                    app.movingImage, ...
                    app.targetImage ...
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
                optimizer.MaximumIterations * app.INITIAL_RADIUS_INCREASE_FACTOR;
            
            optimizer.InitialRadius = ...
                optimizer.InitialRadius / app.INITIAL_RADIUS_REDUCTION_FACTOR;

            registeredImage = imregister( ...
                app.movingImage, ...
                app.targetImage, ...
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
    % * 6. PRIVATE UTILITY FUNCTIONS                                     *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)

        function clearCommandWindow(app)
            app.info('Clearing the command window.', false);
            if (app.SHOULD_CLEAR_COMMAND_WINDOW == true)
               clc; 
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
    end    
end
