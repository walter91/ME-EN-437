function varargout = Four_Bar(varargin)
% FOUR_BAR M-file 
% written by Brian Jensen and Yanal Issac
% 11 Jan. 2010
%       FOUR_BAR, by itself, creates a new figure window with the four-link
%       mechanism simulator in it. If the mechanism simulator is open, it
%       simply makes the window active and resets it.
%      
%       FOUR_BAR(r) calls the mechanism simulator, with the mechanism
%       dimensions given in vector r. r must be a 6-element real vector or 
%       a 4-element real vector or a 4-element complex vector. It should be 
%       the first arguement to the function.
%       If r is real, mechanism dimensions should be specified according to
%       the following list:
%           r(1) = length of ground link
%           r(2) = length of input link
%           r(3) = length of coupler link
%           r(4) = length of output link
%           r(5) = distance along coupler link to the coupler point
%           r(6) = distance perpendicular to coupler link to the coupler 
%               point
%       If r(5) and r(6) are not specified they are set to a default value 
%       of 1.
%       If r is complex, the four elments are W, Z, U, and S (in that
%       order), where:
%           W is the complex number representing the vector for link 2
%           Z is the complex number representing the vector pointing from
%               the moving pivot on link 2 to the coupler point.
%           U is the complex number representing the vector for link 4
%           S is the complex number representing the vector pointing from
%               thet moving pivot on link 4 to the coupler point.
%
%       If the simulator is to be opened then play has to be passed in as a
%       string arguement. If it is not passed in then the simulator will  
%       not open. An example is shown below.
%       angles = FOUR_BAR(r,'thetas','play')  ---  This will simulate the 
%           mechanism and return specified properties
%       angles = FOUR_BAR(r,'thetas')         ---  This will return 
%           specified properties but wont run the simulator
%
%       Other Mechanism properties can also be set. The order in which they
%       are set is not important. An example is shown below.
%       FOUR_BAR(r,'circuit','open','theta1',20)
%       
%       The following is a list of mechanism properties that can be set:
%       -------------------------------------------------------------------
%       Arguement |                     Description
%       -------------------------------------------------------------------
%       circuit   | Possible values are 'open' or 'crossed' for the string 
%                 | variable circuit
%       theta1    | Specifies a ground link angle given in degrees
%       theta2    | Specifies an initial angle given in degrees 
%                 | for the input link.
%       -------------------------------------------------------------------
%       
%       FOUR_BAR(r,pp,'play') also plots several precision points given in 
%       the matrix pp. If pp is a matrix of real numbers then the first 
%       column of pp should give the x-coordinates and the second column 
%       the y-coordinates for the points to be plotted. pp can also be a 
%       column vector or a row vector of complex numbers where the real 
%       part is the x-coordinate and the imaginary part is the y coordinate 
%       of the points to be plotted.
%
%       FOUR_BAR('GET FUNCTION HANDLE','FUNCTION NAME') returns the 
%       function handle of the function specified by 'FUNCTION NAME' if it 
%       exists in FOUR_BAR.
%
%       If mechanism properties are to be returned to the user then the
%       mechanism property to be returned should be passed in to the
%       function as a string arguement. The order of the arguements is not
%       important. An example is shown below.
%       [m_thetas m_IC13] = FOUR_BAR([4 2 5 1 -1 2],'theta1',30,...
%           'thetas','IC13',pp,'play')
%
%       The following is a list of mechanism properties that can be
%       returned to the user:
%       -------------------------------------------------------------------
%       Arguement |                     Description
%       -------------------------------------------------------------------
%       thetas    | Returns all mechanism angles in radians
%       IC13      | Returns the points that specify the instant center
%                 | curve 13
%       IC24      | Returns the points that specify the instant center 
%                 | curve 24
%       MechAdv   | Returns the mechanical advantage of the mechanism
%       TranAng   | Returns the transmition angle in radians
%       condition | Returns the Grashof condition of the mechanism
%       handle    | Returns the handle to the simulator if it exists
%       -------------------------------------------------------------------
%       
%       Note if thetas and TranAng are desired to be returned in degrees 
%       then degrees has to be passed in as a string arguement. An example 
%       is show below.
%       [angles transmition_angles] = FOUR_BAR(r,'thetas',...
%           'transmition_angles','degrees')
%
%       Example:
%       [IC24_points fig_handle] = Four_Bar([2 3 4 5 1 -1],'circuit',...
%           'open','theta1',0,'theta2',45,'play','IC24','handle') 
%       opens the four-bar simulator and resets it with a mechanism with a 
%       ground link of 2, input link of 3, coupler link of four, and output 
%       link of 5. In addition, a coupler point 1 unit along link three and 
%       1 unit below the line connecting the pin joints is created. The 
%       mechanism will be analyzed in the open configuration, with ground 
%       angle of 0 degrees and input angle of 45 degrees. Instant center 
%       24 and the figure handle will be returned to the user.


% Last Modified by Brian Jensen 28 Sept. 2013 

if nargin == 0
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Four_Bar_export_OpeningFcn, ...
                       'gui_OutputFcn',  @Four_Bar_export_OutputFcn, ...
                       'gui_LayoutFcn',  @Four_Bar_export_LayoutFcn, ...
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
 
elseif strcmp(varargin{1},'GET FUNCTION HANDLE')
    % This is to return function handles
    s = ['@' varargin{2}];
    varargout{1} = eval(s);
    return
    
elseif isnumeric(varargin{1})
    % This is to find if play has been passed in if it is the figure is
    % opened
    for i=2:nargin
        if strcmp(varargin{i},'play')
            % Begin initialization code - DO NOT EDIT
            gui_Singleton = 1;
            gui_State = struct('gui_Name',       mfilename, ...
                               'gui_Singleton',  gui_Singleton, ...
                               'gui_OpeningFcn', @Four_Bar_export_OpeningFcn, ...
                               'gui_OutputFcn',  @Four_Bar_export_OutputFcn, ...
                               'gui_LayoutFcn',  @Four_Bar_export_LayoutFcn, ...
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
            return
        end
    end

    % This will be executed if Play has not been passed in
    handles.input = varargin;
    handles = organize_input(handles);
    handles = Analysis(handles);

    % Set up output
    if nargout ~= 0
        varargout = organize_output(handles);
    end
    
elseif ischar(varargin{1})
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @Four_Bar_export_OpeningFcn, ...
                       'gui_OutputFcn',  @Four_Bar_export_OutputFcn, ...
                       'gui_LayoutFcn',  @Four_Bar_export_LayoutFcn, ...
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
end

% --- Executes just before Four_Bar_export is made visible.
function Four_Bar_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% UIWAIT makes Four_Bar_export wait for user response (see UIRESUME)
% uiwait(handles.figure1);

handles.input = varargin;
handles = organize_input(handles);

% Pause the Gui Everytime it is called
set(handles.reverse,'UserData',0);              % Play in Forward Direction (0), Play in Reverse (1)
set(handles.Animate_Button,'UserData',0);
set(handles.Animate_Button,'String','Play');

% --- Display initializations to the screen --- %
set(handles.valid_text,'Visible','Off');
set(handles.r1,'String',num2str(handles.r(1),handles.dp));
set(handles.r2,'String',num2str(handles.r(2),handles.dp));
set(handles.r3,'String',num2str(handles.r(3),handles.dp));
set(handles.r4,'String',num2str(handles.r(4),handles.dp));
set(handles.a3,'String',num2str(handles.r(5),handles.dp));
set(handles.b3,'String',num2str(handles.r(6),handles.dp));
set(handles.Theta1,'String',num2str(handles.theta1,handles.dp));
set(handles.Slider_Input,'Value',0);
if strcmp(handles.circuit,'open')
    set(handles.Open_Button,'Value',1)
else
    set(handles.Crossed_Button,'Value',1)
end

handles = Analysis(handles);

% Choose default command line output for Four_Bar_export
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Four_Bar_export_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if nargout ~= 0
    varargout = organize_output(handles);
end

function r1_Callback(hObject, eventdata, handles)
% hObject    handle to r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r1 as text
%        str2double(get(hObject,'String')) returns contents of r1 as a double
handles.r(1) = str2double(get(hObject,'String'));
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function r1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function r2_Callback(hObject, eventdata, handles)
% hObject    handle to r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r2 as text
%        str2double(get(hObject,'String')) returns contents of r2 as a double
handles.r(2) = str2double(get(hObject,'String'));
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function r2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function r3_Callback(hObject, eventdata, handles)
% hObject    handle to r3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r3 as text
%        str2double(get(hObject,'String')) returns contents of r3 as a double
handles.r(3) = str2double(get(hObject,'String'));
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function r3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function r4_Callback(hObject, eventdata, handles)
% hObject    handle to r4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r4 as text
%        str2double(get(hObject,'String')) returns contents of r4 as a double
handles.r(4) = str2double(get(hObject,'String'));
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function r4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Theta1_Callback(hObject, eventdata, handles)
% hObject    handle to Theta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Theta1 as text
%        str2double(get(hObject,'String')) returns contents of Theta1 as a double
handles.theta1 = str2double(get(hObject,'String'));
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Theta1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Theta1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function a3_Callback(hObject, eventdata, handles)
% hObject    handle to a3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a3 as text
%        str2double(get(hObject,'String')) returns contents of a3 as a double
handles.r(5) = str2double(get(hObject,'String'));
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function a3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function b3_Callback(hObject, eventdata, handles)
% hObject    handle to b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of b3 as text
%        str2double(get(hObject,'String')) returns contents of b3 as a double
handles.r(6) = str2double(get(hObject,'String'));
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function b3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to b3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Animate_Button.
function Animate_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Animate_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'UserData')==0
    low = 0.02;
    high = 0.4;
    C = 0.11;
    A = (high-low)*(C+C^2);
    B = low+C*(low-high);
    set(hObject,'String','Pause');
    set(hObject,'UserData',1);
    set(handles.valid_text,'Visible','Off');
    if handles.pointr2==0
        return
    end
    
    while get(hObject,'UserData')==1
        svalue = get(handles.Slider_Input,'Value');
        index = round(svalue*(length(handles.coupler)-1))+1;
        frmcnt = index;
        if get(handles.reverse,'UserData')==0
            % Play in Forward Direction
            for frmcnt = index:length(handles.coupler)
                if get(hObject,'UserData')==0
                    return
                end
                if get(handles.reverse,'UserData')==1
                    break
                end
                plotmech(handles,frmcnt);
                set(handles.Theta2_Text,'String',num2str(handles.thetasd(frmcnt,2),handles.dp));
                set(handles.Theta3_Text,'String',num2str(handles.thetasd(frmcnt,3),handles.dp));
                set(handles.Theta4_Text,'String',num2str(handles.thetasd(frmcnt,4),handles.dp));
                set(handles.Px_Text,'String',num2str(real(handles.coupler(frmcnt)),handles.dp));
                set(handles.Py_Text,'String',num2str(imag(handles.coupler(frmcnt)),handles.dp));
                set(handles.Slider_Input,'Value',(frmcnt-1)/(length(handles.coupler)-1));
                delay = A/(get(handles.Tempo,'Value')+C)+B;
                pause(delay)
            end
            while get(handles.reverse,'UserData')==0
                for frmcnt = 2:length(handles.coupler)
                    if get(hObject,'UserData')==0
                        return
                    end
                    if get(handles.reverse,'UserData')==1
                        break
                    end
                    plotmech(handles,frmcnt);
                    set(handles.Theta2_Text,'String',num2str(handles.thetasd(frmcnt,2),handles.dp));
                    set(handles.Theta3_Text,'String',num2str(handles.thetasd(frmcnt,3),handles.dp));
                    set(handles.Theta4_Text,'String',num2str(handles.thetasd(frmcnt,4),handles.dp));
                    set(handles.Px_Text,'String',num2str(real(handles.coupler(frmcnt)),handles.dp));
                    set(handles.Py_Text,'String',num2str(imag(handles.coupler(frmcnt)),handles.dp));
                    set(handles.Slider_Input,'Value',(frmcnt-1)/(length(handles.coupler)-1));
                    delay = A/(get(handles.Tempo,'Value')+C)+B;
                    pause(delay)
                end
            end
        else
            % Play in Backward Direction
            while frmcnt>0
                if get(hObject,'UserData')==0
                    return
                end
                if get(handles.reverse,'UserData')==0
                    break
                end
                plotmech(handles,frmcnt);
                set(handles.Theta2_Text,'String',num2str(handles.thetasd(frmcnt,2),handles.dp));
                set(handles.Theta3_Text,'String',num2str(handles.thetasd(frmcnt,3),handles.dp));
                set(handles.Theta4_Text,'String',num2str(handles.thetasd(frmcnt,4),handles.dp));
                set(handles.Px_Text,'String',num2str(real(handles.coupler(frmcnt)),handles.dp));
                set(handles.Py_Text,'String',num2str(imag(handles.coupler(frmcnt)),handles.dp));
                set(handles.Slider_Input,'Value',(frmcnt-1)/(length(handles.coupler)-1))
                delay = A/(get(handles.Tempo,'Value')+C)+B;
                pause(delay)
                frmcnt = frmcnt - 1;
            end
            while get(handles.reverse,'UserData')==1
                frmcnt = length(handles.coupler)-1;
                while frmcnt>0
                    if get(hObject,'UserData')==0
                        return
                    end
                    if get(handles.reverse,'UserData')==0
                        break
                    end
                    plotmech(handles,frmcnt);
                    set(handles.Theta2_Text,'String',num2str(handles.thetasd(frmcnt,2),handles.dp));
                    set(handles.Theta3_Text,'String',num2str(handles.thetasd(frmcnt,3),handles.dp));
                    set(handles.Theta4_Text,'String',num2str(handles.thetasd(frmcnt,4),handles.dp));
                    set(handles.Px_Text,'String',num2str(real(handles.coupler(frmcnt)),handles.dp));
                    set(handles.Py_Text,'String',num2str(imag(handles.coupler(frmcnt)),handles.dp));
                    set(handles.Slider_Input,'Value',(frmcnt-1)/(length(handles.coupler)-1));
                    delay = A/(get(handles.Tempo,'Value')+C)+B;
                    pause(delay)
                    frmcnt = frmcnt - 1;
                end
            end
        end
    end   
else
    set(hObject,'String','Play');
    set(hObject,'UserData',0);
    svalue = get(handles.Slider_Input,'Value');
    index = round(svalue*(length(handles.coupler)-1))+1;
    set(handles.Theta2_Text,'String',num2str(handles.thetasd(index,2),handles.dp));
    set(handles.Theta3_Text,'String',num2str(handles.thetasd(index,3),handles.dp));
    set(handles.Theta4_Text,'String',num2str(handles.thetasd(index,4),handles.dp));
    set(handles.Px_Text,'String',num2str(real(handles.coupler(index)),handles.dp));
    set(handles.Py_Text,'String',num2str(imag(handles.coupler(index)),handles.dp));
end
guidata(hObject, handles);

