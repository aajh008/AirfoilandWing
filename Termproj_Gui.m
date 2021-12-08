function varargout = Termproj_Gui(varargin)
% TERMPROJ_GUI MATLAB code for Termproj_Gui.fig
%      TERMPROJ_GUI, by itself, creates a new TERMPROJ_GUI or raises the existing
%      singleton*.
%
%      H = TERMPROJ_GUI returns the handle to a new TERMPROJ_GUI or the handle to
%      the existing singleton*.
%
%      TERMPROJ_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TERMPROJ_GUI.M with the given input arguments.
%
%      TERMPROJ_GUI('Property','Value',...) creates a new TERMPROJ_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Termproj_Gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Termproj_Gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Termproj_Gui

% Last Modified by GUIDE v2.5 02-Dec-2021 21:09:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Termproj_Gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Termproj_Gui_OutputFcn, ...
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


% --- Executes just before Termproj_Gui is made visible.
function Termproj_Gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Termproj_Gui (see VARARGIN)

% Choose default command line output for Termproj_Gui

handles.output = hObject;
handles.NACAtype = get(handles.typeNACA,'String'); % NACA 익형 종류
handles.AOA = 0; % AOA 각도
handles.popTE = 1; % TE 열렸는가 닫혔는가 1일시 Close 2일시 Open
handles.radioShowCamberline = 0; % Chamberline 유무 0일시 없음
handles.color = 'k-'; % airfoil 기본 색
handles.Show_line = 0; % c/4 line 유무 0일시 없음
axes(handles.axes1)
title('NACA 익형');

grid on
axes(handles.axes2)
grid on
title('Wing')

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Termproj_Gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Termproj_Gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in Show_Chamber.
function Show_Chamber_Callback(hObject, eventdata, handles)
% hObject    handle to Show_Chamber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Show_Chamber
if(get(hObject,'Value') == get(hObject,'Max')) % check 시 Value 값 1 , MAX 기본값 1
    handles.Show_Chamber = 1;
else
    handles.Show_Chamber = 2;
end

guidata(hObject, handles);


% --- Executes on button press in Push_Plot_Airfoil.
function Push_Plot_Airfoil_Callback(hObject, eventdata, handles)
% hObject    handle to Push_Plot_Airfoil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % make_NACA function에서 Airfoil 그리는데 필요한 [xu, yu, xl, yl]을 도출
[xu,yu,xl,yl] = make_NACA(handles.NACAtype,handles.popTE);
% % % % % AOA 값에 따른 축 설정
x_qc = 0.25; % 기본 축
y_qc = 0; % 기본 축
axisofRot = [0 0 1]; % 돌릴 축 설정
origin = [x_qc y_qc 0];
thetaRot = -handles.AOA; % 돌릴 각도, AOA 이므로 * -1 값

% % % % % % % % % % % % % 새로운 plot 전에 axes1을 비워줌
hold off
x = 0;
y= 0;
axes(handles.axes1)
plot(x,y)
title('NACA 익형');

grid on
% % % % % % % % % % % % % 
hold on

rotate(plot(xu,yu,handles.color),axisofRot,thetaRot,origin);
rotate(plot(xl,yl,handles.color),axisofRot,thetaRot,origin);
if handles.Show_Chamber == 1
    chamberline.x1 = (xu+xl)/2;
    chamberline.y1 = (yu+yl)/2;
    rotate(plot(chamberline.x1,chamberline.y1,'r-'),axisofRot,thetaRot,origin);
end

axis equal
title('NACA 익형');

grid on
guidata(hObject, handles);


% --- Executes on selection change in popplot_color.
function popplot_color_Callback(hObject, eventdata, handles)
% hObject    handle to popplot_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
contents = get(hObject,'String');
choice = contents(get(hObject,'Value'));
if strcmp(choice,'Black')
    handles.color = 'k-';
elseif strcmp(choice,'Blue')
    handles.color = 'b-';
else
    handles.color = 'g-';
end

guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns popplot_color contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popplot_color


% --- Executes during object creation, after setting all properties.
function popplot_color_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popplot_color (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in popT_E.
function popT_E_Callback(hObject, eventdata, handles)
% hObject    handle to popT_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popT_E contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popT_E
contents = cellstr(get(hObject,'String'));
popchoice = lower(contents(get(hObject,'Value')));
if (strcmp(popchoice,'open'))
    handles.popTE = 2;
elseif(strcmp(popchoice,'close'))
    handles.popTE = 1;
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popT_E_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popT_E (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);


function AOA_edit_Callback(hObject, eventdata, handles)
% hObject    handle to AOA_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AOA_edit as text
%        str2double(get(hObject,'String')) returns contents of AOA_edit as a double
handles.AOA = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function AOA_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AOA_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function typeNACA_Callback(hObject, eventdata, handles)
% hObject    handle to typeNACA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of typeNACA as text
%        str2double(get(hObject,'String')) returns contents of typeNACA as a double
handles.NACAtype = get(handles.typeNACA,'String'); % 새로운 익형 데이터 받아줌
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function typeNACA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typeNACA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Push_Exit.
function Push_Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Push_Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1); % 프로그램 종료


