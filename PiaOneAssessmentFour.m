classdef PiaOneAssessmentFour < matlab.apps.AppBase

    % ********************************************************************  
    % *                                                                  *
    % * ASSESSMENT 4                                                     *
    % *                                                                  *
    % * Student ID: S1888637                                             *
    % * Date: 30th November 2019                                         *
    % *                                                                  *
    % * Version (Git tag): 0.1.4                                         *
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
    % * 1.c UI component constants.                                      *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        BUTTON_LOAD_IMAGE_POSITION = [109 80 225 22];
        BUTTON_LOAD_IMAGE_TEXT = 'Load image';
        BUTTON_LOAD_IMAGE_TYPE = 'push';
        
        BUTTON_REGISTER_IMAGE_POSITION = [109 150 225 22];
        BUTTON_REGISTER_IMAGE_TEXT = 'Register image';
        BUTTON_REGISTER_IMAGE_TYPE = 'push';
        
        IMAGE_FILE_PATH_LABEL_DEFAULT_TEXT = '';
        IMAGE_FILE_PATH_LABEL_HORIZONTAL_ALIGNMENT = 'right';
        IMAGE_FILE_PATH_LABEL_POSITION = [109 126 106 22];
        
        IMAGE_FILE_TYPE_LABEL_DEFAULT_TEXT = '';
        IMAGE_FILE_TYPE_LABEL_HORIZONTAL_ALIGNMENT = 'right';
        IMAGE_FILE_TYPE_LABEL_POSITION = [200 126 106 22];
        
        IMAGE_VIEWER_POSITION = [43 181 357 305];
        
        WINDOW_AUTO_RESIZE_CHILDREN = 'off';
        WINDOW_POSITION = [100 100 702 528];
        WINDOW_RESIZE = 'off';
        WINDOW_TITLE = 'PiaOneAssessmentFour';             
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 1.d UI child component usage constants.                          *
    % *                                                                  *
    % ********************************************************************
    properties (Constant)
        USE_BUTTON_LOAD_IMAGE = true;
        USE_BUTTON_REGISTER_IMAGE = true;
        USE_IMAGE_FILE_PATH_LABEL = true;
        USE_IMAGE_FILE_TYPE_LABEL = true;
        USE_IMAGE_VIEWER = true;
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
        buttonRegisterImage  matlab.ui.control.Button
        image
        imageFilePathLabel   matlab.ui.control.Label
        imageFileTypeLabel   matlab.ui.control.Label
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
            
            if (app.USE_BUTTON_LOAD_IMAGE == true)
                app.createChildComponentLoadImageButton();
            end
            
            if (app.USE_BUTTON_REGISTER_IMAGE == true)
                app.createChildComponentRegisterImageButton();
            end
            
            if (app.USE_IMAGE_FILE_PATH_LABEL == true)
                app.createChildComponentImageFilePathLabel();
            end

            if (app.USE_IMAGE_FILE_TYPE_LABEL == true)
                app.createChildComponentImageViewer();
            end

            if (app.USE_IMAGE_FILE_TYPE_LABEL == true)
                app.createChildComponentImageFileTypeLabel();
            end    
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
        
        function createChildComponentImageFileTypeLabel(app)
            app.info('Creating the imageFileType label compomnent.');

            app.imageFileTypeLabel = uilabel(app.window);
            
            app.imageFileTypeLabel.HorizontalAlignment ...
                = app.IMAGE_FILE_TYPE_LABEL_HORIZONTAL_ALIGNMENT;
            
            app.imageFileTypeLabel.Position ...
                = app.IMAGE_FILE_TYPE_LABEL_POSITION;
            
            app.imageFileTypeLabel.Text ...
                = app.IMAGE_FILE_TYPE_LABEL_DEFAULT_TEXT;
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
        
        function createChildComponentRegisterImageButton(app)
            app.info( ...
                'Creating the Register Image Button child compomnent.' ...
            );
            
            app.buttonRegisterImage = uibutton( ...
                app.window, ...
                app.BUTTON_REGISTER_IMAGE_TYPE ...
            );
            app.buttonRegisterImage.ButtonPushedFcn = createCallbackFcn( ...
                app, ...
                @onButtonRegisterImageClick, ...
                true ...
            );
            app.buttonRegisterImage.Position ...
                = app.BUTTON_REGISTER_IMAGE_POSITION;
            
            app.buttonRegisterImage.Text ...
                = app.BUTTON_REGISTER_IMAGE_TEXT;
        end        
    end
    
    % ********************************************************************  
    % *                                                                  *
    % * 4. PRIVATE EVENT FUNCTIONS                                       *
    % *                                                                  *
    % ********************************************************************
    methods (Access = private)
        
        function onButtonLoadImageClick(app, ~)
            app.info('Callback: onButtonLoadImageClick.');   

            imageFileUploadSpecification = { ...
                app.IMAGE_FILE_EXTENSIONS_WHITELIST, ...
                'All recognised image files' ...
            };
            [f, p] = uigetfile(imageFileUploadSpecification);
            
            if (ischar(p))
               imageFilePath = [p f];
               app.updateImagePathLabel(imageFilePath);
               app.updateImageTypeLabel(imageFilePath);
               app.updateImageViewer(imageFilePath);
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
        
        function performRegistration(app) 
            app.info('Perform registration');
        end
        
        function updateImagePathLabel(app, imageFilePath)
            app.info('Update the imageFilePath label.');
  
            if (app.USE_IMAGE_FILE_PATH_LABEL == true)
                app.imageFilePathLabel.Text = imageFilePath;
            end    
        end
        
        function updateImageTypeLabel(app, imageFilePath)
            app.info('Update the imageFileType label.');
  
            if (app.USE_IMAGE_FILE_TYPE_LABEL == true)
                app.imageFileTypeLabel.Text = imageFilePath;
            end    
        end
        
        function updateImageViewer(app, imageFilePath)
            
            try
                app.image = imread(imageFilePath);
            catch error
                uialert(app.UIFigure, error.message, 'Image Error');
                return;
            end 
  
            if (app.USE_IMAGE_VIEWER == true)
                imagesc(app.imageViewer, app.image);
            end    
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

