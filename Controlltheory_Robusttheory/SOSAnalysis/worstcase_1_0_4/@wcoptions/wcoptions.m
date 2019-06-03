function opt = wcoptions(varargin)
%WCOPTIONS  Set of options for the WORSTCASE algorithm.
%
%   OPT = WCOPTIONS()  Creates an object with the default options.
%   
%   OPT = WCOPTIONS(Name1,Value1,...,NameN,ValueN)  Create a WCOPTIONS 
%   object with options other than the defaults.  The following properties
%   can be set:
%
%     FinalCostMatrix  A positive definite matrix P, compatible with state, 
%         which defines the cost function for the 'Final' objective as x'*P*x.
%     InitialInput  A string or array specifying the first input sequence
%         used by the power algorithm.  If INITIALINPUT is a string, it must
%         be either 'rand', 'randn', or 'ones'.  The corresponding built-in
%         MATLAB function is used to generate an input vector.  If
%         INITIALINPUT is specified as an array it must be n-by-m, where n
%         is the number of points in the simulation time vector and m is the
%         number of inputs to the system.  Default is 'ones'.
%     InputL2Norm  Bound on the L2-norm of the input signal.  Default is 1.
%     MaxIter  The maximum number of iterations taken by the power algorithm.
%         The value must be a positive scalar.  Default is 20.
%     Objective  The desired output norm to be maximized.  By specifying
%        'L2' or 'LInf' the algorithm with maximize the induced L2-to-L2 or
%         L2-to-LInfinity gain, respectively.  Here, the LInfinity norm is 
%         interpreted as the maximum (over time) of the Euclidean norm of
%         the output y.  If 'Final' is selected the algorithm will maximize
%         the value of x'*P*x at the final time, where P is the matrix
%         specified in the FINALCOSTMATRIX property. Default is 'L2'.
%         Note: the OBJECTIVE must be in agreement.
%     ODEOptions  A structure of options in the format created by
%         ODESET.  The default is the output of ODESET().
%     ODESolver  A string corresponding to the desired ODE solver.  The 
%         supported solvers are 'ode45' and 'ode15s'.  Default is 'ode45'.
%     PartialsFunc  Function that returns the partial derivatives of the 
%         system function f(x,u,t) and the output function g(x,u,t).  The
%         calling syntax is [dfdx,dfdu,dgdx,dgdu] = function_name(x,u,t).
%     PerturbationSize  The partial derivatives of the system are taken
%         using a numerical algorithm that perturbs each state and each input.
%         For example, f_x(x,u,t) = ( f(x+delta,u,t)-f(x,u,t) )/delta where
%         delta is the PERTURBATIONSIZE.  Default is 1e-5.
%     PlotProgress  Specifies whether WORSTCASE should display its
%         progress.  If PLOTPROGRESS='text', the results of each iteration
%         are displayed in the Command Window.  If PLOTPROGRESS='plot', the
%         results of each iteration are displayed in a Figure.  If
%         PLOTPROGRESS='none', then nothing is displayed.  Default is 'text'
%     Tol  The WORSTCASE algorithm converges when the L2-norm of the difference
%         of two successive input signals is less than TOL.  Default is 1e-4.
%     UncertainParamRange  Bounds on uncertain parameters.  By default,
%         there are no uncertain parameters, so this property is [];  Each
%         row of UNCERTAINPARAMRANGE represents a different parameter [min,max].
%
%   After creating a WCOPTIONS object, use OPT = set(OPT,PROPERTY,VALUE) and
%   VALUE = get(OPT,PROPERTY) to change and retrieve the properties.
%
%   References:
%   J. Tierno, R. Murray, and J. C. Doyle. "An efficient algorithm for
%      performance analysis of nonlinear control systems."  Proc. of the
%      1995 American Control Conf., pp. 2717-2721.
%         
%   See also WATCHWINDOW, WORSTCASE, ODE45, ODE15S, ODESET.


% Create structure with default properties
opt.FinalCostMatrix = 1;
opt.InitialInput = 'ones';
opt.InputL2Norm = 1;
opt.MaxIter = 20;
opt.Objective = 'L2';
opt.ODEOptions = odeset;
opt.ODESolver = 'ode45';
opt.PartialsFunc = [];
opt.PerturbationSize = 1e-5;
opt.PlotProgress = 'text';
opt.Tol = 1e-4;
opt.UncertainParamRange = [];

% Create object from struct
opt = class(opt,'wcoptions');

% Set any specified properties
if length(varargin) > 0
    opt = set(opt,varargin{:});
end