% --- Executes when selected object is changed in Circuit_Panel.
function Circuit_Panel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Circuit_Panel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
set(handles.Animate_Button,'UserData',0);
set(handles.Animate_Button,'String','Play');
if hObject==handles.Open_Button
    handles.circuit = 'open';
else
    handles.circuit = 'crossed';
end
handles = Analysis(handles);
guidata(hObject, handles);

% --- Executes on slider movement.
function Slider_Input_Callback(hObject, eventdata, handles)
% hObject    handle to Slider_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
set(handles.valid_text,'Visible','Off');
set(handles.Animate_Button,'UserData',0);                   %Tells animation to stop
set(handles.Animate_Button,'String','Play');
svalue = get(hObject,'Value');
if svalue==0
    set(hObject,'Value',1);
    index = length(handles.coupler);
elseif svalue==1
    set(hObject,'Value',0);
    index = 1;
else
    index = round(svalue*(length(handles.coupler)-1))+1;
end
plotmech(handles,index);
set(handles.Theta2_Text,'String',num2str(handles.thetasd(index,2),handles.dp));
set(handles.Theta3_Text,'String',num2str(handles.thetasd(index,3),handles.dp));
set(handles.Theta4_Text,'String',num2str(handles.thetasd(index,4),handles.dp));
set(handles.Px_Text,'String',num2str(real(handles.coupler(index)),handles.dp));
set(handles.Py_Text,'String',num2str(imag(handles.coupler(index)),handles.dp));
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Slider_Input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slider_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function Tempo_Callback(hObject, eventdata, handles)
% hObject    handle to Tempo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Tempo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tempo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function Theta2_Text_Callback(hObject, eventdata, handles)
% hObject    handle to Theta2_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Theta2_Text as text
%        str2double(get(hObject,'String')) returns contents of Theta2_Text as a double
set(handles.valid_text,'Visible','Off');
set(handles.Animate_Button,'UserData',0);       %tells the animation to stop
set(handles.Animate_Button,'String','Play');
theta2 = str2double(get(hObject,'String'))*pi/180;
theta2 = atan2(sin(theta2),cos(theta2))*180/pi;
if theta2 < 0
    theta2 = theta2 + 360;
end
guidata(hObject, handles);
theta2calc(handles,theta2);

% --- Executes during object creation, after setting all properties.
function Theta2_Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Theta2_Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in IC_13_Button.
function IC_13_Button_Callback(hObject, eventdata, handles)
% hObject    handle to IC_13_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

V = findscaling(handles);
set(handles.axes1,'UserData',V);

if handles.pointr2==0        
    return
end
svalue = get(handles.Slider_Input,'Value');
index = round(svalue*(length(handles.coupler)-1))+1;
plotmech(handles,index)

% --- Executes on button press in IC_24_Button.
function IC_24_Button_Callback(hObject, eventdata, handles)
% hObject    handle to IC_24_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

V = findscaling(handles);
set(handles.axes1,'UserData',V);

if handles.pointr2==0
    return
end
svalue = get(handles.Slider_Input,'Value');
index = round(svalue*(length(handles.coupler)-1))+1;
plotmech(handles,index)

% --- Executes on button press in reverse.
function reverse_Callback(hObject, eventdata, handles)
% hObject    handle to reverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of reverse

if get(hObject,'UserData')==0
	set(hObject,'UserData',1);              %Play Backward
elseif get(hObject,'UserData')==1
    set(hObject,'UserData',0);              %Play Forward
end
guidata(hObject, handles);

function handles = organize_input(handles)

% ---- Set constants ----
handles.dp = '%5.2f';                   % This is for precision to print to screen
handles.offset = 0.02;                  % Offset away from mechanism to control Screen Size
input = handles.input;
% This is the Default resolution set to Medium
handles.nopts = 100;                    % Number of points from one toggle position to the other
handles.dtheta = pi/90;                 % Delta Theta2

% ---- Default Values ----
handles.r = [5 2 4 5 1 1];
handles.theta1 = 0;
handles.omega2 = 5;
handles.alpha2 = 0;
handles.circuit = 'open';

% ---- Read in Passed Data ----
n = length(input);
if n>0
    if isreal(input{1})
        if length(input{1})==6
            handles.r = input{1};
        elseif length(input{1})==4
            handles.r = input{1};
            % Default value if a3 and b3 not passed
            handles.r(5) = 1;
            handles.r(6) = 1;
        end
    else
        W = input{1}(1);
        Z = input{1}(2);
        U = input{1}(3);
        S = input{1}(4);
        V = Z-S;
        G = W+V-U;
        
        
        handles.r(1) = abs(G);
        handles.r(2) = abs(W);
        handles.r(3) = abs(V);
        handles.r(4) = abs(U);
        handles.r(5) = abs(Z)*cos(angle(Z)-angle(V));
        handles.r(6) = abs(Z)*sin(angle(Z)-angle(V));
        handles.theta1 = angle(G)*180/pi;
        handles.theta2 = angle(W)*180/pi;
        if handles.theta2 < 0
            handles.theta2 = handles.theta2 + 360;
        end
        r7 = W - G;
        mupsi = angle(U)-angle(r7);
        mupsi = atan2(sin(mupsi),cos(mupsi));
        if mupsi>0
            handles.circuit = 'crossed';
        else
            handles.circuit = 'open';
        end
    end
    for i=2:n
        if strcmp(input{i},'theta1')
            handles.theta1 = input{i+1};
        elseif strcmp(input{i},'theta2')
            handles.theta2 = input{i+1};
            handles.theta2 = atan2(sind(handles.theta2),cosd(handles.theta2))*180/pi;
            if handles.theta2 < 0
                handles.theta2 = handles.theta2 + 360;
            end
        elseif strcmp(input{i},'omega2')
            handles.omega2 = input{i+1};
        elseif strcmp(input{i},'alpha2')
            handles.alpha2 = input{i+1};
        elseif strcmp(input{i},'circuit')
            handles.circuit = input{i+1};
        elseif strcmp(input{i},'High Resolution')
            handles.nopts = 200;
            handles.dtheta = pi/180;
        elseif strcmp(input{i},'Very High Resolution');
            handles.nopts = 400;
            handles.dtheta = pi/360;
        elseif isnumeric(input{i})
            n = size(input{i});
            if isreal(input{i}) && n(2)==2
                handles.pp = input{i}(:,1) + input{i}(:,2)*j;
            elseif isreal(input{i})==0
                handles.pp = input{i};
            elseif isreal(input{i})==1 && length(input{i})==1 && strcmp(input{i-1},'theta1')==0 && strcmp(input{i-1},'theta2')==0
                handles.pp = input{i};
            end
        end
    end
end
function handles = Analysis(handles)
r = handles.r;
r1 = r(1);
r2 = r(2);
r3 = r(3);
r4 = r(4);
a3 = r(5);
b3 = r(6);
theta1 = handles.theta1*pi/180;
circuit = handles.circuit;
total = sum(r(1:4));
short = min(r(1:4));
long = max(r(1:4));
nopts = handles.nopts;
dtheta = handles.dtheta;

if strcmp(circuit,'crossed')
    mu = 1;
elseif strcmp(circuit,'open')
    mu = -1;
end

%Determine the Grashof Condition
if long+short < total-long-short
    condition = 'Grashof Mechanism';
    %Check for double-rocker or rocker-crank
    if (short==r(3)) || (short==r(4))
        lim1 = acos((r2^2+r1^2-r3^2-r4^2)/(2*r2*r1) + r3*r4/(r1*r2))+0.00001;
        lim2 = acos((r2^2+r1^2-r3^2-r4^2)/(2*r2*r1) - r3*r4/(r1*r2))-0.00001;
        step = (lim2-lim1)/nopts;
        if mu==-1
            theta21 = lim1:step:lim2;
            theta22 = lim2:-step:lim1;
        else
            theta21 = -lim1:-step:-lim2;
            theta22 = -lim2:step:-lim1;
        end
        [theta31 theta41] = fourbaralgebra(r,theta21,mu);
        [theta32 theta42] = fourbaralgebra(r,theta22,-mu);
        theta2 = [theta21 theta22 theta21(1)];
        theta3 = [theta31 theta32 theta31(1)];
        theta4 = [theta41 theta42 theta41(1)];
    else
        %Crank-Rocker or Double-Crank
        theta2 = 0:dtheta:2*pi;
        [theta3 theta4] = fourbaralgebra(r,theta2,mu);
    end

elseif long+short == total-long-short
    condition = 'Change-Point Mechanism';
    if ((short==r3) || (short==r4)) && (short~=r2)
        lim1 = acos((r2^2+r1^2-r3^2-r4^2)/(2*r2*r1) + r3*r4/(r1*r2))+0.00000001;
        lim2 = acos((r2^2+r1^2-r3^2-r4^2)/(2*r2*r1) - r3*r4/(r1*r2))-0.00000001;
        step = (lim2-lim1)/nopts;
        if abs(lim1)<0.000001
            theta21 = lim1:step:lim2;
            theta22 = lim2:-step:lim1;
            theta23 = lim1-0.00000001:-step:-lim2;
            theta24 = -lim2:step:lim1;
        else
            theta21 = lim1:step:lim2;
            theta22 = -lim2:step:-lim1;
            theta23 = -lim1:-step:-lim2;
            theta24 = lim2:-step:lim1;
        end
        [theta31, theta41] = fourbaralgebra(r,theta21,mu);
        [theta32, theta42] = fourbaralgebra(r,theta22,-mu);
        [theta33, theta43] = fourbaralgebra(r,theta23,mu);
        [theta34, theta44] = fourbaralgebra(r,theta24,-mu);
        theta2 = [theta21 theta22 theta23 theta24];
        theta3 = [theta31 theta32 theta33 theta34];
        theta4 = [theta41 theta42 theta43 theta44];
    else
        theta30 = fourbaralgebra(r,-pi,mu);
        if abs(theta30)<0.000001 && r2~=r1
            theta21 = -pi:dtheta:pi;
            theta21(find(theta21==0)) = -0.00000001;
            [theta31, theta41] = fourbaralgebra(r,theta21,mu);
            [theta32, theta42] = fourbaralgebra(r,theta21,-mu);
            theta2 = [theta21 theta21];
            theta3 = [theta31 theta32];
            theta4 = [theta41 theta42];
         else
            theta21 = -pi:dtheta:-0.00000001;
            [theta31, theta41] = fourbaralgebra(r,theta21,mu);
            theta22 = dtheta:dtheta:2*pi;
            [theta32, theta42] = fourbaralgebra(r,theta22,-mu);
            theta23 = dtheta:dtheta:pi;
            [theta33, theta43] = fourbaralgebra(r,theta23,mu);
            theta2 = [theta21 theta22 theta23];
            theta3 = [theta31 theta32 theta33];
            theta4 = [theta41 theta42 theta43];
        end
    end
elseif long >= total-long
        condition = 'Mechanism Cannot Be Assembled';
        set(handles.Animate_Button,'UserData',0);
        set(handles.Animate_Button,'String','Play');
        set(handles.title,'String',condition);
        handles.coupler = 0;
        handles.pointr1 = 0;
        handles.pointr2 = 0;
        handles.pointr4 = 0;
        handles.IC13 = 0;
        handles.IC24 = 0;
        cla;
        return
else
    condition = 'Non-Grashof Mechanism';
    lim = acos((r2^2+r1^2-r3^2-r4^2)/(2*r2*r1) + r3*r4/(r1*r2));
    if imag(lim)~=0
        lim = acos((r2^2+r1^2-r3^2-r4^2)/(2*r2*r1) - r3*r4/(r1*r2));
    end
    if abs(r2-r1)>abs(r3-r4)
        theta21 = -lim+0.00000001:(2*lim)/nopts:lim-0.00000001;
        theta22 = lim-0.00000001:-(2*lim)/nopts:-lim+0.00000001;
    else
        theta21 = -lim-0.00000001:-2*(pi-lim)/nopts:lim+0.00000001-2*pi;
        theta22 = lim+0.00000001:2*(pi-lim)/nopts:-lim-0.00000001+2*pi;
    end
    [theta31 theta41] = fourbaralgebra(r,theta21,mu);
    [theta32 theta42] = fourbaralgebra(r,theta22,-mu);
    theta2 = [theta21 theta22 theta21(1)];
    theta3 = [theta31 theta32 theta31(1)];
    theta4 = [theta41 theta42 theta41(1)];
end

% Rotate Mechanism by Theta1 and Put in standard domain
theta1 = atan2(sin(theta1),cos(theta1));
theta2 = atan2(sin(theta2),cos(theta2));
theta3 = atan2(sin(theta3),cos(theta3));
theta4 = atan2(sin(theta4),cos(theta4));
theta2 = theta2 + theta1;
theta3 = theta3 + theta1;
theta4 = theta4 + theta1;

% Calculate Instant Centers
% Note that this function uses rotated values for all thetas
[handles.IC13 handles.IC24] = instantcenters(r,theta1,theta2,theta3,theta4);
handles.IC13xn = handles.IC13;
handles.IC24xn = handles.IC24;

% Create Matrix Thetas
theta1 = theta1*ones(size(theta2));
theta1 = atan2(sin(theta1),cos(theta1));
theta2 = atan2(sin(theta2),cos(theta2));
theta3 = atan2(sin(theta3),cos(theta3));
theta4 = atan2(sin(theta4),cos(theta4));
handles.thetas = [theta1;theta2;theta3;theta4]';    % All angles in Radians
[I_rows I_cols] = find(handles.thetas < 0);
for i=1:length(I_rows)
    handles.thetas(I_rows(i),I_cols(i)) = handles.thetas(I_rows(i),I_cols(i)) + 2*pi;
end
handles.thetasd = handles.thetas * 180/pi;          % All angles in Degrees
handles.thetasdxn = handles.thetasd;
handles.condition = condition;

% Calculate Moving Points and Coupler Path Generated
ab = sqrt(a3^2+b3^2);
delta = theta3 + atan2(b3,a3);
handles.pointr1 = r1*exp(theta1*j);
handles.pointr2 = r2*exp(theta2*j);
handles.pointr4 = handles.pointr1 + r4*exp(theta4*j);
handles.coupler = handles.pointr2 + ab*exp(delta*j);
handles.couplerxn = handles.coupler;

% --- Further Mechanism Analysis --- %
warning('off','MATLAB:divideByZero');

