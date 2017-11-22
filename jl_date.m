function [jlDate,jlDays] = jl_date(dateVec)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% This function takes a vector of dates and derives Julian Date out of it.
% This function is different from Matlab's built-in function in the sense
% that it gives yyyyddd where yyyy is the year and ddd is the day out of
% 365 (or 366 for leap years). Input: dateVec: string or numeric dates in
% Matlab's date format,
%   it can be a single date or a vector of dates.
% Output: jlDate:: Julian Date (yyyyddd)
%    jlDays: Julian Days (ddd)
% Email: sohrabinia.m@gmail.com
  str2double(dateVec);
 % dateVec
%[yrs,mnths,dys]=ymd(dateVec);
 yrs    = year(dateVec);
 mnths  = month(dateVec);
 dys    = day(dateVec);
times1 =datenum(dateVec)-floor(datenum(dateVec));
for i=1:length(yrs)
    yr=yrs(i);
    mnth=mnths(i);
    dy=dys(i);
%     if leapyear(yr)==0
         yrDays=365;
        dMonths = [31;28;31;30;31;30;31;31;30;31;30;31];
%     else
%         yrDays=366;
%         dMonths = [31;29;31;30;31;30;31;31;30;31;30;31];
%     end
    for j=1:mnth-1
        dy=dy+dMonths(j); %Julian day
    end
    jlDays(i)=dy;
    jlDate(i)=yr*1000+dy+times1(i);
end
jlDays=jlDays';
jlDate=jlDate';
end %function end

