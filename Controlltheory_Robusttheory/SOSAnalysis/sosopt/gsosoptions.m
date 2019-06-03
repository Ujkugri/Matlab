% function opt = gsosoptions(Name1,Value1,Name2,Value2,...)
%
% DESCRIPTION
%   Creates an options object for GSOSOPT 
%
% INPUTS
%   Name, Value: The options property specified by the character string
%      Name is set to Value. The setable options properties are specified
%      below.  The allowable values for each property are specified in
%      brackets with the default choice in braces.
%
%      -minobj: Minimum value of objective for bisection. [{-1e3}]
%      -maxobj: Maximum value of objective for bisection. [{1e3}]
%      -absbistol: Absolute bisection stopping tolerance [{1e-3}]
%      -relbistol: Relative bisection stopping tolerance [{1e-3}]
%      -display: Display bisection iteration information. Display
%         information generated by the optimization solver is not affected
%         by this option ['on',{'off'}]
%      -All options included in an SOSOPTIONS object are also included
%         in a GSOSOPTIONS object.  See SOSOPTIONS for more details.
%
% OUTPUT
%   opt: gsosoptions object
%
% SYNTAX
%   opt = gsosoptions
%     Creates an gsosoptions object initialized with default values.
%   opt = gsosoptions(Name1,Value1,Name2,Value2,...)
%     Creates an gsosoptions object with options specified by Name set
%     to the values specified by Value.
%
% See also gsosopt, sosopt, sosoptions

% 11/2/2010 PJS  Initial Coding

classdef gsosoptions < sosoptions
    
    properties        
        minobj = -1e3;
        maxobj = 1e3;
        absbistol = 1e-3;
        relbistol = 1e-3;
        display = 'off';
    end
    
    methods
        % Constructor
        function opt = gsosoptions(varargin)
            % Check # of input args
            nin = nargin;
            if ceil(nin/2)~=floor(nin/2)
                errstr1 = 'GSOSOPTIONS must have an even number of inputs';
                errstr2 = ' with Name/Value pairs specified together.';
                error([errstr1 errstr2]);
            end
            
            % Set Name/Value pairs: 
            % Rely on default error if Name is not a public property
            for i1=1:(nin/2)
                Name = varargin{2*(i1-1)+1};
                Value = varargin{2*i1};
                opt.(Name) = Value;
            end
        end

        % Set: minobj
        function opt = set.minobj(opt,value)
            if isa(value,'double') && any(size(value)==1)
                opt.minobj = value;
            else
                error('minobj must be a double scalar or vector.');
            end
        end
        
        % Set: maxobj
        function opt = set.maxobj(opt,value)
            if isa(value,'double') && any(size(value)==1)
                opt.maxobj = value;
            else
                error('maxobj must be a double scalar or vector.');
            end
        end
        
        % Set: absbistol
        function opt = set.absbistol(opt,value)
            if isscalar(value) && isa(value,'double') && value>0
                opt.absbistol = value;
            else
                error('absbistol must be a positive, scalar number.');
            end
        end
        
        % Set: relbistol
        function opt = set.relbistol(opt,value)
            if isscalar(value) && isa(value,'double') && value>0
                opt.relbistol = value;
            else
                error('relbistol must be a positive, scalar number.');
            end
        end

        % Set: display
        % 'pcontain' is an undocumented display option used by PCONTAIN
        % to display the objective function g:=-t.
        function opt = set.display(opt,value)
            AllowableVal = {'on'; 'off'; 'pcontain'};
            if ischar(value) && any( strcmp(value,AllowableVal) )
                opt.display = value;
            else
                error('display can be ''on'' or ''off''. ');
            end
        end
                
    end % methods
end % classdef