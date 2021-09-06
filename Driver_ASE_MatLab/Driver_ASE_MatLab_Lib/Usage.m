function Usage(NumOfInputParms,ParaNumLow,ParaNumHigh,HelpInfo)
%print out help info for a function and its requested parameters;
%NumOfInputParms can be determined by nargin;
%ParaNumLow and ParaNumHigh will the numeric range of vars allowed as input;
%which is like that of narginchk.
%HelpInfo will be strings that will be print out when the NumOfInputParms
%not located in the above range;

%Demo:
%check the number of input variables;
%Usage(nargin,2,3,...
%'\nRequired parameters for the function:\n(1) cancer_type\n(2) feature_rgx\n(3) FDR_cutoff (optional, default is 0.2)\n\n');



if (NumOfInputParms<ParaNumLow || NumOfInputParms>ParaNumHigh)
    %use fprintf to print \n as newline;
    %disp can not do this!
    fprintf(HelpInfo)
    error('The function requires to be run as above!');
end
