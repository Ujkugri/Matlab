function [nStates,nInputs,nOutputs,nUncertain] = getdims(wcsys)

nStates  = wcsys.NStates;
nInputs  = wcsys.NInputs;
nOutputs = wcsys.NOutputs;
nUncertain = wcsys.NUncertain;