function [Y2]=layer_iteration(PV,W,VS,H,MYU,NN)
R=W/PV;% Wave number included in equatin (11)
if (R>(W/VS(1)))
    V=sqrt(R^2-(W/VS(1))^2); % See equation (17)
else
    V=sqrt((W/VS(1))^2-R^2); % See equation (11)
end
Y1=1.0;% See equation (18)
Y2=MYU(1)*V;% See equation (18)
for I=2:NN
    V2=R^2-(W/VS(I))^2;
    V=sqrt(abs(V2))*H(I);% See equation (17)
    if (V2>0)
        C1=cosh(V);
        C2=sinh(V)/V;
    else
        C1=cos(V);
        C2=sin(V)/V;
    end
    % See the matrix equation (21) called Haskell layer matrix 
	Q11=C1;
	Q12=(H(I)/MYU(I))*C2;
	Q21=(MYU(I)/H(I))*V2*H(I)^2*C2;
	Q22=C1;
	SUM1=Q11*Y1+Q12*Y2;
	SUM2=Q21*Y1+Q22*Y2;
	Y1=SUM1;
	Y2=SUM2;
end
% clear all
