classdef PiaOneAssessmentFour < matlab.apps.AppBase

    % ********************************************************************  
    % *                                                                  *
    % * ASSESSMENT 4                                                     *
    % *                                                                  *
    % * Student ID: S1888637                                             *
    % * Date: 30th November 2019                                         *
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
    % * 1.c UI constants.                                                *
    % *                                                                  *
    % ********************************************************************
    properties (Access = private)
        BUTTON_LOAD_IMAGE_POSITION = [109 80 225 22];
        BUTTON_LOAD_IMAGE_TEXT = 'Load image';
        BUTTON_LOAD_IMAGE_TYPE = 'push';
        
        WINDOW_AUTO_RESIZE_CHILDREN = 'off';
        WINDOW_POSITION = [100 100 702 528];
        WINDOW_RESIZE = 'off';
        WINDOW_TITLE = 'PiaOneAssessmentFour';             
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 2. PROPERTIES.                                                   *
    % *                                                                  *
    % ********************************************************************
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.a PUBLIC PROPERTIES                                            *
    % *                                                                  *
    % ********************************************************************
    properties (Access = public)
        buttonLoadImage      matlab.ui.control.Button
        imageViewer          matlab.ui.Figure
        window               matlab.ui.Figure
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 2. PUBLIC FUNCTIONS                                              *
    % *                                                                  *
    % ********************************************************************
    methods (Access = public)

        % Construct app
        function app = PiaOneAssessmentFour
            app.info('PiaOneAssessmentFour constructor.');
            app.clearCommandWindow();
            
            app.createWindow();
            
            % Register the app with app Designer
            registerApp(app, app.window);

            % Execute the startup function
            runStartupFcn(app, @onStartup);

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete window when app is deleted
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
            
            app.window = uifigure('Visible', 'off');
            app.window.AutoResizeChildren = app.WINDOW_AUTO_RESIZE_CHILDREN;
            app.window.Position = app.WINDOW_POSITION;
            app.window.Resize = app.WINDOW_RESIZE;
            app.window.Name = app.WINDOW_TITLE;
            
            app.createChildComponents()
            app.window.Visible = 'on';
        end
        
        function createChildComponents(app)
            app.info('Creating the child compomnents for the window.');
            
            app.createChildComponentLoadImageButton();
        end
        
        function createChildComponentImageView(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 702 528];
            app.UIFigure.Name = 'Image Histograms';
            app.UIFigure.Resize = 'off';    
        end
        
        function createChildComponentLoadImageButton(app)
            app.info('Creating the Load Image Button child compomnent.');
            
            app.buttonLoadImage = uibutton( ...
                app.window, ...
                app.BUTTON_LOAD_IMAGE_TYPE ...
            );
            app.buttonLoadImage.ButtonPushedFcn = createCallbackFcn( ...
                app, ...
                @onButtonLoadImageClick, ...
                true ...
            );
            app.buttonLoadImage.Position = app.BUTTON_LOAD_IMAGE_POSITION;
            app.buttonLoadImage.Text = app.BUTTON_LOAD_IMAGE_TEXT;
        end
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 4. PRIVATE EVENT FUNCTIONS                                       *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)
        
        function onButtonLoadImageClick(app, ~)
            app.info('Creating the Load Image Button child compomnent.');   

            filterspec = { ...
                app.IMAGE_FILE_EXTENSIONS_WHITELIST, ...
                'All recognised image files' ...
            };
            [~, p] = uigetfile(filterspec);
            
            % Make sure user didn't cancel uigetfile dialog
            if (ischar(p))
               % fname = [p f];
               % updateimage(app, fname);
            end
        end
        
        function onStartup(app)
            app.info('Startup function.'); 
        end  
    end   
  
    % ********************************************************************  
    % *                                                                  *
    % * 5. PRIVATE UTILITY FUNCTIONS                                     *
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
