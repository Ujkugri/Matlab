function twoNorm = get2norm(y,t)

sizeY = size(y);

%% Transform vector signal to scalar signal
if ndims(y) == 3 
    if sizeY(1) > 1 || sizeY(2) > 1
        % y is a vector signal, so we must create a scalar signal v
        for j = 1:sizeY(3)
            v(j,1) = sqrt( y(:,1,j)'*y(:,1,j) );
        end
    else
        v = squeeze(y);
    end
elseif ndims(y) == 2 
    if sizeY(2) > 1
        % y is a column vector of states 
        for j = 1:sizeY(1)
            v(j,1) = sqrt( y(j,:)*y(j,:)' );
        end
    else
        v = y;
    end
end
t = squeeze(t);

%% Compute L2-norm
dv = diff(v); % dv(k) = v(k+1) - v(k)
dt = diff(t); % dt(k) = t(k+1) - t(k)

for k = 1:length(v)-1
    S(k) = dt(k) * ( v(k)^2 + dv(k)*v(k) + (dv(k)^2)/3 );
end
    
twoNorm = sqrt( sum(S) );