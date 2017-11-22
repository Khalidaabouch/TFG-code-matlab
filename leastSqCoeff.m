function [a,sa,redchisqr,norm_covmat] = leastSqCoeff(A,b,tol)

    [N M] = size(A);        % size of design matrix (row X column)
    [U,S,V] = svd(A,0);     % SVD of design matrix
    w=diag(S);              % Get singular values
    wmin=max(w)*tol;        % find minimum s.v. permissable
    for i=1:M               % and invert diagonal
        if w(i) > wmin
            w(i)=1/w(i);
        else
            w(i)=0;
        end
    end
    W=diag(w);                          % and remake matrix
    a=V*W*(U'*b);                       % your coefficients!
    Covmat = V*W.^2*V';                 % compute covariance matrix        
    redchisqr = sum((A*a-b).^2)/(N-M);  % compute reduced chi squared
    Covmat = redchisqr*Covmat; 
    norm_covmat=nan(size(Covmat));
    dd = diag(Covmat);
    for i=1:size(Covmat,1)
        for j=1:size(Covmat,2)
            norm_covmat(i,j) = Covmat(i,j)/sqrt(dd(i)*dd(j));
        end
    end
    sa = sqrt(diag(Covmat));            % uncertainties in coefficients