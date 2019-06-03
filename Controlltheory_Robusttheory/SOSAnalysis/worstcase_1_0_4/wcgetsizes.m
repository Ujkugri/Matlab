function [nStates,nInputs,nOutputs] = wcgetsizes(mySystem)

if isa(mySystem,'polysys')
  nStates = length( mySystem.states );
  nInputs = length( mySystem.inputs );
  nOutputs = size( mySystem.orMap, 1 );
else
  if ischar(mySystem)
      sizeInfo = feval(mySystem,[],[],[],'sizes');
  elseif strncmpi(class(mySystem),'func',4);
      sizeInfo = feval(mySystem,[],[],[],0);
  else
      error('Invalid system type')
  end

  nStates  = sizeInfo(1);  % Number of continuous states
  nOutputs = sizeInfo(3);  % Number of outputs
  nInputs  = sizeInfo(4);  % Number of inputs
end