% % if isfield(handles,'theta2');
% %     [theta3ini theta4ini] = fourbaralgebra(r,handles.theta2,mu);
% %     thetadiff = abs(handles.theta2 - handles.thetas(:,2)) + abs(theta4ini - handles.thetas(:,4));
% %     index = find(thetadiff==min(thetadiff));
% %     set(handles.Slider_Input,'Value',(index-1)/(length(handles.coupler)-1));
% %     theta2ini = handles.theta2;
% % else
% %     index = 1;
% %     theta2ini = handles.thetas(1,2);
% %     theta3ini = handles.thetas(1,3);
% %     theta4ini = handles.thetas(1,4);
% % end    
% % handles.betas(1) = 0;
% % handles.gamas(1) = 0;
% % k = 1;
% % for i = index+1:length(handles.thetas(:,2))
% %     k = k + 1;
% %     handles.betas(k) = handles.thetas(i,2) - theta2ini;
% %     handles.gamas(k) = handles.thetas(i,4) - theta4ini;
% % end
% % for i = 1:index-1
% %     k = k + 1;
% %     handles.betas(k) = handles.thetas(i,2) - theta2ini;
% %     handles.gamas(k) = handles.thetas(i,4) - theta4ini;
% % end
% % handles.betas = atan2(sin(handles.betas),cos(handles.betas));
% % handles.gamas = atan2(sin(handles.gamas),cos(handles.gamas));
% % for i = 1:length(handles.thetas(:,2))
% % 	if handles.betas(i) < 0
% %         handles.betas = handles.betas + 2*pi;
% %     end
% %     if handles.gamas(i) < 0
% %         handles.gamas = handles.gamas + 2*pi;
% %     end
% % end
% % handles.betasxn = handles.betas;
% % handles.gamasxn = handles.gamas;

% % % if handles.alpha2 == 0;
% % %     omega2 = handles.omega2*ones(length(theta2));
% % % end
% % % 
% % % omega1 = zeros(length(theta1));
% % % omega3 = -r2*omega2.*sin(theta2-theta4)./(r3*sin(theta3-theta4));
% % % omega4 = r2*omega2.*sin(theta2-theta3)./(r4*sin(theta4-theta3));
% % % handles.omegas = [omega1;omega2;omega3;omega4]';
% % % 
% % % alpha1 = zeros(size(theta1));
% % % alpha2 = handles.alpha2*ones(length(theta2));
% % % alpha3 = (r2*omega2.^2.*cos(theta2-theta4) + r2*alpha2.*sin(theta2-theta4) - r4*omega4.^2 - r3*omega3.^2.*cos(theta3-theta4))./(r4*sind(theta3-theta4));
% % % alpha4 = (r2*omega2.^2.*cos(theta2-theta3) + r2*alpha2.*sin(theta2-theta3) - r3*omega3.^2 - r4*omega4.^2.*cos(theta4-theta3))./(r4*sind(theta4-theta3));
% % % handles.alphas = [alpha1;alpha2;alpha3;alpha4]';

handles.MA = abs(r4*sin(theta4-theta3)./(r2*sin(theta2-theta3)));          % This assumes rin and rout to be 1 and 1
handles.MAxn = handles.MA;
handles.TransAngle = abs(theta4-theta3);
handles.TransAnglexn = handles.TransAngle;

warning('on','MATLAB:divideByZero');

% This is to exit if the figure does not exist
if isfield(handles,'figure1')==0
    return
end

% Update screen stuff
set(handles.title,'String',condition);
set(handles.valid_text,'Visible','Off');

% Determine Window Scaling
V = findscaling(handles);
set(handles.axes1,'UserData',V);

% Print the Mechanism to the Screen
if isfield(handles,'theta2')
    % Plot initial position defined by user
    theta2calc(handles,handles.theta2)
else
    % Plot Default initial position
    plotmech(handles,1);
    set(handles.Animate_Button,'UserData',0);
    set(handles.Animate_Button,'String','Play');
    set(handles.Slider_Input,'Value',0);
    set(handles.Theta2_Text,'String',num2str(handles.thetasd(1,2),handles.dp));
    set(handles.Theta3_Text,'String',num2str(handles.thetasd(1,3),handles.dp));
    set(handles.Theta4_Text,'String',num2str(handles.thetasd(1,4),handles.dp));
    set(handles.Px_Text,'String',num2str(real(handles.coupler(1)),handles.dp));
    set(handles.Py_Text,'String',num2str(imag(handles.coupler(1)),handles.dp));
end
function [IC13 IC24] = instantcenters(r,theta1,theta2,theta3,theta4)
r1 = r(1);
r2 = r(2);
theta2 = theta2 - theta1;
theta3 = theta3 - theta1;
theta4 = theta4 - theta1;


%find instant centers
t290 = find(theta2==pi/2|theta2==-pi/2);
t490 = find(theta4==pi/2|theta4==-pi/2);
warning('off','MATLAB:divideByZero');
%instant center (13)
IC13x = r1*tan(theta4)./(tan(theta4)-tan(theta2));
IC13x(t290) = 0;
IC13x(t490) = r1;
IC13y = IC13x.*tan(theta2);
IC13y(t290) = tan(theta4(t290))*(-r1);


%now, we want to remove points that are at one end of a discontinuity in
%the curve. This will happen when link 2 and link 4 are collinear
theta2t = theta2;
theta2t(find(theta2<0)) = theta2(find(theta2<0)) + pi;
theta4t = theta4;
theta4t(find(theta4<0)) = theta4(find(theta4<0)) + pi;
t42 = theta4t - theta2t;
t42m = t42.*t42([2:end 1]);
t42z = find(t42m<0 & (abs(t42-t42([2:end 1]))<50*pi/180));
IC13x(t42z) = NaN;
IC13y(t42z) = NaN;
IC13x(t42z+1) = NaN;
IC13y(t42z+1) = NaN;
IC13x(find(abs(theta2-theta4)<0.000001)) = NaN;
IC13y(find(abs(theta2-theta4)<0.000001)) = NaN;


%finally, calculate IC (2,4)
IC24x = -r2*sin(theta2)./tan(theta3) + r2*cos(theta2);
warning('on','MATLAB:divideByZero');


IC13 = IC13x*cos(theta1)-IC13y*sin(theta1) + (IC13x*sin(theta1)+IC13y*cos(theta1))*j;
IC24 = IC24x*cos(theta1) + IC24x*sin(theta1)*j;
function [theta3 theta4] = fourbaralgebra(r,theta2,mu)
r1 = r(1);
r2 = r(2);
r3 = r(3);
r4 = r(4);
% step 1
r7x = r2*cos(theta2) - r1;
r7y = r2*sin(theta2);
% step 2
theta7 = atan2(r7y,r7x);
% step 3
r7 = sqrt(r7x.^2 + r7y.^2);
% step 4
nez = find(r7~=0);
psi = zeros(size(r7));
psi(nez) = acos((r4^2 + r7(nez).^2 - r3^2)./(2*r4*r7(nez)));
psi(find(imag(psi)~=0)) = NaN;
psi(find(r7==0)) = NaN;
% step 5
theta4prime = theta7 + mu*psi;
theta4 = atan2(sin(theta4prime),cos(theta4prime));
% step 6
r3x = r1 + r4*cos(theta4) - r2*cos(theta2);
r3y = r4*sin(theta4) - r2*sin(theta2);
theta3 = atan2(r3y,r3x);
function theta2calc(handles,theta2)
r = handles.r;
r1 = r(1);
r2 = r(2);
r4 = r(4);
a3 = r(5);
b3 = r(6);
theta1 = handles.theta1*pi/180;
theta2 = theta2*pi/180;
if strcmp(handles.circuit,'open')
    mu = -1;
else
    mu = 1;
end
[theta3 theta4] = fourbaralgebra(handles.r,theta2-theta1,mu);
if isnan(theta3)
    set(handles.valid_text,'Visible','On');
    set(handles.Theta2_Text,'String',num2str(theta2*180/pi,handles.dp));
    set(handles.Theta3_Text,'String','---');
    set(handles.Theta4_Text,'String','---');
    set(handles.Px_Text,'String','---');
    set(handles.Py_Text,'String','---');
    return
end

% Rotate Mechanism
theta3 = theta3 + theta1;
theta4 = theta4 + theta1;

% Calculate New Mechanism Coordinates
ab = sqrt(a3^2+b3^2);
delta = theta3 + atan2(b3,a3);
calc.pointr1 = r1*exp(theta1*j);
calc.pointr2 = r2*exp((theta2)*j);
calc.pointr4 = calc.pointr1 + r4*exp(theta4*j);
calc.couplerxn = calc.pointr2 + ab*exp(delta*j);
calc.coupler = handles.coupler;

% Calculate Instant Centers
[calc.IC13xn calc.IC24xn] = instantcenters(r,theta1,theta2,theta3,theta4);
calc.IC13 = handles.IC13;
calc.IC24 = handles.IC24;

% Calculate Further Mechanism Properties
calc.MA = handles.MA;
calc.MAxn = abs(r4*sin(theta4-theta3)/(r2*sin(theta2-theta3)));            % This assumes rin and rout to be 1 and 1/sz
calc.TransAngle = handles.TransAngle;
calc.TransAnglexn = abs(theta4-theta3);
calc.thetasd = handles.thetasd;
calc.thetasdxn = [theta1 theta2 theta3 theta4]*180/pi;
% % calc.betas = handles.betas;
% % calc.gamas = handles.gamas;
% % if isfield(handles,'theta2')
% %     [theta3ini theta4ini] = fourbaralgebra(handles.r,handles.theta2*pi/180,mu);
% % 	calc.betasxn = theta2 - handles.theta2;
% %     calc.gamasxn = theta4 - theta4ini;
% % else
% %     calc.betasxn = theta2 - handles.thetas(1,2);
% %     calc.gamasxn = theta4 - handles.thetas(1,4);
% % end

% Update the Screen
set(handles.Theta2_Text,'String',num2str(theta2*180/pi,handles.dp));
set(handles.Theta3_Text,'String',num2str(theta3*180/pi,handles.dp));
set(handles.Theta4_Text,'String',num2str(theta4*180/pi,handles.dp));
set(handles.Px_Text,'String',num2str(real(calc.couplerxn),handles.dp));
set(handles.Py_Text,'String',num2str(imag(calc.couplerxn),handles.dp));
if theta4 < 0
    theta4 = theta4+2*pi;
end
% theta2 = atan2(sin(theta2),cos(theta2));
% if theta2 < 0
%     theta2 = theta2 + 2*pi;
% end
thetadiff = abs(theta2 - handles.thetas(:,2))+abs(theta4 - handles.thetas(:,4));
index = find(thetadiff==min(thetadiff));
set(handles.Slider_Input,'Value',(index-1)/(length(handles.coupler)-1));

% Plot the Position at specific theta2
if isfield(handles,'pp')
    calc.pp = handles.pp;
end
calc.IC_13_Button = handles.IC_13_Button;
calc.IC_24_Button = handles.IC_24_Button;
calc.axes1 = handles.axes1;
plotmech(calc,1);
function V = findscaling(handles)
scalef = 2;
minx = min([0 real(handles.coupler) real(handles.pointr2) real(handles.pointr4) real(handles.pointr1)]);
maxx = max([0 real(handles.coupler) real(handles.pointr2) real(handles.pointr4) real(handles.pointr1)]);
miny = min([0 imag(handles.coupler) imag(handles.pointr2) imag(handles.pointr4) imag(handles.pointr1)]);
maxy = max([0 imag(handles.coupler) imag(handles.pointr2) imag(handles.pointr4) imag(handles.pointr1)]);
minxo = minx;
maxxo = maxx;
minyo = miny;
maxyo = maxy;
rangex = maxx - minx;
rangey = maxy - miny;
if get(handles.IC_13_Button,'Value')==get(handles.IC_13_Button,'Max')
    IC13x = real(handles.IC13);
    xl = find(IC13x<minxo-scalef*rangex);
    xu = find(IC13x>maxxo+scalef*rangex);
    IC13x(xl) = minxo-scalef*rangex;
    IC13x(xu) = maxxo+scalef*rangex;
    IC13y = imag(handles.IC13);
    yl = find(IC13y<minyo-scalef*rangey);
    yu = find(IC13y>maxyo+scalef*rangey);
    IC13y(yl) = minyo-scalef*rangey;
    IC13y(yu) = maxyo+scalef*rangey;
    minx = min([minx min(IC13x)]);
    maxx = max([maxx max(IC13x)]);
    miny = min([miny min(IC13y)]);
    maxy = max([maxy max(IC13y)]);
end
if get(handles.IC_24_Button,'Value')==get(handles.IC_24_Button,'Max')
    IC24x = real(handles.IC24);
    xl = find(IC24x<minxo-scalef*rangex);
    xu = find(IC24x>maxxo+scalef*rangex);
    IC24x(xl) = minxo-scalef*rangex;
    IC24x(xu) = maxxo+scalef*rangex;
    IC24y = imag(handles.IC24);
    yl = find(IC24y<minyo-scalef*rangey);
    yu = find(IC24y>maxyo+scalef*rangey);
    IC24y(yl) = minyo-scalef*rangey;
    IC24y(yu) = maxyo+scalef*rangey;
    minx = min([minx min(IC24x)]);
    maxx = max([maxx max(IC24x)]);
    miny = min([miny min(IC24y)]);
    maxy = max([maxy max(IC24y)]);
end
set(handles.axes1,'Units','Pixels');
figsize = get(handles.axes1,'Position');
set(handles.axes1,'Units','characters');
scalex = figsize(3)/(maxx - minx);
scaley = figsize(4)/(maxy - miny);
if scalex>scaley
    yllim = miny - handles.offset*(maxy-miny);
    yulim = maxy + handles.offset*(maxy-miny);
    scaley = figsize(4)/(yulim - yllim);
    xwidth = figsize(3)/scaley;
    xllim = (minx - xwidth + maxx)/2;
    xulim = (maxx + xwidth + minx)/2;
else
    xllim = minx - handles.offset*(maxx-minx);
    xulim = maxx + handles.offset*(maxx-minx);
    scalex = figsize(3)/(xulim - xllim);
    ywidth = figsize(4)/scalex;
    yllim = (miny - ywidth + maxy)/2;
    yulim = (maxy + ywidth + miny)/2;
end
V = [xllim xulim yllim yulim];
function plotmech(handles,index)
V = get(handles.axes1,'UserData');
cla(handles.axes1);
hold(handles.axes1,'on');
% plot coupler path
plot(handles.axes1,real(handles.coupler),imag(handles.coupler),'g');
% plot r2
plot(handles.axes1,[0 real(handles.pointr2(index))],[0 imag(handles.pointr2(index))],'linewidth',2);
% plot r4
plot(handles.axes1,[real(handles.pointr1(index)) real(handles.pointr4(index))],[imag(handles.pointr1(index)) imag(handles.pointr4(index))],'linewidth',2);
% plot r3
plot(handles.axes1,[real(handles.pointr2(index)) real(handles.pointr4(index))],[imag(handles.pointr2(index)) imag(handles.pointr4(index))],'r','linewidth',2);
% plot coupler link
plot(handles.axes1,[real(handles.pointr2(index)) real(handles.couplerxn(index))],[imag(handles.pointr2(index)) imag(handles.couplerxn(index))],'r','linewidth',2);
plot(handles.axes1,[real(handles.pointr4(index)) real(handles.couplerxn(index))],[imag(handles.pointr4(index)) imag(handles.couplerxn(index))],'r','linewidth',2);
% plot precision points
if isfield(handles,'pp')
    plot(handles.axes1,real(handles.pp),imag(handles.pp),'r+');
end
if get(handles.IC_13_Button,'Value')==get(handles.IC_13_Button,'Max')
    plot(handles.axes1,real(handles.IC13),imag(handles.IC13),'r')
    plot(handles.axes1,real(handles.IC13xn(index)),imag(handles.IC13xn(index)),'kx')
