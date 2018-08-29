function [] = resultplot(toggles,Master,rx,TempMaster,StressMaster,solnum,viewall,plotname,highlightsol,resultsmaster)
% toggles,solnum,viewall,plotname,highlightsol
% pause
[rm,~]=size(Master);
trials=rm/rx;
boardsize=zeros(trials,2);
R1=1;
R2=rx;
txtsize=8;
tempmarkersize=20;
stressmarkersize=7;
% Board Area Vs T/S
if strcmp(plotname,'Board Area Vs T/S')==1
for i=1:trials
tempmaster=Master(R1:R2,:);
% pause
baselayers=find(Master(R1:R2,8)==0);
    minX=min(min(tempmaster(baselayers,1:4)));
    maxX=max(max(tempmaster(baselayers,1:4)));
    minY=min(min(tempmaster(baselayers,10:13)));
    maxY=max(max(tempmaster(baselayers,10:13)));
% maxX=max(max(tempmaster(:,1:4)));                                % finds max and mins of both X and Y coordinates
% minX=min(min(tempmaster(:,1:4)));                                
% maxY=max(max(tempmaster(:,10:13)));
% minY=min(min(tempmaster(:,10:13)));
boardsize(i,1)=maxX-minX;
boardsize(i,2)=maxY-minY;
R1=R1+rx;
R2=R2+rx;
end
boardarea=boardsize(:,1).*boardsize(:,2);
xdata=boardarea;
% %    minx=min(boardarea(:));
% %    maxx=max(boardarea(:));
% %    mintemp=min(TempMaster(:));
% %    maxtemp=max(TempMaster(:));
% %    minstress=min(StressMaster(:));
% %    maxstress=max(StressMaster(:));
xlabel('Board Size (m^{2})','FontSize',8);
% Trial # Vs T/S
elseif strcmp(plotname,'Trial # Vs T/S')==1
    xdata=(1:trials)';
    xlabel('Solution Number','FontSize',8);
    
elseif strcmp(plotname,'Transient')==1
%     resultsmaster
%     pause
    xdata=resultsmaster(:,3);
    xlabel('Time (sec)')
end

hold on
view(2)
yyaxis left
ylabel('Device Max Temperature (^{o}C)','FontSize',8);
yyaxis right
ylabel('Von Mises Stress (Pa)','FontSize',8);

% Device Text Numbering
ii=1;
txt=cell(length(StressMaster),1);
if strcmp(plotname,'Transient')==1
    [rr,~]=size(resultsmaster);
    trialstart=resultsmaster(1,3);
    idx=find(trialstart==resultsmaster(:,3));
    [tr,~]=size(idx);
    steps=rr/tr;
    R2=0;
    for i=1:tr
        for ii=1:steps
         txt{ii+R2,1}=num2str(i);
        end
         R2=R2+steps;
    end
else
   for i=1:length(TempMaster)
    txt{i,1}=num2str(i);                                                     % defines the device number
    ii=ii+3;                                                                    % itterate to the next device's coordinates
   end
end
axis tight   

% if viewall==0&&toggles==0 || minstress==maxstress
%     axis tight
% else
% xlim([minx-(minx/10),maxx+(maxx/10)]);   
% yyaxis right 
% ylim([minstress,maxstress]);
% yyaxis left
% ylim([mintemp,maxtemp]);
% end 
if toggles==1
    gca;
for i=1:trials
    if i>1 && solnum~=1
       delete(hh1); 
       delete(hh2);
    end
     if i==solnum && highlightsol==1
         scale=20;
         if strcmp(plotname,'Transient')==1    
            R1=((solnum-1)*steps)+1;
%             for ii=1:steps
            yyaxis left
            plot(xdata(:,1),TempMaster(:,1))%,'c.','markers',tempmarkersize+scale)
            text(xdata(:,1),TempMaster(:,1),txt(:,1),'FontSize',txtsize+scale/4)
            yyaxis right
            plot(xdata(:,1),StressMaster(:,1),'ro','markers',stressmarkersize+scale)
            text(xdata(:,1),StressMaster(:,1),txt(:,1),'FontSize',txtsize+scale/4)
            pause(0.3)
            R1=R1+1;
%             end
         else
        plot(xdata(i,1),TempMaster(i,1),'c.','markers',tempmarkersize+scale)
        text(xdata(i,1),TempMaster(i,1),txt(i,1),'FontSize',txtsize+scale/4);
        plot(xdata(i,1),StressMaster(i,1),'ro','markers',stressmarkersize+scale)
        text(xdata(i,1),StressMaster(i,1),txt(i,1),'FontSize',txtsize+scale/4);
         end
     else
         if strcmp(plotname,'Transient')==1
            R1=((i-1)*steps)+1;
%             for ii=1:steps
            yyaxis left
            plot(xdata(R1,1),TempMaster(R1,1),'c.','markers',tempmarkersize)
            hh1=text(xdata(R1,1),TempMaster(R1,1),txt(R1,1),'FontSize',txtsize);
            yyaxis right
            plot(xdata(R1,1),StressMaster(R1,1),'ro','markers',stressmarkersize)
            hh2=text(xdata(R1,1),StressMaster(R1,1),txt(R1,1),'FontSize',txtsize);
            pause(0.3)
            R1=R1+1;
