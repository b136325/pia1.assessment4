classdef PiaOneAssessmentFour < matlab.apps.AppBase

    % ********************************************************************  
    % *                                                                  *
    % * ASSESSMENT 4                                                     *
    % *                                                                  *
    % * Student ID: S1888637                                             *
    % * Date: 30th November 2019                                         *
    % *                                                                  *
    % * Version (Git tag): 0.1.7                                         *
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
        TARGET_IMAGE_LOAD_BUTTON_TITLE = 'Load';
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
        MOVING_IMAGE_LOAD_BUTTON_TITLE = 'Load';
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
        instructions                matlab.ui.control.Label
        title                       matlab.ui.control.Label
        window                      matlab.ui.Figure
    end

    % ********************************************************************  
    % *                                                                  *
    % * 1.b PUBLIC PROPERTIES: Tab group and tabs.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        tabGroup                    matlab.ui.container.TabGroup
        tabLogger                   matlab.ui.container.Tab
        tabRegistration             matlab.ui.container.Tab
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.c PUBLIC PROPERTIES: Target image panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        targetImage                 
        targetImageViewer           matlab.ui.control.UIAxes
        targetImageLoadButton       matlab.ui.control.Button
        targetImagePanel            matlab.ui.container.Panel        
    end
        
    % ********************************************************************  
    % *                                                                  *
    % * 1.d PUBLIC PROPERTIES: Moving image panel.                       *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        movingImage                 
        movingImageViewer           matlab.ui.control.UIAxes
        movingImageLoadButton       matlab.ui.control.Button
        movingImagePanel            matlab.ui.container.Panel       
    end

    % ********************************************************************  
    % *                                                                  *
    % * 1.e PUBLIC PROPERTIES: Registration options panel.               *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        registrationOptionsPanel    matlab.ui.container.Panel       
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.f PUBLIC PROPERTIES: Logger.                                   *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        logger                      matlab.ui.control.TextArea
        loggerLabel                 matlab.ui.control.Label
    end        

    % ********************************************************************  
    % *                                                                  *
    % * 2. PUBLIC FUNCTIONS                                              *
    % *                                                                  *
    % ********************************************************************
    methods (Access = public)

        function app = PiaOneAssessmentFour
            app.info('PiaOneAssessmentFour constructor.');
            app.clearCommandWindow();
            
            app.createWindow();
            registerApp(app, app.window);
            runStartupFcn(app, @onStartup);

            if nargout == 0
                clear app
            end
        end

        function delete(app)
            app.info('Delete app.');
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
            app.createChildComponentTabLogger();
            
            app.createChildComponentInstructions();
            app.createChildComponentLogger();
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
        
        function createChildComponentTabLogger(app)
            app.info('Creating the tabLogger child compomnent.');
            
            app.tabLogger = uitab(app.tabGroup);
            app.tabLogger.Title = app.TAB_LOGGER_TITLE;
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
            
            app.targetImageLoadButton.Text = ...
                app.TARGET_IMAGE_LOAD_BUTTON_TITLE;
            
            app.targetImageLoadButton.ButtonPushedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onButtonLoadTargetImageClick, ...
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
            
            app.movingImageLoadButton = uibutton( ...
                app.movingImagePanel, ...
                app.MOVING_IMAGE_LOAD_BUTTON_TYPE ...
            );
            
            app.movingImageLoadButton.Position = ...
                app.MOVING_IMAGE_LOAD_BUTTON_POSITION;
            
            app.movingImageLoadButton.Text = ...
                app.MOVING_IMAGE_LOAD_BUTTON_TITLE;
            
            app.movingImageLoadButton.ButtonPushedFcn = ...
                createCallbackFcn( ...
                    app, ...
                    @onButtonLoadMovingImageClick, ...
                    true ...
                );            
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
        end
        
        function createChildComponentInstructions(app)
            app.info('Creating the instructions child compomnent.');
            
            app.instructions = uilabel(app.tabRegistration);
            app.instructions.Position = app.INSTRUCTIONS_POSITION;
            app.instructions.Text = app.INSTRUCTIONS_TEXT;
        end
        
        function createChildComponentLogger(app)
            app.info('Creating the logger child compomnent.');
            
            app.loggerLabel = uilabel(app.tabLogger);
            
            app.loggerLabel.HorizontalAlignment = ...
                app.LOGGER_LABEL_HORIZONTAL_POSITION;
            
            app.loggerLabel.Position = ...
                app.LOGGER_LABEL_POSITION;
            
            app.loggerLabel.Text = ...
                app.LOGGER_LABEL_TEXT;
            
            app.logger = uitextarea(app.tabLogger);
            app.logger.Position = app.LOGGER_POSITION;
        end
        
        function createChildComponentTitle(app)
            app.info('Creating the title child compomnent.');
            
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
        
        function onButtonLoadMovingImageClick(app, ~)
            app.info('Callback: onButtonLoadMovingImageClick.');   

            imageFileUploadSpecification = { ...
                app.IMAGE_FILE_EXTENSIONS_WHITELIST, ...
                'All recognised image files' ...
            };
            [f, p] = uigetfile(imageFileUploadSpecification);
            
            if (ischar(p))
               imageFilePath = [p f];
               app.enableRegistraterImageButton();
               app.updateImagePathLabel(imageFilePath);
               app.updateImageTypeLabel(imageFilePath);
               app.updateImageViewer(imageFilePath);
            end
        end
        
        function onButtonLoadTargetImageClick(app, ~)
            app.info('Callback: onButtonLoadTargetImageClick.');   

            imageFileUploadSpecification = { ...
                app.IMAGE_FILE_EXTENSIONS_WHITELIST, ...
                'All recognised image files' ...
            };
            [f, p] = uigetfile(imageFileUploadSpecification);
            
            if (ischar(p))
               targetImageFilePath = [p f];
               app.updateTargetImageViewer(targetImageFilePath);
            end
        end
        
        function onButtonRegisterImageClick(app, ~)
             app.info('Callback: onButtonRegisterImageClick.');
             
             app.performRegistration();
             
        end
        
        function onStartup(app)
            app.info('Startup function.'); 
        end  
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 5. PRIVATE IMAGE FUNCTIONS                                       *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)
        
        function updateTargetImageViewer(app, targetImageFilePath)
            
            try
                app.targetImage = imread(targetImageFilePath);
            catch error
                uialert(app.window, error.message, 'Image Error');
                return;
            end 
 
            imagesc(app.targetImageViewer, app.targetImage);  
        end
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 6. PRIVATE UTILITY FUNCTIONS                                     *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)

        function clearCommandWindow(app)
            app.info('Clearing the command window.');
            if (app.SHOULD_CLEAR_COMMAND_WINDOW == true)
               clc; 
            end    
        end
        
        function info(app, message)
            if (app.SHOW_INFO_FLAG == true)
                disp(message);
            end    
        end    
    end    
end