end
if get(handles.IC_24_Button,'Value')==get(handles.IC_24_Button,'Max')
    plot(handles.axes1,real(handles.IC24),imag(handles.IC24),'m')
    plot(handles.axes1,real(handles.IC24xn(index)),imag(handles.IC24xn(index)),'ko')
end
axis(handles.axes1,V)

% % % % Plot further figure properties if the figure is open
% % % h = findobj('Type','Figure','Name','Further Mechanism Analysis');
% % % if isempty(h) == 0
% % %     figure2handles = guidata(h);
% % %     cla(figure2handles.axes1);
% % %     hold(figure2handles.axes1,'on');
% % %     x_value = get(figure2handles.x_axis_menu,'Value');
% % %     if x_value ~= 1
% % %         x_axis = figure2handles.x_axis;
% % %         x_axisxn = figure2handles.x_axisxn;
% % %         y_value = get(figure2handles.y_axis_menu1,'Value');
% % %         if y_value ~= 1
% % %             y_axis = figure2handles.y_axis{1};
% % %             y_axisxn = figure2handles.y_axisxn{1};
% % %             plot(figure2handles.axes1,x_axis,y_axis);
% % %             plot(figure2handles.axes1,x_axisxn(index),y_axisxn(index),'kx');
% % %         end
% % %         y_value = get(figure2handles.y_axis_menu2,'Value');
% % %         if y_value ~= 1
% % %             y_axis = figure2handles.y_axis{2};
% % %             y_axisxn = figure2handles.y_axisxn{2};
% % %             plot(figure2handles.axes1,x_axis,y_axis);
% % %             plot(figure2handles.axes1,x_axisxn(index),y_axisxn(index),'kx');
% % %         end
% % %         axis(figure2handles.axes1,'tight');     
% % %     end
% % % end


% Plot further figure properties if the figure is open
h = findobj('Type','Figure','Name','Further Mechanism Analysis');
if isempty(h) == 0
    figure2handles = guidata(h);
    cla(figure2handles.axes1);
    h = findobj(figure2handles.output,'UserData',['x_am' 1]);
    x_value = get(h,'Value');
    if x_value ~= 1
        x_list = get(h,'String');
        x_selection = x_list{x_value};
        for y = 1:2
            h = findobj(figure2handles.output,'UserData',['y_am' y]);
            y_value = get(h,'Value');
            if y_value ~= 1
                y_list = get(h,'String');
                y_selection = y_list{y_value};
                % Prepare x axis selections
                if strcmp(x_selection,'Theta2')
                    x_axis = handles.thetasd(:,2);
                    x_axisxn = handles.thetasdxn(:,2);
                elseif strcmp(x_selection,'Beta')
                    x_axis = handles.betas*180/pi;
                    x_axisxn = handles.betasxn*180/pi;
                end
                % Prepare y axis selections
                if strcmp(y_selection,'Theta3')
                    y_axis = handles.thetasd(:,3);
                    y_axisxn = handles.thetasdxn(:,3);                    
                elseif strcmp(y_selection,'Theta4')
                    y_axis = handles.thetasd(:,4);
                    y_axisxn = handles.thetasdxn(:,4);   
                elseif strcmp(y_selection,'Gama')
                    y_axis = handles.gamas*180/pi;
                    y_axisxn = handles.gamasxn*180/pi;
                    set(figure2handles.Prop_Value,'String',y_axisxn(index)*180/pi);
                elseif strcmp(y_selection,'Omega2')
                    y_axis = handles.omegas(:,2);
                    y_axisxn = handles.omegas(:,2);                    
                elseif strcmp(y_selection,'Omega3')
                    y_axis = handles.omegas(:,3);
                    y_axisxn = handles.omegas(:,3);
                elseif strcmp(y_selection,'Omega4')
                    y_axis = handles.omegas(:,4);
                    y_axisxn = handles.omegas(:,4);                    
                elseif strcmp(y_selection,'Py');
                    y_axis = imag(handles.coupler);
                    y_axisxn = imag(handles.couplerxn);
                elseif strcmp(y_selection,'Px')
                    y_axis = real(handles.coupler);
                    y_axisxn = real(handles.couplerxn);                    
                elseif strcmp(y_selection,'Transmition Angle')
                    y_axis = handles.TransAngle * 180/pi;
                    y_axisxn = handles.TransAnglexn * 180/pi;
                    set(figure2handles.Prop_Value,'String',y_axisxn(index));
                elseif strcmp(y_selection,'Mechanical Advantage')
                    y_axis = handles.MA;
                    y_axisxn = handles.MAxn;
                    set(figure2handles.Prop_Value,'String',y_axisxn(index));
                end
                % Plot
                hold(figure2handles.axes1,'on');
                plot(figure2handles.axes1,x_axis,y_axis);
                plot(figure2handles.axes1,x_axisxn(index),y_axisxn(index),'kx');
                axis(figure2handles.axes1,'tight');
            end
        end
    end
end
function requested_output = organize_output(handles)

input = handles.input;
n = length(input);
k = 0;
for i=2:n

    if strcmp(input{i},'thetas')
        k = k + 1;
        requested_output{k} = handles.thetas;
        for m = 2:n
            if strcmp(input{m},'degrees')
                requested_output{k} = handles.thetasd;
            end
        end
    elseif strcmp(input{i},'handle')
        k = k + 1;
        requested_output{k} = 'Figure Does Not Exist';
        for m = 2:n
            if strcmp(input{m},'play')
                requested_output{k} = handles.output;
            end
        end
    elseif strcmp(input{i},'IC13')
        k = k + 1;
        requested_output{k} = handles.IC13';
    elseif strcmp(input{i},'IC24')
        k = k + 1;
        requested_output{k} = handles.IC24';
    elseif strcmp(input{i},'MechAdv')
        k = k + 1;
        requested_output{k} = handles.MA';
    elseif strcmp(input{i},'TranAng')
        k = k + 1;        
        requested_output{k} = handles.TransAngle';
        for m = 2:n
            if strcmp(input{m},'degrees')
                requested_output{k} = requested_output{k}*180/pi;
            end
        end
    elseif strcmp(input{i},'condition')
        k = k + 1;
        requested_output{k} = handles.condition;
    elseif strcmp(input{i},'coupler')
        k = k + 1;
        requested_output{k} = handles.coupler;
    end
    
end

if n == 0
    requested_output{1} = handles.output;
end


