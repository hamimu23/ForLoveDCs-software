function [par_vel, par_dpt,maxdepth]=plot_profile(NN,VS,H)
par_vel=zeros(1,2*NN);
thk=zeros(1,NN);
for k=1:length(par_vel)
    par_vel(k)=VS(round(k/2));
end
for j=2:NN
    thk(1)=0;
    thk(j)=thk(j-1)+H(j);
end
depth=thk(2:NN);
par_thk=zeros(1,2*length(depth));
for t=1:2*length(depth)
    par_thk(t)=depth(round(t/2));
end
maxdepth=max(par_thk)+0.5*max(par_thk);
par_dpt=[0 par_thk maxdepth];
