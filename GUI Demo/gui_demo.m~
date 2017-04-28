function varargout = gui_demo(varargin)
% GUI_DEMO MATLAB code for gui_demo.fig
%      GUI_DEMO, by itself, creates a new GUI_DEMO or raises the existing
%      singleton*.
%
%      H = GUI_DEMO returns the handle to a new GUI_DEMO or the handle to
%      the existing singleton*.
%
%      GUI_DEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_DEMO.M with the given input arguments.
%
%      GUI_DEMO('Property','Value',...) creates a new GUI_DEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_demo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_demo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_demo

% Last Modified by GUIDE v2.5 20-Apr-2017 04:02:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_demo_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_demo_OutputFcn, ...
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


% --- Executes just before gui_demo is made visible.
function gui_demo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_demo (see VARARGIN)

% Choose default command line output for gui_demo
handles.output = hObject;
handles.song_counter = 4;
handles.bp_filt = designfilt('bandpassfir', 'StopbandFrequency1', 1,...
    'PassbandFrequency1', 50, 'PassbandFrequency2', 400,...
    'StopbandFrequency2', 450, 'StopbandAttenuation1', 60,...
    'PassbandRipple', 3, 'StopbandAttenuation2', 60, 'SampleRate', 44100);
handles.audio = 0;
handles.fs = 0;
handles.ground_truth = 0;
handles.period = 0;
warning off;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_demo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



files = dir('/Users/someshganesh/Documents/GaTech/Spring 2017/MUSI 7100/Datasets/Gaint Steps/giantsteps-tempo-dataset-master/audio');
song_counter = str2num(get(handles.song_number,'String')) + 3;
[stereo_audio,fs] = audioread(strcat(files(song_counter).folder,'/',files(song_counter).name));
[path,name,ext] = fileparts(strcat(files(song_counter).folder,'/',files(song_counter).name));
bpmfile = fopen(strcat('/Users/someshganesh/Documents/GaTech/Spring 2017/MUSI 7100/Datasets/Gaint Steps/giantsteps-tempo-dataset-master/annotations/tempo/',name,'.bpm'));
true_bpm(song_counter - 3) = fscanf(bpmfile,'%f');
mono_audio = (stereo_audio(:,1) + stereo_audio(:,2)) / 2;
audio = normalizeIntensityLevel(mono_audio,fs);
t = 0:1/fs:(length(audio)-1)/fs;
f = 1:fs/2048:fs;

set(handles.text1, 'String', name);
set(handles.song_number, 'String', num2str(song_counter - 3));
set(handles.true_bpm, 'String', num2str(true_bpm(song_counter - 3)));

axes(handles.axes1);
plot(t, mono_audio); axis tight;

handles.song_counter = song_counter;
handles.audio = audio;
handles.fs = fs;
handles.ground_truth = true_bpm(song_counter - 3);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function song_number_Callback(hObject, eventdata, handles)
% hObject    handle to song_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of song_number as text
%        str2double(get(hObject,'String')) returns contents of song_number as a double


% --- Executes during object creation, after setting all properties.
function song_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to song_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in tempo_estimate.
function tempo_estimate_Callback(hObject, eventdata, handles)
% hObject    handle to tempo_estimate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = handles.audio;
fs = handles.fs;
bp_filt = handles.bp_filt;

song_counter = str2num(get(handles.song_number,'String')) + 3;

bp_filtered_signal = bpass(bp_filt,audio,fs);
%%
%Dividing the file into blocks
block_size = 1024;
hop_size = 256;

[time_stamps,audio_blocks] = generateBlocks(bp_filtered_signal, fs, block_size, hop_size);

[time_stamps,audio_blocks2] = generateBlocks(audio, fs, block_size, hop_size);

%%
%Feature Extraction

rms_audio_blocks = rmsCal(audio_blocks,fs);
diff_rms = diff([0 rms_audio_blocks]);

rms_audio_blocks2 = rmsCal(audio_blocks2,fs);
diff_rms2 = diff([0 rms_audio_blocks2]);

sflux_audio_blocks = sflux(audio_blocks2,block_size,fs);

spec_centroid_blocks = specCentroid(audio_blocks2, block_size, fs);
diff_centroid = diff([0 spec_centroid_blocks]);
%%
%Estimation

count = 1;

[period(1), acorr_bpm(count, 1)] = periodAcorr(normalizeIntensityLevel(diff_rms, fs),time_stamps);
[period(2), acorr_bpm(count, 2)] = periodAcorr(normalizeIntensityLevel(diff_rms2, fs),time_stamps);
[period(3), acorr_bpm(count, 3)] = periodAcorr(normalizeIntensityLevel(sflux_audio_blocks, fs),time_stamps);
[period(4), acorr_bpm(count, 4)] = periodAcorr(normalizeIntensityLevel(diff_centroid, fs),time_stamps);

