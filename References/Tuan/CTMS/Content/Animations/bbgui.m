function varargout = bbgui(varargin)
%%**************************************************************%
%This functions creates a graphical user interface which        %
%contains an animation of Ball and Beam example though     %
%GUIDE.This function was created for the Control Tutorials for  %
%Matlab. Itrequires the function busFUN.m to be executed.       %          %       
%                                                               %
%Copyright (C) 1997 by the Regents of the University of         %
%Michigan.                                                      %
%Modified by Asst. Prof. Rick Hill (U Detroit-Mercy) and his    %
%student Li Guan.                                               %   
%***************************************************************% 
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bbgui_OpeningFcn, ...
                   'gui_OutputFcn',  @bbgui_OutputFcn, ...
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
% --- Executes just before bbgui is made visible.
function bbgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bbgui (see VARARGIN)

% Choose default command line output for bbgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bbgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bbgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function stepslider_Callback(hObject, eventdata, handles)
% hObject    handle to stepslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global stepval % value should be used for non-linear system
    stepval=get(handles.stepslider,'Value');
    set(handles.text2,'String',sprintf('%6.2f',stepval*100));   
guidata(hObject, handles); 



% --- Executes during object creation, after setting all properties.
function stepslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in run.
function run_Callback(hObject, eventdata, handles)
% hObject    handle to run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global K
global Nbar
global stepval
%The Callback for the Run Button%
    g=-9.8;
    A=[0 1 0 0;0 0 -5/7*g 0;0 0 0 1;0 0 0 0];
    B=[0;0;0;1];
    C=[1 0 1 0];
    D=[0];	    
%Get the poles from the editable text in the GUI%
    real = eval(get(handles.realtext,'string'));
    imag = eval(get(handles.imagtext,'string'));
    p1=real+imag*i;
    p2=real-imag*i;
    p3=eval(get(handles.pole3,'string'));
    p4=eval(get(handles.pole4,'string'));
%Place the poles and create the K-matrix%    
    K=place(A,B,[p1,p2,p3,p4]);   
%Get the value of the step input from the step slider%    
    stepval=get(handles.stepslider,'Value');
    stepaxis=stepval;        
%The following Lines represent the rscale function to find Nbar%
%The reference input checkbox is checked for its value, also%
    Nbarval = get(handles.reference,'Value');
    if Nbarval == 0
        Nbar = 1
        stepaxis=stepval/1000;      
    elseif Nbarval == 1
        s = size(A,1);
        Z = [zeros([1,s]) 1];
        N = inv([A,B;C,D])*Z';
        Nx = N(1:s);
        Nu = N(1+s);
        Nbar=Nu + K*Nx;
    end      
%Check if the system is linear or non-linear from checkbox%    
    sysval = get(handles.syscheckbox,'Value');
%Linear System Simulation%    
    if sysval == 0     
       T = 0:0.05:6;                  
       U = stepval*ones(size(T));             
       [Y,X]=lsim(A-B*K,B*Nbar,C,D,U,T); 
       ball=X(:,1);    
       theta=X(:,3);
%Non-Linear System Simulation%    
    else 
       t0=0;
       tfinal=6;
       x0=[0 0 0 0];
	   v=version;
	   if eval(v(1))>=5
       	  'Please wait while simulation is running'
       	  [T,X]=ode23('bbfunode',[t0 tfinal],x0);
	   else	
	      tol=1e-5;
	      'Please wait while simulation is running'
	      [T,X]=ode45('bbfundode',t0,tfinal,x0,tol);
	   end
       ball=X(:,1);
       theta=X(:,3);  
    end
%Set ball and beam characteristics for animation% 
    ball=ball*100; 
    beam_length = 100;  
    bl2 = beam_length/2;
    radius = 3;              %Ball radius% 
    arcstep = 36;
    ballx=ball.*cos(theta);     
    bally = - ballx .* tan(theta) + radius;  
    j = 0:arcstep:(360-arcstep);  
    arcx = radius * cos((j+arcstep) * pi/180);  
    arcy = radius * sin((j+arcstep) * pi/180);  
    beamx1 = -bl2 * cos(theta);  
    beamx2 = bl2 * cos(theta);  
    beamy1 = bl2 * sin(theta);  
    beamy2 = -bl2 * sin(theta);
    
%Check if the step response is to be plotted seperately%
    value2=get(handles.separatebox,'Value');   
    axes(handles.axes1)
    if value2 == 1
       plot(T,ball)
    else
       plot(T(1),ball(1), 'EraseMode', 'none')
    end  
    
%Assign values for the axis based on the value of stepval%
    if stepval > 0
       axis([0 6 0 stepaxis*200])
    elseif stepval < 0
       axis([0 6 stepaxis*200 0])
    else
       axis([0 6 -50 50])
    end
%Add title, xlabel, and ylabel to the step response plot%   
    title(sprintf('Step Response to %2.2f cm input',stepval*100))
    ylabel('Ball Position (cm)')
    xlabel('Time (sec)') 
    
    hold on    
