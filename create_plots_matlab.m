clear all;
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex'); set(groot, 'defaultLegendInterpreter','latex'); set(0,'defaulttextInterpreter','latex');

%% Read in the csv files

text_comparison = csvread('text_metrics.csv');
image_comparison = csvread('thumbnail_metrics.csv');
link_comparison = csvread('Plot_data/link_measure.csv');

%% Plot image comparison

image_dates = image_comparison(:,1);
s = image_comparison(:,2);
for i = 1:length(s)
    if s(i) == -10
        s(i) = nan;
    end
end

years = zeros(size(image_dates));
months = zeros(size(image_dates));
days = zeros(size(image_dates));

for i = 1:length(image_dates)
    curr = num2str(image_dates(i));
    years(i) = str2num(curr(1:4));
    months(i) = str2num(curr(5:6));
    days(i) = str2num(curr(7:8));
end

num_days = zeros(size(image_dates));

base_date = sprintf('%02d/%02d/%i',months(1),days(1),years(1));
figure(1)
for i = 1:length(image_dates)
    curr_date = sprintf('%02d/%02d/%i',months(i),days(i),years(i));
    num_days(i) = daysact(base_date,curr_date);
end

plot(num_days,s,'MarkerSize',10,'Linewidth',2);
grid on
xlabel('Days','fontsize',14);
ylabel('Change','fontsize',14);
ylim([0 max(s)]);
title('Image comparison','fontsize',18);
set(gca,'fontsize',14);
hold on

%% Vertical lines
important_dates = ['11/28/05';'01/23/06';'10/14/08';'05/02/11';'08/22/11';'03/24/12';'10/19/15';'04/10/16';'10/01/17'];
num_days_important = daysact(base_date,important_dates);
for i = [6,length(num_days_important)]
    plot([num_days_important(i) num_days_important(i)],[0 1],'k--','Linewidth',3);
end

%% Plot text comparison

text_dates = text_comparison(:,1);

years = zeros(size(text_dates));
months = zeros(size(text_dates));
days = zeros(size(text_dates));

for i = 1:length(text_dates)
    curr = num2str(text_dates(i));
    years(i) = str2num(curr(1:4));
    months(i) = str2num(curr(5:6));
    days(i) = str2num(curr(7:8));
end

num_days_text = zeros(size(text_dates));
dates = [];
for i = 1:length(text_dates)
    curr_date = sprintf('%02d/%02d/%i',months(i),days(i),years(i));
    num_days_text(i) = daysact(base_date,curr_date);
    dates = [dates; curr_date];
end
figure(2)
last_date = '08/07/2018';
days_to_last_date = daysact(base_date,last_date);
for i = 2:5
    plot(num_days_text,text_comparison(:,i),'-','MarkerSize',10,'Linewidth',2);
    hold on
end
grid on
xlabel('Days','fontsize',14);
ylabel('Change','fontsize',14);
ylim([0 1]);
legend('Byte-wise','TF.IDF','Lebenshtein','Word distance');
set(legend,'fontsize',12);
title('Text comparison','fontsize',18);
set(gca,'fontsize',14);
set(legend,'location','northwest');

%% Vertical lines
important_dates = ['11/28/05';'01/23/06';'10/14/08';'05/02/11';'08/22/11';'03/24/12';'10/19/15';'04/10/16';'10/01/17'];
num_days_important = daysact(base_date,important_dates);
for i = [6,length(num_days_important)]
    plot([num_days_important(i) num_days_important(i)],[0 1],'k--','Linewidth',3);
end

%% Plot links comparison

link_dates = link_comparison(:,1);

years = zeros(size(link_dates));
months = zeros(size(link_dates));
days = zeros(size(link_dates));

for i = 1:length(link_dates)
    curr = num2str(link_dates(i));
    years(i) = str2num(curr(1:4));
    months(i) = str2num(curr(5:6));
    days(i) = str2num(curr(7:8));
end

num_days_links = zeros(size(link_dates));
dates = [];
for i = 1:length(link_dates)
    curr_date = sprintf('%02d/%02d/%i',months(i),days(i),years(i));
    num_days_links(i) = daysact(base_date,curr_date);
    dates = [dates; curr_date];
end
figure(3)
last_date = '08/07/2018';
days_to_last_date = daysact(base_date,last_date);
plot(num_days_links,link_comparison(:,2),'MarkerSize',10,'Linewidth',2);
grid on
xlabel('Days','fontsize',14);
ylabel('Change','fontsize',14);
ylim([0 max(link_comparison(:,2))]);
set(legend,'fontsize',12);
title('Link comparison','fontsize',18);
set(gca,'fontsize',14);
hold on

%% Vertical lines
important_dates = ['11/28/05';'01/23/06';'10/14/08';'05/02/11';'08/22/11';'03/24/12';'10/19/15';'04/10/16';'10/01/17'];
num_days_important = daysact(base_date,important_dates);
for i = [6,length(num_days_important)]
    plot([num_days_important(i) num_days_important(i)],[0 1],'k--','Linewidth',3);
end

%% Plot image, text, and link
figure(3)
txt=plot(num_days_text,text_comparison(:,5),'MarkerSize',10,'Linewidth',2);
hold on
im=plot(num_days,s,'MarkerSize',10,'Linewidth',2);
lnk=plot(num_days_links,link_comparison(:,2),'MarkerSize',10,'Linewidth',2);
grid on
xlabel('Days','fontsize',14);
ylabel('Change','fontsize',14);
ylim([0 1]);
set(legend,'fontsize',12);
title('Images, Text, and Links','fontsize',18);
set(gca,'fontsize',14);
hold on
legend([txt,im,lnk],{'Word distance','Images','Links'});
set(legend,'location','northwest')

%% Vertical lines
important_dates = ['11/28/05';'01/23/06';'10/14/08';'05/02/11';'08/22/11';'03/24/12';'10/19/15';'04/10/16';'10/01/17'];
num_days_important = daysact(base_date,important_dates);
for i = [6,length(num_days_important)]
    plot([num_days_important(i) num_days_important(i)],[0 1],'k--','Linewidth',3);
end