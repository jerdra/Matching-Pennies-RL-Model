%% Generate RL parameter plots for different groupings
clear;
%Load in dataset 
parentfolder= '';
cd(parentfolder)

[fn, pn] = uigetfile('*.mat','Locate the Table file!!!!!!');
load ([pn fn]);
%load('WRLPTableDae.mat');  

%Select response modality type
T = saveTable(saveTable.EOB == 1,:); 

%Clean table of crappy weight subjects (probably horrible fits...) 
%20 is an arbitrary cut-off, need to check whether bad weights = bad fits!
badSub = T.SUBJECT(T.REWARDWGT < -20| T.LOSSWGT < -20,1); 
T(ismember(T.SUBJECT,badSub),:) = [];
%c_headers = saveTable.Properties.VariableNames; 
%c_headers(end-1:end) = {'REWARDWGT','LOSSWGT'}; 
%T.Properties.VariableNames = c_headers;

%Generate groups 
ctrl = T(T.GROUP == 2,:); 
PD_off = T(T.GROUP == 3 & T.MEDS == 1,:); 
PD_on = T(T.GROUP == 3 & T.MEDS == 2,:); 
bpd = T(T.GROUP == 4,:); 
yctrl_f = T(T.GROUP == 5,:); 
yctrl_m = T(T.GROUP == 6,:); 

%Create parameter vector 
d_ctrl = [ones(height(ctrl),1) ctrl.DECAY]; 
d_pd_off = [2.*ones(height(PD_off),1) PD_off.DECAY];
d_pd_on = [3.*ones(height(PD_on),1) PD_on.DECAY];
d_bpd = [4.*ones(height(bpd),1) bpd.DECAY];
d_yctrlf = [5.*ones(height(yctrl_f),1) yctrl_f.DECAY];
d_yctrlm = [6.*ones(height(yctrl_m),1) yctrl_m.DECAY];


decay = [d_ctrl;d_pd_off;d_pd_on;d_bpd;d_yctrlf; d_yctrlm]; 
mu_ctrl = median(ctrl.DECAY); 
mu_pd_off = median(PD_off.DECAY); 
mu_pd_on = median(PD_on.DECAY); 
mu_bpd = median(bpd.DECAY); 
mu_yctrlf = median(yctrl_f.DECAY);
mu_yctrlm = median(yctrl_m.DECAY);

%% Plot parameters (alpha)
figure; 
plot(decay(:,1),decay(:,2),'k.'); hold on; 
plot([1 2 3 4 5 6], [mu_ctrl mu_pd_off mu_pd_on mu_bpd mu_yctrlf mu_yctrlm],'r.','MarkerSize',12); 
xlim([0 7]); 
ylim([-0.10 1.10]); 
set(gca,'XTick',[1 2 3 4 5 6]); 
set(gca,'XTickLabel',{'Control','PD_{OFF}','PD_{ON}', 'BPD','YoungF','YoungM'}); 
set(gca,'YTick',[0:0.25:1]); 
ylabel('Alpha Weight (Decay)'); 
axis square;
box off;

%% Connect ON and OFF meds
figure;
plot(decay(:,1),decay(:,2),'k.'); hold on; 
for i = 1 : size(d_pd_off,1)
    plot([d_pd_off(i,1) d_pd_on(i,1)],[d_pd_off(i,2) d_pd_on(i,2)]); 
    hold on;
end
xlim([0 7]); 
ylim([-0.10 1.10]); 
set(gca,'XTick',[1 2 3 4]); 
set(gca,'XTickLabel',{'Control','PD_{OFF}','PD_{ON}', 'BPD','YoungF','YoungM'}); 
set(gca,'YTick',[0:0.25:1]); 
axis square;
box off;
ylabel('Decay Weight'); 

%% Weight Parameter Plot
%Create parameter sets 

 

w_ctrl = [ctrl.REWARDWGT ctrl.LOSSWGT]; 
w_pd_off = [PD_off.REWARDWGT PD_off.LOSSWGT]; 
w_pd_on = [PD_on.REWARDWGT PD_on.LOSSWGT]; 
w_bpd = [bpd.REWARDWGT bpd.LOSSWGT]; 
w_yctrlf = [yctrl_f.REWARDWGT yctrl_f.LOSSWGT];
w_yctrlm = [yctrl_m.REWARDWGT yctrl_m.LOSSWGT];

%Create double feature plots 
figure; 
plot(w_ctrl(:,1),w_ctrl(:,2),'k.','MarkerSize',12); hold on; 
plot(w_pd_off(:,1),w_pd_off(:,2),'r.','MarkerSize',12); hold on; 
plot(w_pd_on(:,1),w_pd_on(:,2),'g.','MarkerSize',12); hold on;
plot(w_bpd(:,1), w_bpd(:,2),'b.','MarkerSize',12); hold on; 
plot(w_yctrlf(:,1), w_yctrlf(:,2),'m.','MarkerSize',12); hold on; 
plot(w_yctrlm(:,1), w_yctrlm(:,2),'c.','MarkerSize',12); hold on; 

xlabel('Reward Weight'); 
ylabel('Loss Weight'); 
xlim([-5 5]); 
ylim([-5 5]); 
ax = gca; 
set(ax,'XTick',[-5:2.5:5]); 
set(ax,'YTick',[-5:2.5:5]); 
plot(ax.XLim,[0 0],'k--'); hold on;
plot([0 0],ax.YLim,'k--'); 
axis square; 
box off;
legend('Ctrl','PD_{OFF}','PD_{ON}','BPD','YoungF','YoungM'); 

%% Parallel Coordinate Plot

p_ctrl = [d_ctrl(:,2) w_ctrl]; 
p_pd_off = [d_pd_off(:,2) w_pd_off]; 
p_pd_on = [d_pd_on(:,2) w_pd_on]; 
p_bpd = [d_bpd(:,2) w_bpd]; 

figure;
parallelcoords(p_ctrl,'LineWidth',1.5); hold on;
parallelcoords(p_pd_off,'Color','r','LineWidth',1.5); hold on; 
parallelcoords(p_pd_on,'Color','g','LineWidth',1.5);
parallelcoords(p_bpd,'Color','b','LineWidth',1.5); 

%% Explore PD meds effect
m_pd = d_pd_on(:,1) - d_pd_off(:,2); 
figure;
plot(ones(length(m_pd),1),m_pd,'k.'); hold on; 
plot(mean(m_pd),'r.','MarkerSize',12); 
ylim([1.5 3.5]);
xlim([0 2]); 
ylabel('Alpha Difference'); 
axis square;
box off;