% --- Creates and returns a handle to the GUI figure. 
function h1 = Four_Bar_export_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end
%load Four_Bar_export.mat
mat{1} = 0;
mat{2} = {@manageButtons; [1.924000244140625e+03 +1.634567842140000e+301i]};
mat{3} = {@manageButtons; [1.924000244140625e+03 +1.634567842140000e+301i]};
mat{4}(:,1:3,1) = [NaN                 NaN   0.745082780193790
                 NaN   0.698023956664378   0.568627450980392
   0.752925917448692   0.501945525291829   0.737239642938888
   0.682337682154574   0.639215686274510   0.650965133134966
   0.603906309605554   0.686274509803922   0.678431372549020
   0.603906309605554   0.764705882352941   0.815671015487907
   0.603906309605554   0.866666666666667   0.952941176470588
   0.682337682154574   0.721553368429084   1.000000000000000
                 NaN   0.592156862745098   0.839200427252613
                 NaN                 NaN   0.639215686274510
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{4}(:,4:6,1) = [0.603906309605554   0.603906309605554   0.603906309605554
   0.780392156862745   0.823514152742809   0.854886701762417
   0.643121995880064   0.584313725490196   0.690180819409476
   0.600000000000000   0.596063172350652   0.196078431372549
   0.682337682154574   0.662745098039216   0.196078431372549
   0.196078431372549   0.196078431372549   0.196078431372549
   0.803921568627451   0.803921568627451   0.196078431372549
   1.000000000000000   0.968627450980392   0.196078431372549
   1.000000000000000   1.000000000000000   0.901945525291829
   0.698023956664378   0.827450980392157   0.784298466468299
   0.772549019607843   0.698023956664378   0.678431372549020
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{4}(:,7:9,1) = [0.603906309605554   0.568627450980392   0.764705882352941
   0.925474937056535   0.827450980392157   0.596063172350652
   0.760769054703593   1.000000000000000   0.894102388036927
   0.596063172350652   0.764705882352941   0.941161211566339
   0.650965133134966   0.639215686274510   0.788235294117647
   0.196078431372549   0.196078431372549   0.682337682154574
   0.619592584115358   0.607843137254902   0.737239642938888
   0.709803921568627   0.670588235294118   0.807827878233005
   0.788235294117647   0.792141603723201   0.549004348821241
   0.650965133134966   0.498054474708171   0.623529411764706
   0.690180819409476   0.784298466468299   0.666651407644770
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{4}(:,10:12,1) = [NaN                 NaN                 NaN
   0.749019607843137                 NaN                 NaN
   0.596063172350652                 NaN                 NaN
   0.721553368429084   0.603906309605554                 NaN
   0.811764705882353   0.603906309605554                 NaN
   0.815671015487907   0.603906309605554                 NaN
   0.741176470588235   0.603906309605554                 NaN
   0.564690623331044   0.772549019607843                 NaN
   0.654901960784314                 NaN   1.000000000000000
   0.627435721370260   0.890196078431372   0.937254901960784
   0.615686274509804   0.745082780193790   1.000000000000000
   0.705867093919280   0.517631799801633   0.745082780193790
                 NaN   0.701960784313725   0.513725490196078
                 NaN                 NaN   0.705867093919280
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{4}(:,13:15,1) = [NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
   0.996063172350652                 NaN                 NaN
   0.933318074311437   0.996063172350652                 NaN
   1.000000000000000   0.929411764705882   1.000000000000000
   0.741176470588235   1.000000000000000   0.925474937056535
   0.513725490196078   0.741176470588235   0.988220035095750
   0.701960784313725   0.533318074311437   0.549004348821241
                 NaN   0.694117647058824   0.635278858625162];
mat{4}(:,16,1) = [NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
   0.749019607843137
   0.745082780193790
   0.654901960784314
                 NaN];
mat{4}(:,1:3,2) = [1.000000000000000   1.000000000000000   0.745082780193790
   1.000000000000000   0.701960784313725   0.650965133134966
   0.756862745098039   0.588220035095750   0.929411764705882
   0.721553368429084   0.823514152742809   0.878416113527123
   0.670588235294118   0.901945525291829   0.890196078431372
   0.670588235294118   0.937254901960784   0.937254901960784
   0.670588235294118   0.937254901960784   0.988220035095750
   0.721553368429084   0.737239642938888   1.000000000000000
   1.000000000000000   0.603906309605554   0.847043564507515
   1.000000000000000   1.000000000000000   0.650965133134966
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,4:6,2) = [0.670588235294118   0.670588235294118   0.670588235294118
   0.917631799801633   0.968627450980392   0.992156862745098
   0.858823529411765   0.807827878233005   0.854886701762417
   0.835294117647059   0.831357289997711   0.274509803921569
   0.890196078431372   0.878416113527123   0.274509803921569
   0.274509803921569   0.274509803921569   0.274509803921569
   0.862729839017319   0.862729839017319   0.274509803921569
   1.000000000000000   0.988220035095750   0.274509803921569
   1.000000000000000   1.000000000000000   0.984313725490196
   0.701960784313725   0.854886701762417   0.874509803921569
   0.772549019607843   0.705867093919280   0.686274509803922
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,7:9,2) = [0.670588235294118   0.576470588235294   0.760769054703593
   1.000000000000000   0.898039215686275   0.603906309605554
   0.894102388036927   1.000000000000000   0.976470588235294
   0.815671015487907   0.894102388036927   1.000000000000000
   0.854886701762417   0.831357289997711   0.937254901960784
   0.274509803921569   0.274509803921569   0.878416113527123
   0.815671015487907   0.803921568627451   0.921568627450980
   0.898039215686275   0.882352941176471   0.980376897840848
   0.960784313725490   0.976470588235294   0.662745098039216
   0.780392156862745   0.564690623331044   0.615686274509804
   0.694117647058824   0.784298466468299   0.674494544899672
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,10:12,2) = [1.000000000000000   1.000000000000000   1.000000000000000
   0.741176470588235   1.000000000000000   1.000000000000000
   0.596063172350652   1.000000000000000   1.000000000000000
   0.807827878233005   0.670588235294118   1.000000000000000
   0.933318074311437   0.670588235294118   1.000000000000000
   0.937254901960784   0.670588235294118   1.000000000000000
   0.854886701762417   0.670588235294118   1.000000000000000
   0.627435721370260   0.768612191958496   1.000000000000000
   0.658808270389868   1.000000000000000   0.615686274509804
   0.627435721370260   0.733333333333333   0.713710231174182
   0.572533760585946   0.498054474708171   0.741176470588235
   0.701960784313725   0.439215686274510   0.509788662546731
   1.000000000000000   0.701960784313725   0.439215686274510
   1.000000000000000   1.000000000000000   0.705867093919280
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,13:15,2) = [1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   0.600000000000000   1.000000000000000   1.000000000000000
   0.709803921568627   0.600000000000000   1.000000000000000
   0.741176470588235   0.709803921568627   0.600000000000000
   0.505882352941176   0.741176470588235   0.721553368429084
   0.443152513923857   0.505882352941176   0.733333333333333
   0.705867093919280   0.454901960784314   0.435309376668956
   1.000000000000000   0.694117647058824   0.647058823529412];
mat{4}(:,16,2) = [1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   0.501945525291829
   0.670588235294118
   0.658808270389868
   1.000000000000000];
mat{4}(:,1:3,3) = [1.000000000000000   1.000000000000000   0.796078431372549
   1.000000000000000   0.768612191958496   0.827450980392157
   0.776455329213397   0.749019607843137   0.952941176470588
   0.858823529411765   0.882352941176471   0.909788662546731
   0.854886701762417   0.925474937056535   0.909788662546731
   0.854886701762417   0.945098039215686   0.949004348821241
   0.854886701762417   0.952941176470588   0.992156862745098
   0.858823529411765   0.827450980392157   1.000000000000000
   1.000000000000000   0.717647058823529   0.925474937056535
   1.000000000000000   1.000000000000000   0.776455329213397
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,4:6,3) = [0.854886701762417   0.854886701762417   0.854886701762417
   0.956847486076143   0.976470588235294   0.992156862745098
   0.901945525291829   0.882352941176471   0.909788662546731
   0.882352941176471   0.886259250782025   0.470588235294118
   0.913725490196078   0.905882352941176   0.470588235294118
   0.470588235294118   0.470588235294118   0.470588235294118
   0.917631799801633   0.917631799801633   0.470588235294118
   1.000000000000000   0.992156862745098   0.470588235294118
   1.000000000000000   1.000000000000000   0.980376897840848
   0.870572976272221   0.941161211566339   0.937254901960784
   0.799984740978103   0.796078431372549   0.792141603723201
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,7:9,3) = [0.854886701762417   0.713710231174182   0.792141603723201
   1.000000000000000   0.945098039215686   0.803921568627451
   0.937254901960784   1.000000000000000   0.988220035095750
   0.882352941176471   0.933318074311437   1.000000000000000
   0.901945525291829   0.894102388036927   0.960784313725490
   0.470588235294118   0.470588235294118   0.921568627450980
   0.945098039215686   0.949004348821241   0.941161211566339
   0.921568627450980   0.909788662546731   0.980376897840848
   0.960784313725490   0.976470588235294   0.815671015487907
   0.866666666666667   0.717647058823529   0.682337682154574
   0.764705882352941   0.792141603723201   0.780392156862745
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,10:12,3) = [1.000000000000000   1.000000000000000   1.000000000000000
   0.796078431372549   1.000000000000000   1.000000000000000
   0.819607843137255   1.000000000000000   1.000000000000000
   0.921568627450980   0.854886701762417   1.000000000000000
   0.968627450980392   0.854886701762417   1.000000000000000
   0.968627450980392   0.854886701762417   1.000000000000000
   0.937254901960784   0.854886701762417   1.000000000000000
   0.823514152742809   0.792141603723201   1.000000000000000
   0.776455329213397   1.000000000000000   0.180392156862745
   0.607843137254902   0.490211337453269   0.435309376668956
   0.545098039215686   0.125490196078431   0.325505455100328
   0.784298466468299   0.384313725490196   0.149019607843137
   1.000000000000000   0.796078431372549   0.396093690394446
   1.000000000000000   1.000000000000000   0.803921568627451
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{4}(:,13:15,3) = [1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   0.203921568627451   1.000000000000000   1.000000000000000
   0.450995651178759   0.203921568627451   1.000000000000000
   0.325505455100328   0.458838788433661   0.180392156862745
   0.149019607843137   0.329411764705882   0.458838788433661
   0.407843137254902   0.149019607843137   0.298039215686275
   0.803921568627451   0.403936827649348   0.258823529411765
   1.000000000000000   0.749019607843137   0.654901960784314];
mat{4}(:,16,3) = [1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   0.254917219806210
   0.580376897840848
   0.674494544899672
   1.000000000000000];
mat{5}(:,1:3,1) = [NaN                 NaN   0.745082780193790
                 NaN   0.698023956664378   0.568627450980392
   0.752925917448692   0.501945525291829   0.737239642938888
   0.682337682154574   0.639215686274510   0.650965133134966
   0.603906309605554   0.686274509803922   0.678431372549020
   0.603906309605554   0.764705882352941   0.815671015487907
   0.603906309605554   0.866666666666667   0.952941176470588
   0.682337682154574   0.721553368429084   1.000000000000000
                 NaN   0.592156862745098   0.839200427252613
                 NaN                 NaN   0.639215686274510
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{5}(:,4:6,1) = [0.603906309605554   0.603906309605554   0.603906309605554
   0.780392156862745   0.823514152742809   0.854886701762417
   0.643121995880064   0.584313725490196   0.690180819409476
   0.600000000000000   0.596063172350652   0.643121995880064
   0.682337682154574   0.662745098039216   0.650965133134966
   0.196078431372549   0.196078431372549   0.196078431372549
   0.760769054703593   0.760769054703593   0.760769054703593
   1.000000000000000   0.968627450980392   0.870572976272221
   1.000000000000000   1.000000000000000   0.901945525291829
   0.698023956664378   0.827450980392157   0.784298466468299
   0.772549019607843   0.698023956664378   0.678431372549020
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{5}(:,7:9,1) = [0.603906309605554   0.568627450980392   0.764705882352941
   0.925474937056535   0.827450980392157   0.596063172350652
   0.760769054703593   1.000000000000000   0.894102388036927
   0.596063172350652   0.764705882352941   0.941161211566339
   0.650965133134966   0.639215686274510   0.788235294117647
   0.196078431372549   0.196078431372549   0.682337682154574
   0.760769054703593   0.760769054703593   0.737239642938888
   0.709803921568627   0.670588235294118   0.807827878233005
   0.788235294117647   0.792141603723201   0.549004348821241
   0.650965133134966   0.498054474708171   0.623529411764706
   0.690180819409476   0.784298466468299                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{5}(:,10:12,1) = [NaN                 NaN                 NaN
   0.749019607843137                 NaN                 NaN
   0.596063172350652                 NaN                 NaN
   0.721553368429084   0.603906309605554                 NaN
   0.811764705882353   0.603906309605554                 NaN
   0.815671015487907   0.603906309605554                 NaN
   0.741176470588235   0.603906309605554                 NaN
   0.564690623331044   0.772549019607843                 NaN
   0.654901960784314                 NaN                 NaN
   0.627435721370260   0.890196078431372   0.937254901960784
   0.615686274509804   0.745082780193790   1.000000000000000
   0.705867093919280   0.517631799801633   0.745082780193790
                 NaN   0.701960784313725   0.513725490196078
                 NaN                 NaN   0.705867093919280
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{5}(:,13:15,1) = [NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
   0.996063172350652                 NaN                 NaN
   0.933318074311437   0.996063172350652                 NaN
   1.000000000000000   0.929411764705882   1.000000000000000
   0.741176470588235   1.000000000000000   0.925474937056535
   0.513725490196078   0.741176470588235   0.988220035095750
   0.701960784313725   0.533318074311437   0.549004348821241
                 NaN   0.694117647058824   0.635278858625162];
mat{5}(:,16,1) = [NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
   0.749019607843137
   0.745082780193790
   0.654901960784314
                 NaN];
mat{5}(:,1:3,2) = [1.000000000000000   1.000000000000000   0.745082780193790
   1.000000000000000   0.701960784313725   0.650965133134966
   0.756862745098039   0.588220035095750   0.929411764705882
   0.721553368429084   0.823514152742809   0.878416113527123
   0.670588235294118   0.901945525291829   0.890196078431372
   0.670588235294118   0.937254901960784   0.937254901960784
   0.670588235294118   0.937254901960784   0.988220035095750
   0.721553368429084   0.737239642938888   1.000000000000000
   1.000000000000000   0.603906309605554   0.847043564507515
   1.000000000000000   1.000000000000000   0.650965133134966
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,4:6,2) = [0.670588235294118   0.670588235294118   0.670588235294118
   0.917631799801633   0.968627450980392   0.992156862745098
   0.858823529411765   0.807827878233005   0.854886701762417
   0.835294117647059   0.831357289997711   0.843137254901961
   0.890196078431372   0.878416113527123   0.870572976272221
   0.274509803921569   0.274509803921569   0.274509803921569
   0.819607843137255   0.819607843137255   0.819607843137255
   1.000000000000000   0.988220035095750   0.952941176470588
   1.000000000000000   1.000000000000000   0.984313725490196
   0.701960784313725   0.854886701762417   0.874509803921569
   0.772549019607843   0.705867093919280   0.686274509803922
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,7:9,2) = [0.670588235294118   0.576470588235294   0.760769054703593
   1.000000000000000   0.898039215686275   0.603906309605554
   0.894102388036927   1.000000000000000   0.976470588235294
   0.815671015487907   0.894102388036927   1.000000000000000
   0.854886701762417   0.831357289997711   0.937254901960784
   0.274509803921569   0.274509803921569   0.878416113527123
   0.819607843137255   0.819607843137255   0.921568627450980
   0.898039215686275   0.882352941176471   0.980376897840848
   0.960784313725490   0.976470588235294   0.662745098039216
   0.780392156862745   0.564690623331044   0.615686274509804
   0.694117647058824   0.784298466468299   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,10:12,2) = [1.000000000000000   1.000000000000000   1.000000000000000
   0.741176470588235   1.000000000000000   1.000000000000000
   0.596063172350652   1.000000000000000   1.000000000000000
   0.807827878233005   0.670588235294118   1.000000000000000
   0.933318074311437   0.670588235294118   1.000000000000000
   0.937254901960784   0.670588235294118   1.000000000000000
   0.854886701762417   0.670588235294118   1.000000000000000
   0.627435721370260   0.768612191958496   1.000000000000000
   0.658808270389868   1.000000000000000   1.000000000000000
   0.627435721370260   0.733333333333333   0.713710231174182
   0.572533760585946   0.498054474708171   0.741176470588235
   0.701960784313725   0.439215686274510   0.509788662546731
   1.000000000000000   0.701960784313725   0.439215686274510
   1.000000000000000   1.000000000000000   0.705867093919280
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,13:15,2) = [1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   0.600000000000000   1.000000000000000   1.000000000000000
   0.709803921568627   0.600000000000000   1.000000000000000
   0.741176470588235   0.709803921568627   0.600000000000000
   0.505882352941176   0.741176470588235   0.721553368429084
   0.443152513923857   0.505882352941176   0.733333333333333
   0.705867093919280   0.454901960784314   0.435309376668956
   1.000000000000000   0.694117647058824   0.647058823529412];
mat{5}(:,16,2) = [1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   0.501945525291829
   0.670588235294118
   0.658808270389868
   1.000000000000000];
mat{5}(:,1:3,3) = [1.000000000000000   1.000000000000000   0.796078431372549
   1.000000000000000   0.768612191958496   0.827450980392157
   0.776455329213397   0.749019607843137   0.952941176470588
   0.858823529411765   0.882352941176471   0.909788662546731
   0.854886701762417   0.925474937056535   0.909788662546731
   0.854886701762417   0.945098039215686   0.949004348821241
   0.854886701762417   0.952941176470588   0.992156862745098
   0.858823529411765   0.827450980392157   1.000000000000000
   1.000000000000000   0.717647058823529   0.925474937056535
   1.000000000000000   1.000000000000000   0.776455329213397
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,4:6,3) = [0.854886701762417   0.854886701762417   0.854886701762417
   0.956847486076143   0.976470588235294   0.992156862745098
   0.901945525291829   0.882352941176471   0.909788662546731
   0.882352941176471   0.886259250782025   0.894102388036927
   0.913725490196078   0.905882352941176   0.901945525291829
   0.470588235294118   0.470588235294118   0.470588235294118
   0.890196078431372   0.890196078431372   0.890196078431372
   1.000000000000000   0.992156862745098   0.964690623331044
   1.000000000000000   1.000000000000000   0.980376897840848
   0.870572976272221   0.941161211566339   0.937254901960784
   0.799984740978103   0.796078431372549   0.792141603723201
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,7:9,3) = [0.854886701762417   0.713710231174182   0.792141603723201
   1.000000000000000   0.945098039215686   0.803921568627451
   0.937254901960784   1.000000000000000   0.988220035095750
   0.882352941176471   0.933318074311437   1.000000000000000
   0.901945525291829   0.894102388036927   0.960784313725490
   0.470588235294118   0.470588235294118   0.921568627450980
   0.890196078431372   0.890196078431372   0.941161211566339
   0.921568627450980   0.909788662546731   0.980376897840848
   0.960784313725490   0.976470588235294   0.815671015487907
   0.866666666666667   0.717647058823529   0.682337682154574
   0.764705882352941   0.792141603723201   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,10:12,3) = [1.000000000000000   1.000000000000000   1.000000000000000
   0.796078431372549   1.000000000000000   1.000000000000000
   0.819607843137255   1.000000000000000   1.000000000000000
   0.921568627450980   0.854886701762417   1.000000000000000
   0.968627450980392   0.854886701762417   1.000000000000000
   0.968627450980392   0.854886701762417   1.000000000000000
   0.937254901960784   0.854886701762417   1.000000000000000
   0.823514152742809   0.792141603723201   1.000000000000000
   0.776455329213397   1.000000000000000   1.000000000000000
   0.607843137254902   0.490211337453269   0.435309376668956
   0.545098039215686   0.125490196078431   0.325505455100328
   0.784298466468299   0.384313725490196   0.149019607843137
   1.000000000000000   0.796078431372549   0.396093690394446
   1.000000000000000   1.000000000000000   0.803921568627451
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{5}(:,13:15,3) = [1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   0.203921568627451   1.000000000000000   1.000000000000000
   0.450995651178759   0.203921568627451   1.000000000000000
   0.325505455100328   0.458838788433661   0.180392156862745
   0.149019607843137   0.329411764705882   0.458838788433661
   0.407843137254902   0.149019607843137   0.298039215686275
   0.803921568627451   0.403936827649348   0.258823529411765
   1.000000000000000   0.749019607843137   0.654901960784314];
mat{5}(:,16,3) = [1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   0.254917219806210
   0.580376897840848
   0.674494544899672
   1.000000000000000];

mat{6}(:,1:3,1) = [NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN   0.290196078431373
                 NaN                 NaN   0.290196078431373
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN   0.290196078431373   0.290196078431373
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
                 NaN   0.290196078431373   1.000000000000000
                 NaN                 NaN   0.290196078431373
                 NaN                 NaN   0.290196078431373
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{6}(:,4:6,1) = [NaN                 NaN                 NaN
   0.290196078431373   0.290196078431373                 NaN
   1.000000000000000   1.000000000000000   0.290196078431373
   1.000000000000000   1.000000000000000   0.290196078431373
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   0.290196078431373   1.000000000000000
   0.290196078431373   0.290196078431373   1.000000000000000
   1.000000000000000   0.290196078431373   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   0.991546501869230
                 NaN   0.290196078431373   0.975188830395972
                 NaN                 NaN   0.290196078431373
                 NaN                 NaN   0.290196078431373];
mat{6}(:,7:9,1) = [NaN   0.290196078431373   0.290196078431373
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   0.991546501869230
   0.996063172350652   0.986572060730907   0.975188830395972
   0.981109330891890   0.968841077286946   0.955016403448539
   0.962127107652400   0.947631036850538   0.931914244296941
   0.939909971770809   0.923643854428931   0.906553749904631
   0.915190356298161   0.897734035248341   0.879758907454032];
mat{6}(:,10:12,1) = [NaN                 NaN                 NaN
   0.290196078431373   0.290196078431373   0.290196078431373
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   0.991546501869230
   0.996032654306859   0.986602578774701   0.975188830395972
   0.981109330891890   0.968871595330739   0.955046921492332
   0.962127107652400   0.947631036850538   0.931914244296941
   0.939909971770809   0.923643854428931   0.906553749904631
   0.915220874341955   0.897734035248341   0.879728389410239
   0.888761730373083   0.870634012359808   0.852231631952392
   0.861478599221790   0.843076218814374   0.824887464713512];
mat{6}(:,13:15,1) = [NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
   0.290196078431373                 NaN                 NaN
   0.290196078431373                 NaN   0.290196078431373
   0.290196078431373   0.290196078431373   1.000000000000000
   0.290196078431373   1.000000000000000   1.000000000000000
   0.290196078431373   1.000000000000000   0.991546501869230
   0.996032654306859   0.986602578774701   0.975188830395972
   0.981109330891890   0.968841077286946   0.290196078431373
   0.962127107652400   0.947631036850538   0.290196078431373
   0.939909971770809   0.923643854428931   0.290196078431373
   0.915190356298161   0.290196078431373                 NaN
   0.888761730373083   0.290196078431373                 NaN
   0.290196078431373                 NaN                 NaN
   0.290196078431373                 NaN                 NaN
   0.290196078431373                 NaN                 NaN];
mat{6}(:,16,1) = [NaN
                 NaN
                 NaN
                 NaN
   0.290196078431373
   0.290196078431373
   0.290196078431373
   0.290196078431373
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN];
mat{6}(:,1:3,2) = [0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.407843137254902   0.894102388036927
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902];
mat{6}(:,4:6,2) = [0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.894102388036927   0.894102388036927   0.407843137254902
   0.894102388036927   0.894102388036927   0.407843137254902
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.407843137254902   0.894102388036927
   0.407843137254902   0.407843137254902   0.894102388036927
   0.894102388036927   0.407843137254902   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.882536049439231
   0.407843137254902   0.407843137254902   0.860135805294881
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902];
mat{6}(:,7:9,2) = [0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894071869993133   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.882566567483024
   0.888700694285496   0.875730525673304   0.860135805294881
   0.868223086900130   0.851438162813764   0.832516975661860
   0.842252231631952   0.822384985122454   0.800808728160525
   0.811764705882353   0.789547570000763   0.766079194323644
   0.777920195315480   0.754024567025254   0.729396505683986];
mat{6}(:,10:12,2) = [0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.407843137254902   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.894102388036927
   0.894102388036927   0.894102388036927   0.882566567483024
   0.888700694285496   0.875730525673304   0.860105287251087
   0.868223086900130   0.851468680857557   0.832516975661860
   0.842221713588159   0.822354467078660   0.800839246204318
   0.811764705882353   0.789547570000763   0.766079194323644
   0.777920195315480   0.754024567025254   0.729396505683986
   0.741786831464103   0.716914625772488   0.691676203555352
   0.704371709773404   0.679133287556268   0.654261081864652];
mat{6}(:,13:15,2) = [0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.894102388036927
   0.407843137254902   0.894102388036927   0.894071869993133
   0.407843137254902   0.894102388036927   0.882536049439231
   0.888700694285496   0.875730525673304   0.860105287251087
   0.868223086900130   0.851468680857557   0.407843137254902
   0.842221713588159   0.822354467078660   0.407843137254902
   0.811795223926146   0.789547570000763   0.407843137254902
   0.777950713359274   0.407843137254902   0.407843137254902
   0.741756313420310   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902
   0.407843137254902   0.407843137254902   0.407843137254902];
mat{6}(:,16,2) = [0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902
   0.407843137254902];
mat{6}(:,1:3,3) = [0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.799954222934310   0.799984740978103
   0.709803921568627   0.799984740978103   0.799954222934310
   0.709803921568627   0.709803921568627   0.799984740978103
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627];
mat{6}(:,4:6,3) = [0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.799984740978103   0.799984740978103   0.709803921568627
   0.799984740978103   0.799984740978103   0.709803921568627
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.799954222934310
   0.709803921568627   0.709803921568627   0.799984740978103
   0.709803921568627   0.709803921568627   0.799984740978103
   0.799984740978103   0.709803921568627   0.799984740978103
   0.799984740978103   0.799984740978103   0.799954222934310
   0.799984740978103   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.785061417563134
   0.709803921568627   0.709803921568627   0.756160830090791
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627];
mat{6}(:,7:9,3) = [0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799954222934310   0.799984740978103
   0.709803921568627   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.785091935606928
   0.792996108949416   0.776241702906844   0.756160830090791
   0.766598001068132   0.744960708018616   0.720546272983902
   0.733089188982986   0.707423514152743   0.679652094300755
   0.693781948577096   0.665094987411307   0.634882124055848
   0.650141145952544   0.619256885633631   0.587518120088502];
mat{6}(:,10:12,3) = [0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.799984740978103
   0.799984740978103   0.799984740978103   0.785091935606928
   0.792996108949416   0.776272220950637   0.756160830090791
   0.766598001068132   0.744960708018616   0.720546272983902
   0.733089188982986   0.707423514152743   0.679682612344549
   0.693812466620890   0.665094987411307   0.634882124055848
   0.650141145952544   0.619287403677424   0.587518120088502
   0.603509575036240   0.571404592965591   0.538872358281834
   0.555230029755093   0.522697795071336   0.490638590066377];
mat{6}(:,13:15,3) = [0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.799954222934310
   0.709803921568627   0.799984740978103   0.799984740978103
   0.709803921568627   0.799984740978103   0.785091935606928
   0.792996108949416   0.776272220950637   0.756130312046998
   0.766628519111925   0.744960708018616   0.709803921568627
   0.733089188982986   0.707423514152743   0.709803921568627
   0.693781948577096   0.665094987411307   0.709803921568627
   0.650141145952544   0.709803921568627   0.709803921568627
   0.603479056992447   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627
   0.709803921568627   0.709803921568627   0.709803921568627];
mat{6}(:,16,3) = [0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627
   0.709803921568627];

mat{7}(:,1:3,1) = [NaN                 NaN   0.721553368429084
                 NaN                 NaN   0.647058823529412
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN   0.807827878233005   0.674494544899672
                 NaN   0.643121995880064   0.835294117647059
                 NaN   0.619592584115358   0.882352941176471
                 NaN   0.466681925688563   0.650965133134966
                 NaN   0.694117647058824   0.847043564507515
                 NaN   0.760769054703593   0.980376897840848
                 NaN   0.615686274509804   0.596063172350652
                 NaN                 NaN   0.611749446860456
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN];
mat{7}(:,4:6,1) = [0.909788662546731   0.843137254901961   0.843137254901961
   0.933318074311437   0.933318074311437   0.933318074311437
   0.717647058823529   0.862729839017319   0.862729839017319
   0.607843137254902   0.796078431372549   0.796078431372549
   0.647058823529412   0.721553368429084   0.721553368429084
   0.713710231174182   0.772549019607843   0.780392156862745
   0.788235294117647   0.925474937056535   0.698023956664378
   0.760769054703593   0.666651407644770   0.647058823529412
   0.847043564507515   0.823514152742809   0.788235294117647
   0.850980392156863   0.847043564507515   0.847043564507515
   0.627435721370260   0.607843137254902   0.788235294117647
   0.949004348821241   0.847043564507515   0.584313725490196
   0.933318074311437   0.945098039215686   0.909788662546731
   0.356878004119936   0.647058823529412   0.945098039215686
   0.729396505683986   0.490211337453269   0.352941176470588
                 NaN                 NaN   0.666651407644770];
mat{7}(:,7:9,1) = [0.843137254901961   0.866666666666667   0.721553368429084
   0.933318074311437   0.933318074311437   0.588220035095750
   0.862729839017319   0.862729839017319   0.709803921568627
   0.796078431372549   0.796078431372549   0.768612191958496
   0.721553368429084   0.701960784313725   0.686274509803922
   0.807827878233005   0.835294117647059   0.874509803921569
   0.729396505683986   0.682337682154574   0.713710231174182
   0.811764705882353   0.941161211566339   0.929411764705882
   0.835294117647059   0.807827878233005   0.760769054703593
   0.847043564507515   0.878416113527123   0.811764705882353
   0.670588235294118   0.552941176470588   0.505882352941176
   0.498054474708171   0.592156862745098   0.698023956664378
   0.674494544899672   0.576470588235294   0.376470588235294
   0.698023956664378   0.545098039215686   0.525474937056535
   0.254917219806210   0.235294117647059   0.286289768825818
   0.458838788433661   0.439215686274510   0.549004348821241];
mat{7}(:,10:12,1) = [NaN                 NaN                 NaN
   0.674494544899672                 NaN                 NaN
   0.478431372549020                 NaN                 NaN
   0.356878004119936   0.745082780193790                 NaN
   0.360784313725490   0.619592584115358                 NaN
   0.905882352941176   0.490211337453269   0.654901960784314
   0.741176470588235   0.741176470588235   0.701960784313725
   0.917631799801633   0.850980392156863   0.749019607843137
   0.752925917448692   0.799984740978103   0.831357289997711
   0.745082780193790   0.615686274509804   0.537254901960784
   0.513725490196078   0.623529411764706   0.749019607843137
   0.650965133134966   0.580376897840848   0.556847486076143
   0.431372549019608   0.549004348821241   0.737239642938888
   0.701960784313725   0.898039215686275   0.705867093919280
   0.466681925688563   0.274509803921569   0.282352941176471
   0.482368200198367   0.431372549019608                 NaN];
mat{7}(:,13:15,1) = [NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
                 NaN                 NaN                 NaN
   0.611749446860456                 NaN                 NaN
   0.745082780193790   0.490211337453269                 NaN
   0.799984740978103   0.427466239414054   0.541161211566339
   0.447058823529412   0.333348592355230   0.427466239414054
   0.541161211566339   0.333348592355230   0.407843137254902
   0.537254901960784   0.388250553139544   0.400000000000000
   0.913725490196078   0.694117647058824   0.372564278629740
   0.317662317845426   0.266666666666667   0.400000000000000
   0.380407415884642   0.572533760585946                 NaN
                 NaN                 NaN                 NaN];
mat{7}(:,16,1) = [NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN
                 NaN];
mat{7}(:,1:3,2) = [1.000000000000000   1.000000000000000   0.717647058823529
   1.000000000000000   1.000000000000000   0.650965133134966
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   0.792141603723201   0.666651407644770
   1.000000000000000   0.639215686274510   0.835294117647059
   1.000000000000000   0.619592584115358   0.882352941176471
   1.000000000000000   0.466681925688563   0.650965133134966
   1.000000000000000   0.694117647058824   0.847043564507515
   1.000000000000000   0.756862745098039   0.980376897840848
   1.000000000000000   0.603906309605554   0.596063172350652
   1.000000000000000   1.000000000000000   0.600000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{7}(:,4:6,2) = [0.913725490196078   0.847043564507515   0.847043564507515
   0.968627450980392   0.968627450980392   0.968627450980392
   0.764705882352941   0.929411764705882   0.929411764705882
   0.643121995880064   0.898039215686275   0.898039215686275
   0.666651407644770   0.862729839017319   0.862729839017319
   0.709803921568627   0.831357289997711   0.823514152742809
   0.788235294117647   0.925474937056535   0.698023956664378
   0.760769054703593   0.666651407644770   0.647058823529412
   0.847043564507515   0.823514152742809   0.788235294117647
   0.850980392156863   0.847043564507515   0.847043564507515
   0.627435721370260   0.607843137254902   0.788235294117647
   0.949004348821241   0.847043564507515   0.584313725490196
   0.933318074311437   0.945098039215686   0.909788662546731
   0.352941176470588   0.647058823529412   0.945098039215686
   0.713710231174182   0.482368200198367   0.352941176470588
   1.000000000000000   1.000000000000000   0.654901960784314];
mat{7}(:,7:9,2) = [0.847043564507515   0.866666666666667   0.705867093919280
   0.968627450980392   0.968627450980392   0.603906309605554
   0.929411764705882   0.929411764705882   0.756862745098039
   0.898039215686275   0.898039215686275   0.866666666666667
   0.862729839017319   0.839200427252613   0.831357289997711
   0.843137254901961   0.862729839017319   0.882352941176471
   0.729396505683986   0.682337682154574   0.713710231174182
   0.811764705882353   0.941161211566339   0.929411764705882
   0.835294117647059   0.807827878233005   0.760769054703593
   0.847043564507515   0.878416113527123   0.811764705882353
   0.670588235294118   0.552941176470588   0.505882352941176
   0.498054474708171   0.592156862745098   0.698023956664378
   0.674494544899672   0.576470588235294   0.376470588235294
   0.698023956664378   0.545098039215686   0.525474937056535
   0.254917219806210   0.231387808041505   0.286289768825818
   0.447058823529412   0.431372549019608   0.537254901960784];
mat{7}(:,10:12,2) = [1.000000000000000   1.000000000000000   1.000000000000000
   0.662745098039216   1.000000000000000   1.000000000000000
   0.470588235294118   1.000000000000000   1.000000000000000
   0.352941176470588   0.729396505683986   1.000000000000000
   0.360784313725490   0.607843137254902   1.000000000000000
   0.905882352941176   0.486274509803922   0.647058823529412
   0.741176470588235   0.741176470588235   0.701960784313725
   0.917631799801633   0.850980392156863   0.749019607843137
   0.752925917448692   0.799984740978103   0.831357289997711
   0.745082780193790   0.615686274509804   0.537254901960784
   0.513725490196078   0.623529411764706   0.749019607843137
   0.650965133134966   0.580376897840848   0.556847486076143
   0.431372549019608   0.549004348821241   0.737239642938888
   0.701960784313725   0.898039215686275   0.705867093919280
   0.466681925688563   0.270603494316014   0.274509803921569
   0.474525062943465   0.423529411764706   1.000000000000000];
mat{7}(:,13:15,2) = [1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   0.607843137254902   1.000000000000000   1.000000000000000
   0.745082780193790   0.482368200198367   1.000000000000000
   0.799984740978103   0.427466239414054   0.533318074311437
   0.517631799801633   0.333348592355230   0.419623102159152
   0.666651407644770   0.333348592355230   0.400000000000000
   0.537254901960784   0.388250553139544   0.396093690394446
   0.913725490196078   0.694117647058824   0.364721141374838
   0.313725490196078   0.258823529411765   0.396093690394446
   0.372564278629740   0.560784313725490   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{7}(:,16,2) = [1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000];
mat{7}(:,1:3,3) = [1.000000000000000   1.000000000000000   0.784298466468299
   1.000000000000000   1.000000000000000   0.713710231174182
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   0.760769054703593   0.647058823529412
   1.000000000000000   0.631372549019608   0.835294117647059
   1.000000000000000   0.619592584115358   0.882352941176471
   1.000000000000000   0.466681925688563   0.650965133134966
   1.000000000000000   0.690180819409476   0.847043564507515
   1.000000000000000   0.749019607843137   0.980376897840848
   1.000000000000000   0.584313725490196   0.596063172350652
   1.000000000000000   1.000000000000000   0.576470588235294
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{7}(:,4:6,3) = [0.921568627450980   0.901945525291829   0.901945525291829
   1.000000000000000   1.000000000000000   1.000000000000000
   0.874509803921569   1.000000000000000   1.000000000000000
   0.760769054703593   1.000000000000000   1.000000000000000
   0.741176470588235   1.000000000000000   1.000000000000000
   0.745082780193790   1.000000000000000   1.000000000000000
   0.788235294117647   0.925474937056535   0.698023956664378
   0.760769054703593   0.666651407644770   0.647058823529412
   0.847043564507515   0.823514152742809   0.788235294117647
   0.850980392156863   0.847043564507515   0.847043564507515
   0.627435721370260   0.607843137254902   0.788235294117647
   0.949004348821241   0.847043564507515   0.584313725490196
   0.933318074311437   0.945098039215686   0.909788662546731
   0.345098039215686   0.647058823529412   0.945098039215686
   0.686274509803922   0.466681925688563   0.349034866865034
   1.000000000000000   1.000000000000000   0.627435721370260];
mat{7}(:,7:9,3) = [0.901945525291829   0.905882352941176   0.705867093919280
   1.000000000000000   1.000000000000000   0.658808270389868
   1.000000000000000   1.000000000000000   0.854886701762417
   1.000000000000000   1.000000000000000   0.976470588235294
   1.000000000000000   1.000000000000000   1.000000000000000
   0.984313725490196   0.937254901960784   0.898039215686275
   0.729396505683986   0.682337682154574   0.713710231174182
   0.811764705882353   0.941161211566339   0.929411764705882
   0.835294117647059   0.807827878233005   0.760769054703593
   0.847043564507515   0.878416113527123   0.811764705882353
   0.670588235294118   0.552941176470588   0.505882352941176
   0.498054474708171   0.592156862745098   0.698023956664378
   0.674494544899672   0.576470588235294   0.376470588235294
   0.698023956664378   0.619592584115358   0.650965133134966
   0.250980392156863   0.223544670786603   0.301976043335622
   0.431372549019608   0.415686274509804   0.517631799801633];
mat{7}(:,10:12,3) = [1.000000000000000   1.000000000000000   1.000000000000000
   0.639215686274510   1.000000000000000   1.000000000000000
   0.454901960784314   1.000000000000000   1.000000000000000
   0.388250553139544   0.701960784313725   1.000000000000000
   0.450995651178759   0.588220035095750   1.000000000000000
   0.905882352941176   0.478431372549020   0.627435721370260
   0.741176470588235   0.741176470588235   0.701960784313725
   0.917631799801633   0.850980392156863   0.749019607843137
   0.752925917448692   0.799984740978103   0.831357289997711
   0.745082780193790   0.615686274509804   0.537254901960784
   0.513725490196078   0.623529411764706   0.749019607843137
   0.650965133134966   0.580376897840848   0.556847486076143
   0.431372549019608   0.549004348821241   0.737239642938888
   0.713710231174182   0.898039215686275   0.701960784313725
   0.490211337453269   0.266666666666667   0.266666666666667
   0.454901960784314   0.407843137254902   1.000000000000000];
mat{7}(:,13:15,3) = [1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000
   0.600000000000000   1.000000000000000   1.000000000000000
   0.745082780193790   0.474525062943465   1.000000000000000
   0.799984740978103   0.423529411764706   0.509788662546731
   0.407843137254902   0.329411764705882   0.403936827649348
   0.482368200198367   0.329411764705882   0.384313725490196
   0.537254901960784   0.384313725490196   0.380407415884642
   0.913725490196078   0.694117647058824   0.352941176470588
   0.309819180590524   0.250980392156863   0.380407415884642
   0.356878004119936   0.537254901960784   1.000000000000000
   1.000000000000000   1.000000000000000   1.000000000000000];
mat{7}(:,16,3) = [1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000
   1.000000000000000];

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', [], ...
    'text', 27, ...
    'edit', 12, ...
    'axes', [], ...
    'radiobutton', 8, ...
    'uipanel', 11, ...
    'togglebutton', [], ...
    'pushbutton', 7, ...
    'slider', [], ...
    'uitoolbar', [], ...
    'uitoggletool', 5, ...
    'uipushtool', [], ...
    'checkbox', []), ...
    'override', [], ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', [], ...
    'callbacks', [], ...
    'singleton', [], ...
    'syscolorfig', 0, ...
    'blocking', 0, ...
    'lastSavedFile', '/Users/brianjensen/Documents/me437/matlab/Mechanism_Simulator/Yanal/singlefile/Four_Bar_export.m', ...
    'lastFilename', '/Users/brianjensen/Documents/me437/matlab/Mechanism_Simulator/Yanal/singlefile/Four_Bar.fig');
appdata.lastValidTag = 'figure1';
appdata.Listeners = [];
appdata.SavedVisible = 'on';
%appdata.GUIOnScreen = [];
appdata.FileMenuFcnLastExportedAsType = 6;
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'Units','characters',...
'Color',get(0,'defaultfigureColor'),...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','Four Bar Mechanism Simulator',...
'NumberTitle','off',...
'PaperOrientation','landscape',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',[11 8.5],...
'Position',[0 28 120.166666666667 34.75],...
'Resize','off',...
'HandleVisibility','callback',...
'UserData',[],...
'Tag','figure1',...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel1';

h25 = uipanel(...
'Parent',h1,...
'Units','characters',...
'Title','Mechanism Geometry',...
'TitlePosition','centertop',...
'Tag','uipanel1',...
'UserData',[],...
'Clipping','on',...
'Position',[0.8 9.30769230769231 24.2 22.5384615384615],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel10';

h55 = uipanel(...
'Parent',h1,...
'Units','characters',...
'Title','Position Analysis',...
'TitlePosition','centertop',...
'Tag','uipanel10',...
'Clipping','on',...
'Position',[94.8 16.2307692307692 24.2 15.6153846153846],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text19';

h2 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[91 -0.307692307692308 10 2.23076923076923],...
'String','Slower',...
'Style','text',...
'Tag','text19',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text1';

h3 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[4.40000000000001 27.6153846153847 6.2 2.53846153846154],...
'String','r1',...
'Style','text',...
'Tag','text1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text2';

h4 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[4.40000000000001 24.923076923077 6.2 2.53846153846154],...
'String',{  'r2'; blanks(0) },...
'Style','text',...
'Tag','text2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text3';

h5 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[4.4000000000001 22.2307692307693 6.2 2.53846153846154],...
'String','r3',...
'Style','text',...
'Tag','text3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text4';

h6 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[4.4000000000001 19.5384615384616 6.2 2.53846153846154],...
'String','r4',...
'Style','text',...
'Tag','text4',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'r1';

h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('r1_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[11.0000000000001 27.6153846153847 10 2.53846153846154],...
'String','5.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('r1_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','r1');

appdata = [];
appdata.lastValidTag = 'axes1';
appdata.PlotHoldStyle = mat{1};
appdata.PlotColorIndex = [];
appdata.PlotLineStyleIndex = [];

h8 = axes(...
'Parent',h1,...
'Units','characters',...
'Position',[29 8.6923076923077 61.8 23.1538461538462],...
'CameraPosition',[1.4814033269207 1.39993982712048 17.3205080756888],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[14.56 3.55384615384615 10.64 2.42307692307692],...
'NextPlot','add',...
'XColor',get(0,'defaultaxesXColor'),...
'XLim',[-2.17793721308178 5.14074386692317],...
'XLimMode','manual',...
'YColor',get(0,'defaultaxesYColor'),...
'YLim',[-2.25940071288199 5.05928036712296],...
'YLimMode','manual',...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axes1',...
'UserData',[-2.17793721308178 5.14074386692317 -2.25940071288199 5.05928036712296],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

h9 = get(h8,'title');

set(h9,...
'Parent',h8,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[1.4814033269207 5.17774822633167 1.00010919874411],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h10 = get(h8,'xlabel');

set(h10,...
'Parent',h8,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[1.46167642374009 -2.74643524518448 1.00010919874411],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','cap',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h11 = get(h8,'ylabel');

set(h11,...
'Parent',h8,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-2.54288492192299 1.36045054071758 1.00010919874411],...
'Rotation',90,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h12 = get(h8,'zlabel');

set(h12,...
'Parent',h8,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','right',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-5.62028181809758 5.94120776345449 1.00010919874411],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','middle',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

% h13 = graph2d.lineseries(...
% 'Parent',h8,...
% 'Color',[0 1 0],...
% 'XData',[1 1.02282166929639 1.04470129179473 1.06556133696216 1.08530836367433 1.10383479421136 1.12102135035204 1.13674000873621 1.15085730008245 1.16323776235907 1.17374736175739 1.18225671495232 1.18864397751015 1.1927973014088 1.1946168045046 1.19401603220507 1.19092292355875 1.1852803187276 1.17704606183501 1.16619276289485 1.15270728595444 1.13659002907984 1.11785405679557 1.09652413837999 1.07263573712122 1.04623398711539 1.01737268604977 0.986113325047394 0.952524170266075 0.916679405616348 0.87865834166925 0.838544692483245 0.796425919576257 0.75239264047548 0.706538098067272 0.65895768622343 0.609748526793466 0.559009092935408 0.506838873835876 0.453338076083723 0.39860735726341 0.342747587688223 0.285859636572565 0.228044179327129 0.169401523037162 0.110031447542959 0.0500330598775605 -0.010495339873828 -0.0714563829461831 -0.132753747897773 -0.19429226941514 -0.255978040888227 -0.317718511544493 -0.379422578772618 -0.441000676127716 -0.502364857388576 -0.563428876931926 -0.624108266597128 -0.684320409135821 -0.743984608273538 -0.8030221553531 -0.861356392481882 -0.918912772066049 -0.975618912584043 -1.03140465042866 -1.08620208763152 -1.13994563527569 -1.19257205240114 -1.24402048021415 -1.29423247142497 -1.34315201455854 -1.39072555311033 -1.43690199945349 -1.48163274344378 -1.5248716557156 -1.56657508571352 -1.60670185456069 -1.64521324292457 -1.68207297410263 -1.71724719261346 -1.75070443864005 -1.78241561873194 -1.81235397322716 -1.8404950409037 -1.86681662141074 -1.89129873606051 -1.91392358758127 -1.93467551943915 -1.95354097533088 -1.97050845943017 -1.98556849793805 -1.99871360244247 -2.00993823553564 -2.01923877907111 -2.02661350536755 -2.03206255158553 -2.03558789741909 -2.03719334615861 -2.03688450909702 -2.03466879317108 -2.03055539165433 -2.02455527765118 -2.01668120008285 -2.00694768180719 -1.99537101947656 -1.98196928471001 -1.96676232613949 -1.94977177188259 -1.9310210319967 -1.9105353004801 -1.88834155640319 -1.8644685637763 -1.83894686978919 -1.81180880108834 -1.78308845779197 -1.75282170497753 -1.72104616141059 -1.68780118531846 -1.65312785704338 -1.61706895844032 -1.57966894891138 -1.54097393799237 -1.50103165442749 -1.45989141168411 -1.41760406987229 -1.37422199404118 -1.32979900882856 -1.28439034943855 -1.23805260891721 -1.19084368168526 -1.1428227032716 -1.09404998617078 -1.04458695172103 -0.994496057867092 -0.94384072263368 -0.892685243089418 -0.841094709528682 -0.789134914537798 -0.736872256543096 -0.684373637360432 -0.631706353178819 -0.578937978314418 -0.526136240965798 -0.47336889008731 -0.420703552376431 -0.368207578244764 -0.315947875515051 -0.263990729463017 -0.212401607710863 -0.161244948389303 -0.110583929931362 -0.0604802208629609 -0.0109937080371383 0.037817798047505 0.0858988818586519 0.133196865842075 0.179662177501261 0.22524873908717 0.269914376918503 0.313621245358321 0.35633625793398 0.398031514947569 0.43868471315762 0.478279518747712 0.516805879941766 0.554260250501535 0.590645690318759 0.625971804940868 0.660254482888872 0.693515388968643 0.725781174508169 0.757082372666529 0.78745195960422 0.816923580943858 0.845529467490237 0.873298093592273 0.900251663670772 0.92640354402201 0.951755783850489 0.976296887014102 1],...
% 'YData',[1 1.0932744978421 1.18674209206787 1.28012189075122 1.37313715593889 1.46551983883458 1.5570146862127 1.64738272749467 1.73640400532945 1.82387947430794 1.90963205497022 1.99350688668756 2.07537086822618 2.15511160598062 2.23263590639665 2.30786795224106 2.38074729463321 2.45122677725489 2.51927048907379 2.58485182006277 2.64795167298871 2.70855686492585 2.76665873562846 2.82225196665569 2.87533360516003 2.92590227925058 2.97395758739627 3.01949964195788 3.06252874615191 3.10304518411917 3.14104910492539 3.1765404829607 3.20951913909713 3.23998480893886 3.26793724643938 3.2933763529851 3.3163023237109 3.33671580429649 3.35461805278784 3.37001110209986 3.38289791979775 3.39328256254008 3.40117032321546 3.40656786933343 3.40948337165637 3.40992662239976 3.40790914259488 3.40344427841631 3.39654728643522 3.38723540787882 3.37552793206388 3.36144624923485 3.34501389308034 3.32625657322949 3.30520219804702 3.28188088805425 3.25632498030664 3.22856902405791 3.19864976803866 3.16660613967405 3.13247921656316 3.09631219054135 3.0581503246478 3.01804090332436 2.9760331761777 2.93217829564707 2.88652924893216 2.83914078455224 2.79006933392666 2.7393729283889 2.6871111120708 2.63334485111971 2.57813643973863 2.52154940356672 2.46364840094454 2.40449912263285 2.34416819057564 2.28272305631529 2.22023189967958 2.15676352836468 2.09238727903526 2.02717292055031 1.96119055990099 1.89451055141421 1.82720340973249 1.75933972702696 1.69099009483709 1.6222250308584 1.55311491092015 1.4837299063094 1.41413992650948 1.34441456733078 1.27462306432278 1.20483425127134 1.13511652350592 1.06553780567043 0.99616552355062 0.92706657950166 0.858307330982928 0.789953571684093 0.72207051471676 0.654722777349614 0.587974366781019 0.521888666470385 0.456528422587029 0.391955730180907 0.328232018731873 0.265418036791259 0.203573835489589 0.142758750745785 0.083031384074437 0.0244495819475141 -0.0329295862760342 -0.0890498517857703 -0.14385577100403 -0.197292751358066 -0.249307077939523 -0.299845940816188 -0.348857462731468 -0.396290726902318 -0.442095804606378 -0.486223782233271 -0.528626787463172 -0.569258014227576 -0.608071746102163 -0.645023377779661 -0.68006943427132 -0.713167587488851 -0.74427666986451 -0.773356684675296 -0.800368812748425 -0.825275415239384 -0.848040032191837 -0.868627376610905 -0.88700332380912 -0.903134895818821 -0.916990240707616 -0.928538606686877 -0.937750310969538 -0.944596703415875 -0.949050125108113 -0.951083862121227 -0.950672094913343 -0.94778984395106 -0.942412912420035 -0.934517827157711 -0.924081779292605 -0.91108256649376 -0.895498539236286 -0.877308554086587 -0.856491937715907 -0.833028466174818 -0.806898364913026 -0.778082336113431 -0.746561621124636 -0.712318107109318 -0.675334488448563 -0.635594494904826 -0.593083199969082 -0.547787424084698 -0.499696248388174 -0.44880165501685 -0.395099309626428 -0.33858950019452 -0.279278243063862 -0.217178562069867 -0.15231193907828 -0.0847099239771777 -0.0144158789319405 0.0585131843903216 0.134004734392255 0.211968895482755 0.292296769414905 0.374859017877032 0.459504833505353 0.546061429206068 0.634334166905634 0.724107424510354 0.81514626333435 0.907198908948782 0.999999999999999],...
% 'XDataJitter',0,...
% 'XDataMode','manual',...
% 'ObeyXDataMode','auto',...
% 'XDataSource',blanks(0),...
% 'YDataSource',blanks(0),...
% 'ZDataSource',blanks(0),...
% 'CodeGenColorMode','manual',...
% 'CodeGenLineStyleMode','auto',...
% 'CodeGenMarkerMode','auto',...
% 'SwitchProps',{  'LineWidth'; 'LineStyle'; 'Color'; 'MarkerEdgeColor'; 'MarkerFaceColor'; 'Marker'; 'MarkerSize'; 'Visible'; 'XDataSource'; 'YDataSource'; 'ZDataSource'; 'DisplayName' },...
% 'OldSwitchProps',[],...
% 'OldSwitchVals',[]);
% 
% h14 = graph2d.lineseries(...
% 'Parent',h8,...
% 'Color',[0 0 1],...
% 'LineWidth',[],...
% 'XData',[0 2],...
% 'YData',[0 0],...
% 'XDataJitter',0,...
% 'XDataMode','manual',...
% 'ObeyXDataMode','auto',...
% 'XDataSource',blanks(0),...
% 'YDataSource',blanks(0),...
% 'ZDataSource',blanks(0),...
% 'CodeGenColorMode','auto',...
% 'CodeGenLineStyleMode','auto',...
% 'CodeGenMarkerMode','auto',...
% 'SwitchProps',{  'LineWidth'; 'LineStyle'; 'Color'; 'MarkerEdgeColor'; 'MarkerFaceColor'; 'Marker'; 'MarkerSize'; 'Visible'; 'XDataSource'; 'YDataSource'; 'ZDataSource'; 'DisplayName' },...
% 'OldSwitchProps',[],...
% 'OldSwitchVals',[]);
% 
% h15 = graph2d.lineseries(...
% 'Parent',h8,...
% 'Color',[0 0 1],...
% 'LineWidth',[],...
% 'XData',[5 2],...
% 'YData',[0 4],...
% 'XDataJitter',0,...
% 'XDataMode','manual',...
% 'ObeyXDataMode','auto',...
% 'XDataSource',blanks(0),...
% 'YDataSource',blanks(0),...
% 'ZDataSource',blanks(0),...
% 'CodeGenColorMode','auto',...
% 'CodeGenLineStyleMode','auto',...
% 'CodeGenMarkerMode','auto',...
% 'SwitchProps',{  'LineWidth'; 'LineStyle'; 'Color'; 'MarkerEdgeColor'; 'MarkerFaceColor'; 'Marker'; 'MarkerSize'; 'Visible'; 'XDataSource'; 'YDataSource'; 'ZDataSource'; 'DisplayName' },...
% 'OldSwitchProps',[],...
% 'OldSwitchVals',[]);
% 
% h16 = graph2d.lineseries(...
% 'Parent',h8,...
% 'Color',[1 0 0],...
% 'LineWidth',[],...
% 'XData',[2 2],...
% 'YData',[0 4],...
% 'XDataJitter',0,...
% 'XDataMode','manual',...
% 'ObeyXDataMode','auto',...
% 'XDataSource',blanks(0),...
% 'YDataSource',blanks(0),...
% 'ZDataSource',blanks(0),...
% 'CodeGenColorMode','manual',...
% 'CodeGenLineStyleMode','auto',...
% 'CodeGenMarkerMode','auto',...
% 'SwitchProps',{  'LineWidth'; 'LineStyle'; 'Color'; 'MarkerEdgeColor'; 'MarkerFaceColor'; 'Marker'; 'MarkerSize'; 'Visible'; 'XDataSource'; 'YDataSource'; 'ZDataSource'; 'DisplayName' },...
% 'OldSwitchProps',[],...
% 'OldSwitchVals',[]);
% 
% h17 = graph2d.lineseries(...
% 'Parent',h8,...
% 'Color',[1 0 0],...
% 'LineWidth',[],...
% 'XData',[],...
% 'YData',[0 1],...
% 'XDataJitter',0,...
% 'XDataMode','manual',...
% 'ObeyXDataMode','auto',...
% 'XDataSource',blanks(0),...
% 'YDataSource',blanks(0),...
% 'ZDataSource',blanks(0),...
% 'CodeGenColorMode','manual',...
% 'CodeGenLineStyleMode','auto',...
% 'CodeGenMarkerMode','auto',...
% 'SwitchProps',{  'LineWidth'; 'LineStyle'; 'Color'; 'MarkerEdgeColor'; 'MarkerFaceColor'; 'Marker'; 'MarkerSize'; 'Visible'; 'XDataSource'; 'YDataSource'; 'ZDataSource'; 'DisplayName' },...
% 'OldSwitchProps',[],...
% 'OldSwitchVals',[]);
% 
% h18 = graph2d.lineseries(...
% 'Parent',h8,...
% 'Color',[1 0 0],...
% 'LineWidth',[],...
% 'XData',[2 1],...
% 'YData',[4 1],...
% 'XDataJitter',0,...
% 'XDataMode','manual',...
% 'ObeyXDataMode','auto',...
% 'XDataSource',blanks(0),...
% 'YDataSource',blanks(0),...
% 'ZDataSource',blanks(0),...
% 'CodeGenColorMode','manual',...
% 'CodeGenLineStyleMode','auto',...
% 'CodeGenMarkerMode','auto',...
% 'SwitchProps',{  'LineWidth'; 'LineStyle'; 'Color'; 'MarkerEdgeColor'; 'MarkerFaceColor'; 'Marker'; 'MarkerSize'; 'Visible'; 'XDataSource'; 'YDataSource'; 'ZDataSource'; 'DisplayName' },...
% 'OldSwitchProps',[],...
% 'OldSwitchVals',[]);

appdata = [];
appdata.lastValidTag = 'r2';

h19 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('r2_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[11.0000000000001 24.923076923077 10 2.53846153846154],...
'String','2.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('r2_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','r2');

appdata = [];
appdata.lastValidTag = 'r3';

h20 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('r3_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[11.0000000000001 22.2307692307693 10 2.53846153846154],...
'String','4.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('r3_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','r3');

appdata = [];
appdata.lastValidTag = 'r4';

h21 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('r4_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[11.0000000000001 19.5384615384616 10 2.53846153846154],...
'String','5.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('r4_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','r4');

appdata = [];
appdata.lastValidTag = 'text5';

h22 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'FontName','symbol',...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[4.4000000000001 16.8461538461539 6.2 2.53846153846154],...
'String','q1',...
'Style','text',...
'Tag','text5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Theta1';

h23 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('Theta1_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[11.0000000000001 16.8461538461539 10 2.53846153846154],...
'String','0.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('Theta1_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Theta1');

appdata = [];
appdata.lastValidTag = 'uipanel3';

h24 = uipanel(...
'Parent',h1,...
'Units','characters',...
'Title','Coupler Geometry',...
'TitlePosition','centertop',...
'Tag','uipanel3',...
'UserData',[],...
'Clipping','on',...
'Position',[0.8 0.846153846153847 24.2 8.30769230769231],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Circuit_Panel';

h26 = uibuttongroup(...
'Parent',h25,...
'Units','characters',...
'Title','Circuit',...
'Tag','Circuit_Panel',...
'UserData',[],...
'Clipping','on',...
'Position',[2.8 0.461538461538462 17.6 6.07692307692308],...
'SelectedObject',[],...
'SelectionChangeFcn',@(hObject,eventdata)Four_Bar('Circuit_Panel_SelectionChangeFcn',get(hObject,'SelectedObject'),eventdata,guidata(get(hObject,'SelectedObject'))),...
'OldSelectedObject',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Open_Button';

warning('off','all');
h27 = uicontrol(...
'Parent',h26,...
'Units','characters',...
'CData',[],...
'Position',[1.2 2.61538461538461 15 2.15384615384615],...
'String','Open',...
'Style','radiobutton',...
'Value',[],...
'UserData',[],...
'Tag','Open_Button',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Crossed_Button';

h28 = uicontrol(...
'Parent',h26,...
'Units','characters',...
'CData',[],...
'Position',[1.2 0.846153846153835 15 1.76923076923077],...
'String','Crossed',...
'Style','radiobutton',...
'UserData',[],...
'Tag','Crossed_Button',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );
warning('on','all')

appdata = [];
appdata.lastValidTag = 'title';

h29 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'CData',[],...
'FontSize',20,...
'Position',[14.8 31.7692307692308 90.2 2.69230769230769],...
'String','Grashof Mechanism',...
'Style','text',...
'UserData',[],...
'Tag','title',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text7';

h30 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[4.4000000000001 1.46153846153847 6.2 2.53846153846154],...
'String','b3',...
'Style','text',...
'Tag','text7',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'a3';

h31 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('a3_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[11.0000000000001 4.15384615384617 10 2.53846153846154],...
'String','1.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('a3_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','a3');

appdata = [];
appdata.lastValidTag = 'text8';

h32 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[4.4000000000001 4.15384615384617 6.2 2.53846153846154],...
'String',{  'a3'; blanks(0) },...
'Style','text',...
'Tag','text8',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'b3';

h33 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('b3_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[11.0000000000001 1.46153846153847 10 2.53846153846154],...
'String','1.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('b3_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','b3');

appdata = [];
appdata.lastValidTag = 'Animate_Button';

h34 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Four_Bar('Animate_Button_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position',[29 4.61538461538462 15 2.53846153846154],...
'String','Play',...
'UserData',0,...
'Tag','Animate_Button',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Slider_Input';

h35 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Four_Bar('Slider_Input_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position',[45.6 5.61538461538462 45.2 1.53846153846154],...
'String','Slider',...
'Style','slider',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('Slider_Input_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'UserData',[],...
'Tag','Slider_Input');

appdata = [];
appdata.lastValidTag = 'Tempo';

h36 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback',@(hObject,eventdata)Four_Bar('Tempo_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[94.8000000000001 1.92307692307694 3.4 10.6153846153846],...
'String',{  'Slider' },...
'Style','slider',...
'Value',0.5,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('Tempo_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Tempo');

appdata = [];
appdata.lastValidTag = 'text9';

h37 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'CData',[],...
'FontName','symbol',...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[98.4 27.6153846153847 6.2 2.53846153846154],...
'String','q2',...
'Style','text',...
'UserData',[],...
'Tag','text9',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text10';

h38 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'CData',[],...
'FontName','symbol',...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[98.4 24.923076923077 6.2 2.53846153846154],...
'String','q3',...
'Style','text',...
'UserData',[],...
'Tag','text10',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text11';

h39 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'CData',[],...
'FontName','symbol',...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[98.4 22.2307692307693 6.2 2.53846153846154],...
'String','q4',...
'Style','text',...
'UserData',[],...
'Tag','text11',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text12';

h40 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'CData',[],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[98.4 19.5384615384616 6.2 2.53846153846154],...
'String','Px',...
'Style','text',...
'UserData',[],...
'Tag','text12',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text13';

h41 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0 0 0],...
'CData',[],...
'FontSize',17,...
'ForegroundColor',[1 1 1],...
'Position',[98.4 16.8461538461539 6.2 2.53846153846154],...
'String','Py',...
'Style','text',...
'UserData',[],...
'Tag','text13',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Py_Text';

h42 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[105 17.5384615384616 10 1.23076923076923],...
'String','1.00',...
'Style','text',...
'Tag','Py_Text',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Px_Text';

h43 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[105 20.2307692307692 10 1.23076923076923],...
'String','1.00',...
'Style','text',...
'Tag','Px_Text',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Theta4_Text';

h44 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[105 22.923076923077 10 1.23076923076923],...
'String','126.87',...
'Style','text',...
'Tag','Theta4_Text',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Theta3_Text';

h45 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Position',[105 25.6153846153847 10 1.23076923076923],...
'String','90.00',...
'Style','text',...
'Tag','Theta3_Text',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Theta2_Text';

h46 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)Four_Bar('Theta2_Text_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[105 27.6153846153846 10 2.53846153846154],...
'String','0.00',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)Four_Bar('Theta2_Text_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','Theta2_Text');

appdata = [];
appdata.lastValidTag = 'text18';

h47 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[49.4 1.23076923076924 35 4.23076923076923],...
'String','Move Slider To Change Input Angle',...
'Style','text',...
'Tag','text18',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text20';

h48 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'Position',[91 12.5384615384615 10.8 1.61538461538462],...
'String','Faster',...
'Style','text',...
'Tag','text20',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uitoolbar1';

h49 = uitoolbar(...
'Parent',h1,...
'Tag','uitoolbar1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.ZoomIn';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool1';

h50 = uitoggletool(...
'Parent',h49,...
'ClickedCallback','putdowntext(''zoomin'',gcbo)',...
'CData',mat{4},...
'TooltipString','Zoom In',...
'Tag','uitoggletool1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.ZoomOut';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool2';

h51 = uitoggletool(...
'Parent',h49,...
'ClickedCallback','putdowntext(''zoomout'',gcbo)',...
'CData',mat{5},...
'TooltipString','Zoom Out',...
'Tag','uitoggletool2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.Pan';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool3';

h52 = uitoggletool(...
'Parent',h49,...
'ClickedCallback','putdowntext(''pan'',gcbo)',...
'CData',mat{6},...
'TooltipString','Pan',...
'Tag','uitoggletool3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Standard.PrintFigure';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uipushtool1';

h53 = uipushtool(...
'Parent',h49,...
'ClickedCallback','printdlg(gcbf)',...
'CData',mat{7},...
'TooltipString','Print Figure',...
'BusyAction','cancel',...
'Interruptible','off',...
'Tag','uipushtool1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'reverse';

h54 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Four_Bar('reverse_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position',[30.4 2.92307692307692 12 1.53846153846154],...
'String','Reverse',...
'UserData',0,...
'Tag','reverse',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'IC_13_Button';

h56 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Four_Bar('IC_13_Button_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position',[103 9.84615384615386 15 2.53846153846154],...
'String','Show IC (1,3)',...
'Style','togglebutton',...
'UserData',[],...
'Tag','IC_13_Button',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'IC_24_Button';

h57 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback',@(hObject,eventdata)Four_Bar('IC_24_Button_Callback',hObject,eventdata,guidata(hObject)),...
'CData',[],...
'Position',[103 7.15384615384616 15 2.53846153846154],...
'String','Show IC (2,4)',...
'Style','togglebutton',...
'UserData',[],...
'Tag','IC_24_Button',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'valid_text';

h58 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.8 0.8 0.8],...
'CData',[],...
'FontSize',14,...
'ForegroundColor',[1 0 0],...
'Position',[94.8 13.7692307692308 23.8 2.38461538461538],...
'String','Invalid Angle!',...
'Style','text',...
'UserData',[],...
'Tag','valid_text',...
'Visible','off',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % FOUR_BAR_EXPORT
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % FOUR_BAR_EXPORT(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % FOUR_BAR_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % FOUR_BAR_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || isprop(fig,'__GUIDEFigure');
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);  
    %workaround for CreateFcn not called to create ActiveX
    if feature('HGUsingMATLABClasses')
        peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
        for i=1:length(peers)
            if isappdata(peers(i),'Control')
                actxproxy(peers(i));
            end            
        end
    end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