%Plot the first element of the ball and beam with title,etc...%
    axes(handles.axes2)
    L = plot([beamx1(1) beamx2(1)], [beamy1(1) beamy2(1)], 'r', 'EraseMode',...
    'xor','LineWidth',[3]);
    axis([-55 55 -55 55]); 
    title('Animation')
    xlabel('Horizontal Position (cm)')
    ylabel('Vertical Position (cm)') 
    H = patch(arcx+ballx(1), arcy+bally(1), 'b', 'EraseMode', 'xor');
 
%Check if the graphs should advance manuallly%  
   value=get(handles.manualbox,'Value');
    if value == 1
       'Press any key to advance the animation'
       pause
       
    end   
%For-loop runs the animation%   
    ltheta=length(theta);
    for k = 2:ltheta-1,  
        
%Manual advance% 	      
       if value == 1
           pause
       end
     
%Set ball and beam data and draw the new coordinates% 
       set(L, 'XData', [beamx1(k) beamx2(k)]);  
       set(L, 'YData', [beamy1(k) beamy2(k)]);  
       set(H, 'XData', arcx+ballx(k));  
       set(H, 'YData', arcy+bally(k));  
       drawnow;
%Check if ball is still on the beam%
       if ball(k) > 50
          axes(handles.axes2)	
          text(-25,25,'Ball has fallen off beam!')
          return
       end 		
%Plot response with animation%     
       if value2 == 0	
          axes(handles.axes1)
          plot([T(k),T(k+1)],[ball(k),ball(k+1)], 'EraseMode', 'none')
       end 	
    end    
 guidata(hObject, handles);   
    

function realtext_Callback(hObject, eventdata, handles)
% hObject    handle to realtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of realtext as text
%        str2double(get(hObject,'String')) returns contents of realtext as a double


% --- Executes during object creation, after setting all properties.
function realtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to realtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imagtext_Callback(hObject, eventdata, handles)
% hObject    handle to imagtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
% Hints: get(hObject,'String') returns contents of imagtext as text
%        str2double(get(hObject,'String')) returns contents of imagtext as a double


% --- Executes during object creation, after setting all properties.
function imagtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pole3_Callback(hObject, eventdata, handles)
% hObject    handle to pole3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of pole3 as text
%        str2double(get(hObject,'String')) returns contents of pole3 as a double


% --- Executes during object creation, after setting all properties.
function pole3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pole3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pole4_Callback(hObject, eventdata, handles)
% hObject    handle to pole4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of pole4 as text
%        str2double(get(hObject,'String')) returns contents of pole4 as a double


% --- Executes during object creation, after setting all properties.
function pole4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pole4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in syscheckbox.
function syscheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to syscheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of syscheckbox


% --- Executes on button press in reference.
function reference_Callback(hObject, eventdata, handles)
% hObject    handle to reference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of reference


% --- Executes on button press in manualbox.
function manualbox_Callback(hObject, eventdata, handles)
% hObject    handle to manualbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of manualbox


% --- Executes on button press in separatebox.
function separatebox_Callback(hObject, eventdata, handles)
% hObject    handle to separatebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of separatebox


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Clears the step response axis%
    axes(handles.axes1)
    cla
    axis([0 5 0 50])
    ylabel('Ball Position (cm)')
    xlabel('Time (sec)')
    title('Step Response')
%Returns ball and beam to their zero conditions%      
    beam_length = 100; 
    bl2 = beam_length/2;
    radius = 3.0; 
    arcstep = 36;
    ballx = 0;
    bally = - ballx .* tan(0) + radius; 
    j = 0:arcstep:(360-arcstep); 
    arcx = radius * cos((j+arcstep) * pi/180); 
    arcy = radius * sin((j+arcstep) * pi/180); 
    beamx1 = -bl2 * cos(0); 
    beamx2 = bl2 * cos(0); 
    beamy1 = bl2 * sin(0); 
    beamy2 = -bl2 * sin(0);
    axes(handles.axes2)
    L = plot([beamx1(1) beamx2(1)], [beamy1(1) beamy2(1)], 'r', 'EraseMode', ...
      'xor','LineWidth',[3]);
    axis([-55 55 -55 55]);
    title('Animation')
    xlabel('Horizontal Position (cm)')
    ylabel('Vertical Position (cm)')
    H = patch(arcx+ballx(1), arcy+bally(1), 'b', 'EraseMode', 'xor');    
guidata(hObject, handles);

% --- Executes on button press in repeat.
function repeat_Callback(hObject, eventdata, handles)
% hObject    handle to repeat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Callback for the Repeat button%
%global ball
%global theta
%T = 0:0.05:6;  
%Get the stored values of ballx, theta, and time%
%    ballhandle = findobj('Tag','ballxframe');
%    ball=get(ballhandle,'Value');
%    thetahandle = findobj('Tag','thetaframe');
%    theta=get(thetahandle,'Value');
%    timehandle = findobj('Tag','timeframe');
%    T=get(timehandle,'Value');
    
    g=-9.8;
    A=[0 1 0 0;0 0 -5/7*g 0;0 0 0 1;0 0 0 0];
    B=[0;0;0;1];
    C=[1 0 1 0];
    D=[0];	    
