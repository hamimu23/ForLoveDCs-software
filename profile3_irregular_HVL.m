% Defining the model parameters of S-wave velocity profile
NN=5; % Number of Layer
VS=[200 300 700 600 450]; % Share velocity of each layer (m/s)
RHO=[1.7 1.8 2.0 1.8 1.8]*1e3; % Density values of each layer (kg/m^3)
H=[0 2.5 3.5 5 7.5]; % Thickness values of each layer (m)
% Reading the input of global parameters of surface waves
ISFREQ=1.0;% Starting of Frequeency looping
IEFREQ=120;% Ending of frequency looping
DFREQ=3.5;% Shift frequency
MINVEL=50;% Starting of velocity looping
MAXVEL=700;% Ending of velocity looping
DVEL=1;% Shift velocity
NROOT=7; % No of bisections for given mode
NMOD=5;% Maximum modes to find
% Performing the visualization of the velocity structure
[par_vel, par_dpt,maxdepth]=plot_profile(NN,VS,H);
figure2=figure('NumberTitle','off','Name','Visualization of the Profile 3: Irregular Having HVL');
profile=plot(par_vel,par_dpt,'r-','LineWidth',1);
set(gca,'XAxisLocation','top','YDir','reverse');
xlabel('Shear-wave velocity (m/s)');
ylabel('Depth (m)');
set(gca,'XLim',[0 max(VS)+100],'YLim',[0 maxdepth]);

% Runing the function of ForLoveDcs.m
[LoveDCs]=ForLoveDcs(NN,VS,RHO,H,ISFREQ,IEFREQ,DFREQ,MINVEL,MAXVEL,DVEL,NROOT,NMOD);

% Ploting the multimode Love wave dispesion curves
figure1=figure('NumberTitle','off','Name','Profile 3: Irregullar Having HVL');
axes1=axes('Parent',figure1);
box(axes1,'on');hold(axes1,'on');
[MS,NS]=size(LoveDCs);
for p=1:NS
    plt=plot(ISFREQ:IEFREQ,LoveDCs(:,p));hold on
    title('Multimode Love Wave Dispersion Curves of Profile 3')
    xlabel('Frequency [Hz]')
    ylabel('Phase velocity [m/s]');
end
% Create legend
legend1=legend(axes1,'show');
set(legend1,'FontSize',9);

% Calculating the cut-off frequencies
peak_vel=zeros(1,NS);fid_peak=zeros(1,NS);cut_freq=zeros(1,NS);
freqs=ISFREQ:IEFREQ;
for d=1:NS
    peak_vel(d)=max(LoveDCs(:,d));
    fid_peak(d)=find(LoveDCs(:,d)==peak_vel(d));
    cut_freq(d)=freqs(fid_peak(d));
end
disp('The cut-off frequencies (in Hz):');disp(cut_freq);

% Calculating an average of the cut-off frequency
average_cut_freq=sum(diff(cut_freq))/(NS-1);
disp('Average of cut-off frequencies (in Hz):');disp(average_cut_freq);
