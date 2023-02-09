function [LoveDCs]=ForLoveDcs(NN,VS,RHO,H,ISFREQ,IEFREQ,DFREQ,MINVEL,MAXVEL,DVEL,NROOT,NMOD)
if(nargin==10); NMOD=4;NROOT=6; end
MYU=RHO.*(VS.^2);% See equation (12) 
disp_curv=zeros(length(ISFREQ:IEFREQ),NMOD);% Fix the dimension of dispersion curve
wb=waitbar(0,'Please Wait...');
for F=ISFREQ:IEFREQ
    K=0.0;
    FREQ=real(F)*DFREQ;
    W=2*pi*FREQ;
    for V=MINVEL:DVEL:MAXVEL
        if (V==MINVEL); Y2A=1; end
        DDJ=1.0;
        L=0.0;
        PV=real(V);
        [Y2]=layer_iteration(PV,W,VS,H,MYU,NN);
        if (Y2*Y2A<0)
            Y2B=Y2;
            ADJ=PV-1;
            BDJ=PV;
            DDJ=DDJ/2;
            PV=PV-DDJ;
            [Y2]=layer_iteration(PV,W,VS,H,MYU,NN);
            for X=1:NROOT
                DDJ=DDJ/2;
                if(Y2*Y2A<0)
                    BDJ=PV;
                    Y2B=Y2;
                    PV=PV-DDJ;
                    L=L+1;
                    if(L==NROOT)
                        K=K+1;
                        disp_curv(F,K)=ADJ+(BDJ-ADJ)*(abs(Y2A)/(abs(Y2A)+abs(Y2B)));
                        Y2A=Y2B;
                    end
                    [Y2]=layer_iteration(PV,W,VS,H,MYU,NN);
                else
                    ADJ=PV;
                    Y2A=Y2;
                    PV=PV+DDJ;
                    L=L+1;
                    if (L==NROOT)
                        K=K+1;
                        disp_curv(F,K)=ADJ+(BDJ-ADJ)*(abs(Y2A)/(abs(Y2A)+abs(Y2B)));
                        Y2A=Y2B;
                    end
                    [Y2]=layer_iteration(PV,W,VS,H,MYU,NN);
                end
            end
        else
            Y2A=Y2;
        end
    end
    waitbar(F/IEFREQ,wb)
end
% Collecting data of the dispersion curves
DCs=disp_curv(:,1:NMOD);
ZeroDCs=find(DCs==0);
if ~isempty(ZeroDCs);DCs(ZeroDCs)=NaN; end
for D=1:NMOD
    DCs(:,D)=sort(DCs(:,D),'descend');
end
LoveDCs=DCs;


