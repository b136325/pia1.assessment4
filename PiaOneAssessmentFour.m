classdef PiaOneAssessmentFour < matlab.apps.AppBase

    % ********************************************************************  
    % *                                                                  *
    % * ASSESSMENT 4                                                     *
    % *                                                                  *
    % * Student ID: S1888637                                             *
    % * Date: 30th November 2019                                         *
    % *                                                                  *
    % * Version (Git tag): 0.1.2                                         *
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
        
        IMAGE_FILE_PATH_LABEL_DEFAULT_TEXT = '';
        IMAGE_FILE_PATH_LABEL_HORIZONTAL_ALIGNMENT = 'right';
        IMAGE_FILE_PATH_LABEL_POSITION = [109 126 106 22];
        
        IMAGE_VIEWER_POSITION = [43 181 357 305];
        
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
        imageFilePathLabel   matlab.ui.control.Label
        imageViewer          matlab.ui.control.UIAxes
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
            app.createChildComponentImageFilePathLabel();
            app.createChildComponentImageViewer();
        end

        function createChildComponentImageFilePathLabel(app)
            app.info('Creating the imageFilePath label compomnent.');

            app.imageFilePathLabel = uilabel(app.window);
            
            app.imageFilePathLabel.HorizontalAlignment ...
                = app.IMAGE_FILE_PATH_LABEL_HORIZONTAL_ALIGNMENT;
            
            app.imageFilePathLabel.Position ...
                = app.IMAGE_FILE_PATH_LABEL_POSITION;
            
            app.imageFilePathLabel.Text ...
                = app.IMAGE_FILE_PATH_LABEL_DEFAULT_TEXT;
        end
        
        function createChildComponentImageViewer(app)
            app.info('Creating the Image Viewer compomnent.');
            app.imageViewer = uiaxes(app.window);

            app.imageViewer.Position = app.IMAGE_VIEWER_POSITION;   
            app.imageViewer.XTick = [];
            app.imageViewer.XTickLabel = {'[ ]'};
            app.imageViewer.YTick = [];
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

            imageFileUploadSpecification = { ...
                app.IMAGE_FILE_EXTENSIONS_WHITELIST, ...
                'All recognised image files' ...
            };
            [f, p] = uigetfile(imageFileUploadSpecification);
            
            if (ischar(p))
               imageFilePath = [p f];
               app.updateImagePathLabel(imageFilePath);
               app.updateImageViewer(imageFilePath);
            end
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
        
        function updateImagePathLabel(app, imageFilePath)
            app.info('Update the imageFilePath label.');
  
            app.imageFilePathLabel.Text = imageFilePath;
        end
        
        function updateImageViewer(app, imageFilePath)
            app.info('Update the imageViewer.');
  
            image = imread(imageFilePath);
            imagesc(app.imageViewer,image);
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

