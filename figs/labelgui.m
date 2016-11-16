function varargout = labelgui(varargin)
% LABELGUI MATLAB code for labelgui.fig
%      LABELGUI, by itself, creates a new LABELGUI or raises the existing
%      singleton*.
%
%      H = LABELGUI returns the handle to a new LABELGUI or the handle to
%      the existing singleton*.
%
%      LABELGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LABELGUI.M with the given input arguments.
%
%      LABELGUI('Property','Value',...) creates a new LABELGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before labelgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to labelgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help labelgui

% Last Modified by GUIDE v2.5 15-Nov-2016 21:05:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @labelgui_OpeningFcn, ...
                   'gui_OutputFcn',  @labelgui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before labelgui is made visible.
function labelgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to labelgui (see VARARGIN)

% Choose default command line output for labelgui
handles.output = hObject;

% Image, bounding boxes, and labels data
textImage = varargin{1};
bboxes = varargin{2};
totalChars = size(bboxes,1);
% Set handles
handles.textImage = textImage;
handles.bboxes = bboxes;
handles.totalChars = totalChars;
handles.currentChar = 1;
handles.labels = strings(totalChars,1);

% Update handles structure
guidata(hObject, handles);

showCharacter(handles);

% UIWAIT makes labelgui wait for user response (see UIRESUME)
uiwait(handles.figure1);


% Display the character image on the axes
function showCharacter(handles)

img = handles.textImage;
bboxes = handles.bboxes;
idx = handles.currentChar;
x1 = floor( bboxes(idx,1) );
y1 = floor( bboxes(idx,2) );
x2 = ceil ( bboxes(idx,1) + bboxes(idx,3) );
y2 = ceil ( bboxes(idx,2) + bboxes(idx,4) );
img = img(y1:y2,x1:x2,:);

axes(handles.axes_image);
imshow(img);


% --- Outputs from this function are returned to the command line.
function varargout = labelgui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;

varargout{1} = handles.labels;
delete(handles.figure1);


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on button press in btn_skip.
function btn_skip_Callback(hObject, eventdata, handles)
% hObject    handle to btn_skip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

idx = handles.currentChar;
if(idx < handles.totalChars)
    % Set label to empty text
    handles.labels(idx) = '';
    
    % Updates for new input
    handles.input_label.String = '';
    handles.currentChar = idx + 1;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % Show updated image
    showCharacter(handles);
end


% --- Executes on button press in btn_previous.
function btn_previous_Callback(hObject, eventdata, handles)
% hObject    handle to btn_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

idx = handles.currentChar;
if(idx > 1)
    % Updates for new input
    handles.input_label.String = '';
    handles.currentChar = idx - 1;
    
    % Update handles structure
    guidata(hObject, handles);
    
    % Show updated image
    showCharacter(handles);
end


% --- Executes on button press in btn_submit.
function btn_submit_Callback(hObject, eventdata, handles)
% hObject    handle to btn_submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

idx = handles.currentChar;
if(idx <= handles.totalChars)
    % Set label to text entry
    handles.labels(idx) = handles.input_label.String;
    
    % Updates for new input
    handles.input_label.String = '';
    if(idx < handles.totalChars)
        handles.currentChar = idx + 1;
    end
    
    % Update handles structure
    guidata(hObject, handles);
    
    % Show updated image
    showCharacter(handles);
end


function input_label_Callback(hObject, eventdata, handles)
% hObject    handle to input_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_label as text
%        str2double(get(hObject,'String')) returns contents of input_label as a double


% --- Executes during object creation, after setting all properties.
function input_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, close it
    delete(hObject);
end


% --- Executes on key press with focus on input_label and none of its controls.
function input_label_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to input_label (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% Call submit button when return key is pressed and then return UI focus to
% the text entry.
key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    uicontrol(handles.btn_submit);
    btn_submit_Callback(hObject, eventdata, handles);
    uicontrol(handles.input_label);
end
