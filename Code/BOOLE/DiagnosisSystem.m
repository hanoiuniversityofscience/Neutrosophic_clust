function varargout = DiagnosisSystem(varargin)
% DIAGNOSISSYSTEM MATLAB code for DiagnosisSystem.fig
%      DIAGNOSISSYSTEM, by itself, creates a new DIAGNOSISSYSTEM or raises the existing
%      singleton*.
%
%      H = DIAGNOSISSYSTEM returns the handle to a new DIAGNOSISSYSTEM or the handle to
%      the existing singleton*.
%
%      DIAGNOSISSYSTEM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIAGNOSISSYSTEM.M with the given input arguments.
%
%      DIAGNOSISSYSTEM('Property','Value',...) creates a new DIAGNOSISSYSTEM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DiagnosisSystem_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DiagnosisSystem_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DiagnosisSystem

% Last Modified by GUIDE v2.5 30-May-2017 10:45:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DiagnosisSystem_OpeningFcn, ...
    'gui_OutputFcn',  @DiagnosisSystem_OutputFcn, ...
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


% --- Executes just before DiagnosisSystem is made visible.
function DiagnosisSystem_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DiagnosisSystem (see VARARGIN)

% Choose default command line output for DiagnosisSystem
handles.output = hObject;

set(handles.btn_analyze, 'enable', 'off');
% set(handles.cf_lv_beta, 'visible', 'off');
% set(handles.max_num_iter, 'visible', 'off');
set(handles.btn_segment, 'enable', 'off');
set(handles.cf_lv_beta, 'enable', 'off');
set(handles.edit_result, 'visible', 'off');
guidata(hObject, handles);

% UIWAIT makes DiagnosisSystem wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DiagnosisSystem_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_result_Callback(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_result as text
%        str2double(get(hObject,'String')) returns contents of edit_result as a double


% --- Executes during object creation, after setting all properties.
function edit_result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_segment.
function btn_segment_Callback(hObject, eventdata, handles)
% hObject    handle to btn_segment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%set(handles.btn_open, 'enable', 'off');
%x = get(handles.open_file, 'UserData');
x = get(handles.open_file, 'string');

IM=x;

clv_beta = get(handles.cf_lv_beta,'UserData');
clv_beta=clv_beta(1,1);
global h;
h = waitbar(0, 'Processing...', 'Position', [250, 200, 270, 50]);
tic;
set(handles.btn_segment, 'enable', 'off');
waitbar(0.25);
[image_out]=test_boole(IM,clv_beta);
waitbar(0.5);
%pause(1);
handles.clv_beta = clv_beta;
handles.IM = IM;
waitbar(1)
handles.elapsed_time = toc;

close(h);

set(handles.org_img_panel, 'visible', 'on');
axes(handles.original_img);
imshow(image_out);
imwrite(image_out, ['Output_' handles.filename]);
set(handles.btn_analyze, 'enable', 'on');
guidata(hObject, handles);

% --- Executes on button press in btn_analyze.
function btn_analyze_Callback(hObject, eventdata, handles)
% hObject    handle to btn_analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_result, 'visible', 'on');
%set(handles.btn_open, 'enable', 'off');
set(handles.btn_segment, 'enable', 'off');
% cf_lv_beta = get(handles.cf_lv_beta,'UserData');

global time;
time = waitbar(0, 'Analyzing...', 'Position', [250, 200, 270, 50]);
tic;
waitbar(0.25);
x = get(handles.open_file, 'string');
fname = sprintf('C:\\TEST_150517\\BOOLE\\%s\\BOOLE.txt',x);
data=load(fname);
finalStr='';
str1=sprintf('DB: %f\n',data(1,:));
str2=sprintf('SWC: %f\n',data(2,:));
str3=sprintf('IFV: %f\n',data(3,:));
str4=sprintf('PBM: %f\n',data(4,:));
str5=sprintf('VM: %f\n',data(5,:));
str6=sprintf('Time runing: %f\n',data(6,:));
finalStr=[finalStr,str1,str2,str3,str4,str5,str6];
waitbar(0.75);
set(handles.edit_result,'String',finalStr);
waitbar(1)
handles.elapsed_time = toc;
close(time);
set(handles.btn_analyze, 'enable', 'off');

% --- Executes on button press in btn_open.
function btn_open_Callback(hObject, eventdata, handles)
% hObject    handle to btn_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
guidata(hObject, handles);
[filename, pathname] = uigetfile({'*.jpg'}, 'Pick a medical image');


if filename ~= 0
    set(handles.open_file,'string', filename);
    
    IM = imread([pathname, filename]);
    
    %     imfinfo([pathname, filename])
    
    set(handles.org_img_panel, 'visible', 'on');
        
    axes(handles.original_img);
    imshow(IM);
    
    handles.num_of_data_point = size(IM(:, : , 1), 1) * size(IM(:, : , 1), 2);
    handles.filename = filename;
    
    set(handles.btn_segment, 'enable', 'on');
    set(handles.cf_lv_beta, 'enable', 'on');
    set(handles.cf_lv_beta,'UserData', 0);
    set(handles.cf_lv_beta,'string', '0');

    set(handles.original_img,'UserData',IM);
else
    set(handles.open_file,'string', 'No file is chosen.');
    
    set(handles.org_img_panel, 'visible', 'off');
end
guidata(hObject, handles);


function open_file_Callback(hObject, eventdata, handles)
% hObject    handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of open_file as text
%        str2double(get(hObject,'String')) returns contents of open_file as a double


% --- Executes during object creation, after setting all properties.
function open_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to open_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cf_lv_beta_Callback(hObject, eventdata, handles)
% hObject    handle to cf_lv_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cf_lv_beta as text
%        str2double(get(hObject,'String')) returns contents of cf_lv_beta as a double
str = get(hObject,'string');
data = str2double(str);
if isnan(data) || data < 0
    errordlg('The minimum amount of improvement (eps) must be greater than 0. Example: 0.01, 0.006...', 'Bad input');
    set(hObject,'BackgroundColor','r');
    set(handles.btn_segment, 'enable', 'off');
else
    set(hObject,'BackgroundColor','w');
    set(handles.btn_segment, 'enable', 'on');
    set(hObject,'UserData',data);
end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function cf_lv_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cf_lv_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function conf_lv_beta_Callback(hObject, eventdata, handles)
% hObject    handle to cf_lv_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cf_lv_beta as text
%        str2double(get(hObject,'String')) returns contents of cf_lv_beta as a double

% --- Executes during object creation, after setting all properties.
function conf_lv_beta_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cf_lv_beta (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

% --- Executes on button press in btn_about.
function btn_about_Callback(hObject, eventdata, handles)
% hObject    handle to btn_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

str1 = sprintf('MEDICAL IMAGE SEGMENTATION SYSTEM\n\n');
str2 = sprintf('Click Open button to select an image.\n Click Segment button\n Click Analyze button to take Indexs and get the result.\n\n');
str3 = sprintf('WARNING: Result retrieved from this system is NOT 100%% guaranteed correctly.\n');
str4 = sprintf('This is just reference for the doctors to make their decision.\n\n');
str5 = sprintf('Hanoi - 6/2017.\n\n');
msgbox([str1, str2, str3, str4,str5], 'Help', 'help');
% --- Executes on button press in btn_close.
function btn_close_Callback(hObject, eventdata, handles)
% hObject    handle to btn_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