%              end
         else
            yyaxis left
            plot(xdata(i,1),TempMaster(i,1),'c.','markers',tempmarkersize)
            hh1= text(xdata(i,1),TempMaster(i,1),txt(i,1),'FontSize',txtsize);
            yyaxis right
            plot(xdata(i,1),StressMaster(i,1),'ro','markers',stressmarkersize)
            hh2=text(xdata(i,1),StressMaster(i,1),txt(i,1),'FontSize',txtsize);
            pause(0.1)
         end
    end
end
elseif viewall==1 
    if highlightsol==1
        scale=20;
    else
        scale=0;
    end
            if strcmp(plotname,'Transient')==1   
            R1=((solnum-1)*steps)+1;
            R2=solnum*steps;
%             for ii=1:steps
            yyaxis left
            plot(xdata(1:R1-1,1),TempMaster(1:R1-1,1),'c.','markers',tempmarkersize)
            text(xdata(1:R1-1,1),TempMaster(1:R1-1,1),txt(1:R1-1,1),'FontSize',txtsize)
            plot(xdata(R1:R2,1),TempMaster(R1:R2,1),'c.','markers',tempmarkersize+scale)
            text(xdata(R1:R2,1),TempMaster(R1:R2,1),txt(R1:R2,1),'FontSize',txtsize+scale/4)
            plot(xdata(R2+1:end,1),TempMaster(R2+1:end,1),'c.','markers',tempmarkersize)
            text(xdata(R2+1:end,1),TempMaster(R2+1:end,1),txt(R2+1:end,1),'FontSize',txtsize)
            yyaxis right
            plot(xdata(1:R1-1,1),StressMaster(1:R1-1,1),'ro','markers',stressmarkersize)
            text(xdata(1:R1-1,1),StressMaster(1:R1-1,1),txt(1:R1-1,1),'FontSize',txtsize)
            plot(xdata(R1:R2,1),StressMaster(R1:R2,1),'ro','markers',stressmarkersize+scale)
            text(xdata(R1:R2,1),StressMaster(R1:R2,1),txt(R1:R2,1),'FontSize',txtsize+scale/4)
            plot(xdata(R2+1:end,1),StressMaster(R2+1:end,1),'ro','markers',stressmarkersize)
            text(xdata(R2+1:end,1),StressMaster(R2+1:end,1),txt(R2+1:end,1),'FontSize',txtsize)
            pause(0.3)
%             end
            else
yyaxis left
plot(xdata(1:solnum-1),TempMaster(1:solnum-1),'c.','markers',tempmarkersize)
text(xdata(1:solnum-1),TempMaster(1:solnum-1),txt(1:solnum-1),'FontSize',txtsize)
plot(xdata(solnum),TempMaster(solnum),'c.','markers',tempmarkersize+scale)
text(xdata(solnum),TempMaster(solnum),txt(solnum),'FontSize',txtsize+scale)
plot(xdata(solnum+1:end),TempMaster(solnum+1:end),'c.','markers',tempmarkersize)
text(xdata(solnum+1:end),TempMaster(solnum+1:end),txt(solnum+1:end),'FontSize',txtsize)
yyaxis right
plot(xdata(1:solnum-1),StressMaster(1:solnum-1),'ro','markers',stressmarkersize)
text(xdata(1:solnum-1),StressMaster(1:solnum-1),txt(1:solnum-1),'FontSize',txtsize)
plot(xdata(solnum),StressMaster(solnum),'ro','markers',stressmarkersize+scale)
text(xdata(solnum),StressMaster(solnum),txt(solnum),'FontSize',txtsize+scale)
plot(xdata(solnum+1:end),StressMaster(solnum+1:end),'ro','markers',stressmarkersize)
text(xdata(solnum+1:end),StressMaster(solnum+1:end),txt(solnum+1:end),'FontSize',txtsize)
            end
elseif solnum>0
if strcmp(plotname,'Transient')==1    
    R1=((solnum-1)*steps)+1;
    R2=solnum*steps;
yyaxis left
plot(xdata(R1:R2,1),TempMaster(R1:R2,1),'c.','markers',tempmarkersize)
text(xdata(R1:R2,1),TempMaster(R1:R2,1),txt(R1:R2,1),'FontSize',txtsize)
yyaxis right
plot(xdata(R1:R2,1),StressMaster(R1:R2,1),'ro','markers',stressmarkersize)
text(xdata(R1:R2,1),StressMaster(R1:R2,1),txt(R1:R2,1),'FontSize',txtsize)
else
    yyaxis left
plot(xdata(solnum,1),TempMaster(solnum,1),'c.','markers',tempmarkersize)
text(xdata(solnum,1),TempMaster(solnum,1),txt(solnum,1),'FontSize',txtsize)
yyaxis right
plot(xdata(solnum,1),StressMaster(solnum,1),'ro','markers',stressmarkersize)
text(xdata(solnum,1),StressMaster(solnum,1),txt(solnum,1),'FontSize',txtsize)
end
end


 