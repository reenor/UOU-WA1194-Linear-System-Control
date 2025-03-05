function varargout = busgui(varargin)

%**************************************************************%
%This functions creates a graphical user interface which       %
%contains an animation of the Bus Suspension example.  This    %
%function was created for the Control Tutorials for Matlab. It %
%requires the function busFUN.m to be executed.                %       
%                                                              %
%Copyright (C) 1997 by the Regents of the University of        %
%Michigan.                                                     % 
%(7-11-2012) Modified by Asst. Prof. Rick Hill (UDM) and his   %
%student Li Guan.                                              %  
%**************************************************************%                
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @busgui_OpeningFcn, ...
                   'gui_OutputFcn',  @busgui_OutputFcn, ...
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


% --- Executes just before busgui is made visible.
function busgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to busgui (see VARARGIN)

% Choose default command line output for busgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes busgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = busgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
k=get(hObject,'value');

if  abs(k)<1e6
    k=sprintf('%0.1g',k);
  else  
    k=sprintf('%0.2g',k);
end
a=num2str(k);
set(handles.text2,'string',a);


K=eval(k);
  
  Ks=-1e6:1e5:1e7;

  lk=length(Ks);
  for n1=1:lk,
    if Ks(n1) == K
      n2=n1;
    elseif abs(K)<1e5
      n2=11;    
    end
  end
  

  m1=2500;
  m2=320;
  k1 = 80000;
  k2 = 500000;
  b1 = 350;
  b2 = 15020;

  nump=[(m1+m2) b2 k2];
  denp=[(m1*m2) (m1*(b1+b2))+(m2*b1) (m1*(k1+k2))+(m2*k1)+(b1*b2) (b1*k2)+(b2*k1) k1*k2];

  num1=[-(m1*b2) -(m1*k2) 0 0];
  den1=[(m1*m2) (m1*(b1+b2))+(m2*b1) (m1*(k1+k2))+(m2*k1)+(b1*b2) (b1*k2)+(b2*k1) k1*k2];

  numf=num1;
  denf=nump;
          
  z1=3+3.5i;
  z2=3-3.5i;
  p1=30;
  p2=60;
  numc=conv([1 z1],[1 z2]);
  denc=conv([1 p1],[1 p2]);
  
  
  numk=conv(nump,numc);
  denk=conv(denp,denc);    
  
  axes(handles.axes1)
  
  R=rlocus(numk,denk,Ks);
  cla
  rlocus(numk,denk)
  title('Open-loop Root Locus')
  hold on
  plot(real(R(n2,:)),imag(R(n2,:)),'r+');  
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 
%Callback for the RUN button%

  m1=2500;
  m2=320;
  k1 = 80000;
  k2 = 500000;
  b1 = 350;
  b2 = 15020;

  nump=[(m1+m2) b2 k2];
  denp=[(m1*m2) (m1*(b1+b2))+(m2*b1) (m1*(k1+k2))+(m2*k1)+(b1*b2) (b1*k2)+(b2*k1) k1*k2];

  num1=[-(m1*b2) -(m1*k2) 0 0];
  den1=[(m1*m2) (m1*(b1+b2))+(m2*b1) (m1*(k1+k2))+(m2*k1)+(b1*b2) (b1*k2)+(b2*k1) k1*k2];

  numf=num1;
  denf=nump;
      
  z1=3+3.5i;
  z2=3-3.5i;
  p1=30;
  p2=60;
  numc=conv([1 z1],[1 z2]);
  denc=conv([1 p1],[1 p2]);
  
%Get the value of the gain from the slider%
  k=get(handles.slider1,'Value');

  numc=k*numc;
  numa=conv(conv(numf,nump),denc);
  
  poly1=conv(denp,denc);
  poly2=conv(nump,numc);
  
  
%Polyadd function%  
  if length(poly1)<length(poly2)
    short=poly1;
    long=poly2;
  else
    short=poly2;
    long=poly1;
  end
  mz=length(long)-length(short);
  if mz>0
    poly=[zeros(1,mz),short]+long;
  else
    poly=long+short;
  end
  
  dena=conv(denf,poly); 