tempo(count,1) = crossGrid(normalizeIntensityLevel(diff_rms, fs), period(1), time_stamps);
tempo(count,2) = crossGrid(normalizeIntensityLevel(diff_rms2, fs), period(1), time_stamps);
tempo(count,3) = crossGrid(normalizeIntensityLevel(sflux_audio_blocks, fs), period(1), time_stamps);
tempo(count,4) = crossGrid(normalizeIntensityLevel(diff_centroid, fs), period(1), time_stamps);

tempo(count,5) = crossGrid(normalizeIntensityLevel(diff_rms, fs), period(2), time_stamps);
tempo(count,6) = crossGrid(normalizeIntensityLevel(diff_rms2, fs), period(2), time_stamps);
tempo(count,7) = crossGrid(normalizeIntensityLevel(sflux_audio_blocks, fs), period(2), time_stamps);
tempo(count,8) = crossGrid(normalizeIntensityLevel(diff_centroid, fs), period(2), time_stamps);

tempo(count,9) = crossGrid(normalizeIntensityLevel(diff_rms, fs), period(3), time_stamps);
tempo(count,10) = crossGrid(normalizeIntensityLevel(diff_rms2, fs), period(3), time_stamps);
tempo(count,11) = crossGrid(normalizeIntensityLevel(sflux_audio_blocks, fs), period(3), time_stamps);
tempo(count,12) = crossGrid(normalizeIntensityLevel(diff_centroid, fs), period(3), time_stamps);

tempo(count,13) = crossGrid(normalizeIntensityLevel(diff_rms, fs), period(4), time_stamps);
tempo(count,14) = crossGrid(normalizeIntensityLevel(diff_rms2, fs), period(4), time_stamps);
tempo(count,15) = crossGrid(normalizeIntensityLevel(sflux_audio_blocks, fs), period(4), time_stamps);
tempo(count,16) = crossGrid(normalizeIntensityLevel(diff_centroid, fs), period(4), time_stamps);
%%
%Evaluation

ground_truth(count) = handles.ground_truth;

final_tempo(count) = mode(tempo(count,:))

final_diff(count) = ground_truth(count)' - final_tempo(count)

final_result(count) = abs(final_diff(count))<1

if final_result(count) == 1
    set(handles.result, 'String', 'Correct Estimation!');
else
    set(handles.result, 'String', 'Wrong estimation!');
end 

period_time = 60 / final_tempo(count);

handles.period = period_time;

guidata(hObject, handles);


% --- Executes on button press in play_loop.
function play_loop_Callback(hObject, eventdata, handles)
% hObject    handle to play_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audio = handles.audio;
fs = handles.fs;
time_period = handles.period;
ground_truth = handles.ground_truth;
true_period = 60 / ground_truth;

offset = str2num(get(handles.offset,'String'));
i = str2num(get(handles.beats,'String'));

loop = audio(round(offset * true_period * fs) + 1 : round(offset * true_period * fs) + 1 + round(i * time_period * fs));

full_loop = loop;
for iloop = 1 : 10
    full_loop = [full_loop;loop];
end

soundsc(full_loop, fs);
    
guidata(hObject, handles);


function beats_Callback(hObject, eventdata, handles)
% hObject    handle to beats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beats as text
%        str2double(get(hObject,'String')) returns contents of beats as a double
audio = handles.audio;
fs = handles.fs;
time_period = handles.period;
ground_truth = handles.ground_truth;
true_period = 60 / ground_truth;

offset = str2num(get(handles.offset,'String'));
i = str2num(get(handles.beats,'String'));

plot_audio = audio(round(offset * true_period * fs) + 1 : round(offset * true_period * fs) + 1 + round(i * time_period * fs));
t = 0:1/fs:(length(plot_audio)-1)/fs;

axes(handles.axes1);
plot(t, plot_audio); axis tight;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function beats_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beats (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop_loop.
function stop_loop_Callback(hObject, eventdata, handles)
% hObject    handle to stop_loop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear sound;

function offset_Callback(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of offset as text
%        str2double(get(hObject,'String')) returns contents of offset as a double
audio = handles.audio;
fs = handles.fs;
time_period = handles.period;
ground_truth = handles.ground_truth;
true_period = 60 / ground_truth;

offset = str2num(get(handles.offset,'String'));
i = str2num(get(handles.beats,'String'));

plot_audio = audio(round(offset * true_period * fs) + 1 : round(offset * true_period * fs) + 1 + round(i * time_period * fs));
t = 0:1/fs:(length(plot_audio)-1)/fs;

axes(handles.axes1);
plot(t, plot_audio); axis tight;

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