%Get the poles from the editable text in the GUI%
    real = eval(get(handles.realtext,'string'));
    imag = eval(get(handles.imagtext,'string'));
    p1=real+imag*i;
    p2=real-imag*i;
    p3=eval(get(handles.pole3,'string'));
    p4=eval(get(handles.pole4,'string'));

%Place the poles and create the K-matrix%    
    K=place(A,B,[p1,p2,p3,p4]);  	
%Get the value of the step input from the step slider%    
    stepval=get(handles.stepslider,'Value');
    stepaxis=stepval;    
    
%The following Lines represent the rscale function to find Nbar%
%The reference input checkbox is checked for its value, also%
    Nbarval = get(handles.reference,'Value');
    if Nbarval == 0
        Nbar = 1
        stepaxis=stepval/1000;      
    elseif Nbarval == 1
        s = size(A,1);
        Z = [zeros([1,s]) 1];
        N = inv([A,B;C,D])*Z';
        Nx = N(1:s);
        Nu = N(1+s);
        Nbar=Nu + K*Nx;
    end  
    
%Check if the system is linear or non-linear from checkbox%    
    sysval = get(handles.syscheckbox,'Value');
%Linear System Simulation%    
    if sysval == 0     
       T = 0:0.05:6;                  
       U = stepval*ones(size(T));             
       [Y,X]=lsim(A-B*K,B*Nbar,C,D,U,T); 
       ball=X(:,1);    
       theta=X(:,3);
%Non-Linear System Simulation%    
    else 
       t0=0;
       tfinal=6;
       x0=[0 0 0 0];
	   v=version;
	   if eval(v(1))>=5
       	  'Please wait while simulation is running'
       	  [T,X]=ode23('bbfunode',[t0 tfinal],x0);
	   else	
	      tol=1e-5;
	      'Please wait while simulation is running'
	      [T,X]=ode45('bbfundode',t0,tfinal,x0,tol);
	   end
       ball=X(:,1);
       theta=X(:,3);  
    end
    
%Set ball and beam characteristics for animation% 
    ball=ball*100; 
    beam_length = 100;  
    bl2 = beam_length/2;
    radius = 3;              %Ball radius% 
    arcstep = 36;
    ballx=ball.*cos(theta);     
    bally = - ballx .* tan(theta) + radius;  
    j = 0:arcstep:(360-arcstep);  
    arcx = radius * cos((j+arcstep) * pi/180);  
    arcy = radius * sin((j+arcstep) * pi/180);  
    beamx1 = -bl2 * cos(theta);  
    beamx2 = bl2 * cos(theta);  
    beamy1 = bl2 * sin(theta);  
    beamy2 = -bl2 * sin(theta);        
%Check if the step response is to be plotted seperately%
   value2=get(handles.separatebox,'Value'); 
   axes(handles.axes1)
    if value2 == 1
       plot(T,ball)
    else
       plot(T(1),ball(1), 'EraseMode', 'none')
    end    
%Assign values for the axis based on the value of stepval%
    stepval=get(handles.stepslider,'Value');    
    Nbarval = get(handles.reference,'Value');
    if Nbarval == 1
       stepaxis=stepval;
    else
       stepaxis=stepval/1000;   
    end
    
    if stepval > 0
       axis([0 6 0 stepaxis*200])
    elseif stepval < 0
       axis([0 6 stepaxis*200 0])
    else
       axis([0 6 -50 50])
    end
%Add title, xlabel, and ylabel to the step response plot%   
    title(sprintf('Step Response to %2.2f cm input',stepval*100))
    ylabel('Ball Position (cm)')
    xlabel('Time (sec)') 
   
    hold on
    
%Plot the first element of the ball and beam with title,etc...%
    axes(handles.axes2)
    L = plot([beamx1(1) beamx2(1)], [beamy1(1) beamy2(1)], 'r', 'EraseMode',...
    'xor','LineWidth',[3]);
    axis([-55 55 -55 55]); 
    title('Animation')
    xlabel('Horizontal Position (cm)')
    ylabel('Vertical Position (cm)') 
    H = patch(arcx+ballx(1), arcy+bally(1), 'b', 'EraseMode', 'xor');

%Check if the graphs should advance manuallly%  
    value=get(handles.manualbox,'Value');   
%For-loop runs the animation%   
    ltheta=length(theta);
    for k = 2:ltheta-1,  

    %Manual advance% 	      
       if value == 1
           pause
       end
     
    %Set ball and beam data and draw the new coordinates% 
       set(L, 'XData', [beamx1(k) beamx2(k)]);  
       set(L, 'YData', [beamy1(k) beamy2(k)]);  
       set(H, 'XData', arcx+ballx(k));  
       set(H, 'YData', arcy+bally(k));  
       drawnow;
    
    %Check if ball is still on the beam%
       if ball(k) > 50
          axes(handles.axes2)	
          text(-25,25,'Ball has fallen off beam!')
          return
       end 		
    
    %Plot response with animation%     
       if value2 == 0	
          axes(handles.axes1)
          plot([T(k),T(k+1)],[ball(k),ball(k+1)], 'EraseMode', 'none')
       end
      	
    end
guidata(hObject, handles);



% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(bbgui)