%Run the simulation with a 0.1m step disturbance%     
  t=0:0.04:7;
  u=0.1*ones(size(t));
  [Y]=lsim(numa,dena,u,t);
  
  lt=length(t);
  changet=t;
  for nt=1:lt-1,
    changet(1:23)=-0.91:0.04:0;
    changet(nt+23)=t(nt);
  end
  t=changet;  
  
  lY=length(Y);
  change=Y;
  for nc=1:lt-1,
    change(1:23)=change(1:23)*0;
    change(nc+23)=Y(nc);
  end  
  Y=change;
%Check if response should be plotted separately% 
  plotval=get(handles.Seperately,'Value');   
  axes(handles.axes3)
  if plotval == 1
    plot(t,Y)
  else
    plot(t(1),Y(1), 'EraseMode', 'none')
  end
  title('Bus response to a step disturbance of 0.1m')
  xlabel('Time (sec.)')
  ylabel('Bus oscillation (m)')
  axis([-1 7 -0.1 0.1])
  hold on
  
  %Draw the bus and ground%  
  l=1;
  h=0.5;

  x1=-l/2;
  y1=Y+0.3;
  x2=-l/2;
  y2=Y+0.3+h;
  x3=l/2;
  y3=Y+0.3+h;
  x4=l/2;
  y4=Y+0.3;
  x5=l/10;
  y5=Y+0.3;
  x6=l/10;
  y6=Y+0.4;
  x7=-l/10;
  y7=Y+0.4;
  x8=-l/10;
  y8=Y+0.3;

  st=0.4+Y;
  sb=0.29+Y;
  tire=0.2;

  gxr=1;
  gy=0.105;
  sxr=-1:0.04:7;
  sxl=-1;
  sy=0.205;

  wx1=-0.35;
  wy1=0.6+Y;
  wx2=-0.35;
  wy2=0.7+Y;
  wx3=-0.25;
  wy3=0.7+Y;
  wx4=-0.25;
  wy4=0.6+Y;
  
 axes(handles.axes2)
 
  cla
  A = plot([x1 x2 x3 x4 x5 x6 x7 x8 x1],...
         [y1(1) y2(1) y3(1) y4(1) y5(1) y6(1) y7(1) y8(1) y1(1)],...
         'k','EraseMode', 'background','LineWidth',[2]);
  hold on
         
  B = plot([wx1 wx2 wx3 wx4 wx1],[wy1(1) wy2(1) wy3(1) wy4(1) wy1(1)],...         
         'k','EraseMode', 'background','LineWidth',[2]);
         
  C = plot([wx1+0.2 wx2+0.2 wx3+0.2 wx4+0.2 wx1+0.2],[wy1(1) wy2(1) wy3(1) wy4(1) wy1(1)],...         
         'k','EraseMode', 'background','LineWidth',[2]);

  D = plot([wx1+0.4 wx2+0.4 wx3+0.4 wx4+0.4 wx1+0.4],[wy1(1) wy2(1) wy3(1) wy4(1) wy1(1)],...         
         'k','EraseMode', 'background','LineWidth',[2]); 

  E = plot([wx1+0.6 wx2+0.6 wx3+0.6 wx4+0.6 wx1+0.6],[wy1(1) wy2(1) wy3(1) wy4(1) wy1(1)],...         
         'k','EraseMode', 'background','LineWidth',[2]); 
                         
  L = plot([sxl sxr(1) sxr(1) gxr],[sy sy gy gy], 'g',...
                'EraseMode', 'background','LineWidth',[2]);

  I = plot([0 0],[st(1) sb(1)], 'k',...
                'EraseMode', 'background','LineWidth',[2]);
                
  radius = 0.09;
  arcstep = 18;
  j = 0:arcstep:(360-arcstep);  
  arcx = radius * cos((j+arcstep) * pi/180);  
  arcy = radius * sin((j+arcstep) * pi/180);  

  J = patch(arcx, arcy+tire(1), 'b', 'EraseMode', 'background');                                        
  title('1/4 Bus suspension model animation');
  axis([-1 1 0 1])
