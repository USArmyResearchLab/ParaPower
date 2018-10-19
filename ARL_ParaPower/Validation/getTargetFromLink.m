function [target,aserver] = getTargetFromLink(lnkFile,aserver)
% Extract the target of a Windows shell link shortcut (LNK)
%
% SYNTAX:
% target = getTargetFromLink(lnkFile)
%     Creates the requisite actxserver, extracts the target
% [target,aserver] = getTargetFromLink(lnkFile)
%     Also passes out a handle to the Activex server object
% [target,...] = getTargetFromLink(lnkFile,aserver)
%     Allows optional passing in of Activex server object.
%     (If you are calling getTargetFromLink many times, it
%     can be faster to create the Activex server object,
%     aserver, one time, and pass it in.
%
% EXAMPLES:
% Example 1: Get a single target
%
%     links = dir('*.lnk');
%     target = getTargetFromLink(links(1).name)
%
% Example 2: Get many targets, re-using the asvr (optional)
% 
%     links = dir('*.lnk');
%     target = cell(numel(links),1);
%     [target{1},asvr] = getTargetFromLink(links(1).name);
%     for ii = 2:numel(links)-1
%        target{ii} = getTargetFromLink(links(ii).name,asvr);
%     end
% 
% Example 3: To get the link to a file not in the current
%    directory, specify the fullfile to the link:
% 
%    links = dir('c:\myLinks\*.lnk');
%    target = getTargetFromLink(fullfile('c:\myLinks',links(1).name))
%
% NOTES: To create links, file createLinks (available on the
%       MATLAB Central File Exchange) might be useful.
%
% Written by Brett Shoelson, PhD
% brett.shoelson@mathworks.com
% 
% Thanks to Jiro Doke, PhD. for his assistance.
%
% Copyright 2012 MathWorks, Inc.
%
% See Also: createLinks
if nargin < 2
    aserver = actxserver('WScript.Shell');
end
tmp = aserver.CreateShortcut(lnkFile);
target = tmp.TargetPath;