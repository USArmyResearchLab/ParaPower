F=fieldnames(handles)

Hlist=[];
for I=1:length(F)
    H=getfield(handles,F{I});
    disp(['Checking ' F{I} '...'])
    for J=1:length(H)
        if ishandle(H(J))
            Hlist(end+1)=H(J);
        end
    end
end
Hlist=Hlist(Hlist~=0);
for K=1:length(Hlist)
  F=fieldnames(get(Hlist(K)));
  CB=find(strcmpi(F,'callback'));
  CR=find(strcmpi(F,'createfcn'));
  DL=find(strcmpi(F,'deletefcn'));
  if ~isempty(CB)
      get(Hlist(K),'callback')
  end
  if ~isempty(CR)
      get(Hlist(K),'createfcn')
  end
  if ~isempty(DL)
      get(Hlist(K),'deletefcn')
  end
end
  


    