%Check if frames should advance manually%  
  man=get(handles.Manual,'Value');
  if man == 1
    'Press any key to advance the animation'
    pause
  end   

   lY=length(Y);
  for z=2:lY-1,
    
    if man == 1
      pause
    end 

    if z == 24
      sb=0.39+Y;
      tire=0.3;
      y1=Y+0.4;
      y4=Y+0.4;
      y2=Y+0.4+h;
      y3=Y+0.4+h;
      y8=Y+0.4;
      y5=Y+0.4;
      y7=Y+0.5;
      y6=Y+0.5;
      st=0.5+Y;
      wy1=0.7+Y;
      wy2=0.8+Y;
      wy3=0.8+Y;
      wy4=0.7+Y;
    end

    set(L, 'XData', [sxl sxr(z) sxr(z) gxr]);
    set(J, 'YData', arcy+tire);
    set(A, 'YData', [y1(z) y2(z) y3(z) y4(z) y5(z) y6(z) y7(z) y8(z) y1(z)]);
    set(B, 'YData', [wy1(z) wy2(z) wy3(z) wy4(z) wy1(z)]);
    set(C, 'YData', [wy1(z) wy2(z) wy3(z) wy4(z) wy1(z)]);
    set(D, 'YData', [wy1(z) wy2(z) wy3(z) wy4(z) wy1(z)]);
    set(E, 'YData', [wy1(z) wy2(z) wy3(z) wy4(z) wy1(z)]); 
    set(I, 'YData', [st(z) sb(1)]);
    drawnow;
    
    if plotval == 0
      axes(handles.axes3)
      plot([t(z),t(z+1)],[Y(z),Y(z+1)], 'EraseMode','none')
      axis([-1 7 -0.1 0.1])
    end 
  end
  guidata(hObject,handles);
% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  axes(handles.axes2)
  
  l=1;h=0.5;x1=-l/2;y1=0.3;
  x2=-l/2;y2=0.3+h;x3=l/2;
  y3=0.3+h;x4=l/2;y4=0.3;
  x5=l/10;y5=0.3;x6=l/10;
  y6=0.4;x7=-l/10;y7=0.4;
  x8=-l/10;y8=0.3;st=0.4;
  sb=0.29;tire=0.2;gxr=1;
  gy=0.105;sxr=-1;sxl=-1;
  sy=0.205;wx1=-0.35;wy1=0.6;
  wx2=-0.35;wy2=0.7;wx3=-0.25;
  wy3=0.7;wx4=-0.25;wy4=0.6;

  cla
  A = plot([x1 x2 x3 x4 x5 x6 x7 x8 x1],...
         [y1 y2 y3 y4 y5 y6 y7 y8 y1],...
         'k','EraseMode', 'background','LineWidth',[2]);
  hold on
         
  B = plot([wx1 wx2 wx3 wx4 wx1],[wy1 wy2 wy3 wy4 wy1],...         
         'k','EraseMode', 'background','LineWidth',[2]);
         
  C = plot([wx1+0.2 wx2+0.2 wx3+0.2 wx4+0.2 wx1+0.2],[wy1 wy2 wy3 wy4 wy1],...      
         'k','EraseMode', 'background','LineWidth',[2]);

  D = plot([wx1+0.4 wx2+0.4 wx3+0.4 wx4+0.4 wx1+0.4],[wy1 wy2 wy3 wy4 wy1],...      
         'k','EraseMode', 'background','LineWidth',[2]); 

  E = plot([wx1+0.6 wx2+0.6 wx3+0.6 wx4+0.6 wx1+0.6],[wy1 wy2 wy3 wy4 wy1],...      
         'k','EraseMode', 'background','LineWidth',[2]); 
                         
  L = plot([sxl sxr sxr gxr],[sy sy gy gy], 'g',...
         'EraseMode', 'background','LineWidth',[2]);

  I = plot([0 0],[st sb], 'k',...
         'EraseMode', 'background','LineWidth',[2]);
                
  radius = 0.09;
  arcstep = 18;
  j = 0:arcstep:(360-arcstep);  
  arcx = radius * cos((j+arcstep) * pi/180);  
  arcy = radius * sin((j+arcstep) * pi/180);  

  J = patch(arcx, arcy+tire, 'b', 'EraseMode', 'background');          
                                                               
  title('1/4 Bus suspension model animation')

%Clear the time response plot%
  axes(handles.axes3)
  cla
  title('Bus response to a step disturbance of 0.1m')
  xlabel('Time (sec.)')
  ylabel('Bus oscillation (m)')
guidata(hObject,handles);
 




% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
 
% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function Manual_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Seperately_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Seperately (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Seperately.
function Seperately_Callback(hObject, eventdata, handles)
% hObject    handle to Seperately (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Seperately


% --- Executes on button press in Manual.
function Manual_Callback(hObject, eventdata, handles)
% hObject    handle to Manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Manual


% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(busgui);
