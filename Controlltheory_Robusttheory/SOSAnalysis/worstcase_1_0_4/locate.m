function varargout = locate(t,tVec,varargin)
% LOCATE  Finds the value of a time-dependent vector at an arbitrary time
%  using linear interpolation.
%
%  [QI1,QI2,...,QIN] = LOCATE(TI,T,Q1,Q2,...,QN)  Given the signals Q1,..QN,
%  specified at the time points in T, LOCATE linearly interpolates to find
%  the values QI1,...QIN at time TI.  The signals may be 2D or 3D arrays.
%
%  Scalar and vector signals: If an input signal Q is 2D, the vector Q(k,:)
%  corresponds to the kth point in time T(k).  The interpolated value QI
%  will have the same dimensions as Q(k,:) (scalar or row-vector).
%
%  Array of matrices: If an input signal Q is 3D, the matrix Q(:,:,k) 
%  corresponds to the kth point in time T(k).  The interpolated value QI
%  will hav ethe same dimensions as Q(:,:,k).

nVectors = nargin-2;
if nVectors ~= nargout
    error(['Must specify an output for each input vector to be interpolated'])
end

if t < tVec(1)
%% Return the first value
    for j = 1:nVectors
        qVec = varargin{j};
        if ndims(qVec) == 2
            q = qVec(1,:);
        else
            q = qVec(:,:,1);
        end
        varargout{j} = q;
    end
elseif tVec(end) < t
%% Return the final value
    for j = 1:nVectors
        qVec = varargin{j};
        if ndims(qVec) == 2
            q = qVec(end,:);
        else
            q = qVec(:,:,end);
        end
        varargout{j} = q;
    end
else
%% Interpolate to find value
    % Find the index of the first time greater than t.
    % In an ordered row vector, it would be on the right.
    rightIndex = 0;
    for i = 1:length(tVec)
        if t < tVec(i)
            rightIndex = i;
            break;
        end
    end
    if rightIndex == 0
        rightIndex = length(tVec);
    end
    leftIndex = rightIndex-1;

    % Get values on each side of t
    tRight = tVec(rightIndex);
    tLeft  = tVec(leftIndex);

    for j = 1:nVectors

        qVec = varargin{j};
        if ndims(qVec) == 2
            qRight = qVec(rightIndex,:);
            qLeft  = qVec(leftIndex,:);
        else
            qRight = qVec(:,:,rightIndex);
            qLeft  = qVec(:,:,leftIndex);
        end

        q = zeros(size(qLeft));
        % Linearly interpolate
        % "offset" + "change in q" * "fraction of change"
        q = qLeft + (qRight-qLeft) * (t-tLeft) / (tRight-tLeft);
        varargout{j} = q;

    end

end
