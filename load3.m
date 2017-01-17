function [gender]=load3(filename)

%% Initialize variables.
delimiter = ',';
startRow = 2;

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%*q%q%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));


%% Split data into numeric and cell columns.
rawNumericColumns = {};
rawCellColumns = raw(:, 1);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
gender = rawCellColumns(:, 1);


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawNumericColumns rawCellColumns R;