% --- Executes on button press in Plot_Wing.
function Plot_Wing_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_Wing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hold off
x = 0;
y= 0;
axes(handles.axes2)
plot(x,y)
title('Wing');

grid on

[x_new1,x_new2,x_new3,x_new4,y_new1,y_new2,y_new3,y_new4,area,AR] = wing_new(handles.SWB,handles.RCL,handles.TCL,handles.SL);
axes(handles.axes2)

hold on
title('Wing')
plot(x_new1,y_new1,'b');           %%위쪽 Leading Edge
plot(x_new1,-y_new1,'b');          %%아래쪽 Leading Edge
plot(x_new2,y_new2,'b');           %%위쪽 Trailing Edge
plot(x_new2,-y_new2,'b');          %%아래쪽 Trailing Edge
plot(x_new3,y_new3,'b');           %%위쪽 Tip
plot(x_new3,-y_new3,'b');          %%아래쪽 Tip
if handles.Show_line == 1
    plot(x_new4,y_new4,'r:');           %%c/4
    plot(x_new4,-y_new4,'r:');           %%c/4
end

axis equal


set(handles.Wing_Area,'String',area);
set(handles.AoR,'String',AR);

guidata(hObject,handles);



function Span_Effectiveness_Callback(hObject, eventdata, handles)
% hObject    handle to Span_Effectiveness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Span_Effectiveness as text
%        str2double(get(hObject,'String')) returns contents of Span_Effectiveness as a double
handles.Span_Effectiveness = str2double(get(hObject,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Span_Effectiveness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Span_Effectiveness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Weight_Callback(hObject, eventdata, handles)
% hObject    handle to Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Weight as text
%        str2double(get(hObject,'String')) returns contents of Weight as a double
handles.Weight = str2double(get(hObject,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Weight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Weight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Altitude_Callback(hObject, eventdata, handles)
% hObject    handle to Altitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Altitude as text
%        str2double(get(hObject,'String')) returns contents of Altitude as a double
handles.Altitude = str2double(get(hObject,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Altitude_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Altitude (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Velocity_Callback(hObject, eventdata, handles)
% hObject    handle to Velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Velocity as text
%        str2double(get(hObject,'String')) returns contents of Velocity as a double
handles.Velocity = str2double(get(hObject,'String'));
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Velocity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Velocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SWB_Callback(hObject, eventdata, handles)
% hObject    handle to SWB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SWB as text
%        str2double(get(hObject,'String')) returns contents of SWB as a double
handles.SWB = str2double(get(hObject,'String'))*pi/180;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SWB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SWB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RCL_Callback(hObject, eventdata, handles)
% hObject    handle to RCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RCL as text
%        str2double(get(hObject,'String')) returns contents of RCL as a double
handles.RCL = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function RCL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TCL_Callback(hObject, eventdata, handles)
% hObject    handle to TCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TCL as text
%        str2double(get(hObject,'String')) returns contents of TCL as a double
handles.TCL = str2double(get(hObject,'String'));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function TCL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TCL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SL_Callback(hObject, eventdata, handles)
% hObject    handle to SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SL as text
%        str2double(get(hObject,'String')) returns contents of SL as a double
handles.SL = str2double(get(hObject,'String'));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AoR_Callback(hObject, eventdata, handles)
% hObject    handle to AoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AoR as text
%        str2double(get(hObject,'String')) returns contents of AoR as a double
handles.AoR = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function AoR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AoR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Wing_Area_Callback(hObject, eventdata, handles)
% hObject    handle to Wing_Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Wing_Area as text
%        str2double(get(hObject,'String')) returns contents of Wing_Area as a double
handles.Wing_Area = str2double(get(hObject,'String'));
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Wing_Area_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Wing_Area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Calculation_push.
function Calculation_push_Callback(hObject, eventdata, handles)
% hObject    handle to Calculation_push (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.area = str2double(get(handles.Wing_Area,'String'));
handles.AR = str2double(get(handles.AoR,'String'));
[Lift,Drag,Liftcoef,Dragcoef] = function_math(handles.Profile_coef,handles.area,handles.AR,handles.Span_Effectiveness,handles.Weight,handles.Altitude,handles.Velocity);

set(handles.Lift_Value,'String',Lift);
set(handles.Drag,'String',Drag);
set(handles.Lift_coef,'String',Liftcoef);
set(handles.Drag_coef,'String',Dragcoef);
guidata(hObject,handles);


% --- Executes on button press in Show_line.
function Show_line_Callback(hObject, eventdata, handles)
% hObject    handle to Show_line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Show_line
if(get(hObject,'Value') == get(hObject,'Max')) % check 시 Value 값 1 , MAX 기본값 1
    handles.Show_line = 1;
else
    handles.Show_line = 2;
end
guidata(hObject,handles);



function Profile_coef_Callback(hObject, eventdata, handles)
% hObject    handle to Profile_coef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Profile_coef as text
%        str2double(get(hObject,'String')) returns contents of Profile_coef as a double
handles.Profile_coef = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Profile_coef_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Profile_coef (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
