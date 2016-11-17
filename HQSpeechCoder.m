function varargout = HQSpeechCoder(varargin)
% HQSPEECHCODER MATLAB code for HQSpeechCoder.fig
%      HQSPEECHCODER, by itself, creates a new HQSPEECHCODER or raises the existing
%      singleton*.
%
%      H = HQSPEECHCODER returns the handle to a new HQSPEECHCODER or the handle to
%      the existing singleton*.
%
%      HQSPEECHCODER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HQSPEECHCODER.M with the given input arguments.
%
%      HQSPEECHCODER('Property','Value',...) creates a new HQSPEECHCODER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HQSpeechCoder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HQSpeechCoder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HQSpeechCoder

% Last Modified by GUIDE v2.5 11-Nov-2016 23:16:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HQSpeechCoder_OpeningFcn, ...
                   'gui_OutputFcn',  @HQSpeechCoder_OutputFcn, ...
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


% --- Executes just before HQSpeechCoder is made visible.
function HQSpeechCoder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HQSpeechCoder (see VARARGIN)

% Choose default command line output for HQSpeechCoder
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HQSpeechCoder wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Create the data to plot.
handles.peaks=peaks(35);
handles.membrane=membrane;
[x,y] = meshgrid(-8:.5:8);
r = sqrt(x.^2+y.^2) + eps;
sinc = sin(r)./r;
handles.sinc = sinc;
% Set the current data value.
handles.current_data = handles.peaks;
surf(handles.current_data)






% --- Outputs from this function are returned to the command line.
function varargout = HQSpeechCoder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x, fs] = audioread('rl014.wav');
% axes(handles.axes1);
% plot(x,'b');
% xlabel('Time')
% ylabel('x(t)')
[pitch, vbp1, vbp2, vbp3, vbp4, vbp5, g, b, LSFcoef] = codificador(x,fs);
s = decodificador(pitch, vbp1, vbp2, vbp3, vbp4, vbp5, b, g, LSFcoef);
E = reshape(s,180*64,1);
axes(handles.axes3);
plot(E,'b');
xlabel('Time') % x-axis label
ylabel('xout(t)') % y-axis label

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x, fs] = audioread('rl014.wav');
axes(handles.axes1);
plot(x,'b');
xlabel('Time')
ylabel('xin(t)')
% [pitch, vbp1, vbp2, vbp3, vbp4, vbp5, g, b, LSFcoef] = codificador(x,fs);
% axes(handles.axes2);
% plot(pitch,'b');
% xlabel('Frequency') % x-axis label
% ylabel('input signal (t)') % y-axis label


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% [filename, pathname] = uigetfile('rl014.wav');
% filename = fullfile(pathname, filename);
[signal, Fs] = audioread('xin.wav');
player = audioplayer(signal, Fs);
play(player);
pause(max(size(signal))/Fs);
% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[signal, Fs] = audioread('xout.wav');
player = audioplayer(signal, Fs);
play(player);
pause(max(size(signal))/Fs);