% NOTE THIS ONE WAS MODIFIED SPECIFICALLY TO TRY TO EXPLAIN RAND AND REESE
% DOPS EXPERIMENTS

clear workspace

%stratton area
%sigmacves=127;
%sigmachd=27;
% end stratton area


% simulation parameters 

%for november 2010 calcs used tau = 1e-3, maxtime=50
% these variables filled in by all_run.m for loop
%tau=1e-3;
maxtime=60.0;
m=maxtime/tau;
% physical parameters

%Aves0=Aves1;
Aevans=1200;
sigmadelta=4;
% sigmac=102;
% sigmacves=102;
% sigmachd=102;
%sigmac=126;


%  PC:PS:PE (nikolaus et al)
% sigmachd=109;
% sigmacves=136;


% pure DOPS

% sigmachd=27.49;
% sigmacves=129.3;

% % 
% DOPS:DOPE 1:1

% sigmachd=79;
% sigmacves=180;

% DOPS:DOPE 1:3

% sigmachd=139; 
% sigmacves=218;

% general

% sigmachd=26.9;
% sigmacves=127.0;



% PC/PS/PE



%sigmac=1.09*102;
%sigmac=1.7*102;

v0delta=0.22;
Eheal=0;
rvesstar=v0delta*exp(Eheal);
vdeltac=3e6;

%  phys property inputs from HD calculations, will be called in eventually

interpolate_all
m=length(t)-1;

%  set initial survival S matrix

S=zeros(4,m+1);
S(1,1)=1;
S(3,1)=1;

% set initial lysis, fusion, hemifusion matrices

L=zeros(1,m+1);
F=zeros(1,m+1);
H=ones(1,m+1);

% set diagonal ones matrix 

diagonal=zeros(4,4);
diagonal(1,1)=1;
diagonal(2,2)=1;
diagonal(3,3)=1;
diagonal(4,4)=1;

%outer loop will be here

for k=1:m


    
Sves0=S(1,k);
Svesstar=S(2,k);
Shd0=S(3,k);
Shdstar=S(4,k);




% first calculate coefficients


kvesstar=2*Aves(k)/Aevans*v0delta*exp(gamma(k)/sigmadelta);
khdstar=Ahd(k)/Aevans*v0delta*exp(gammahd(k)/sigmadelta);

kvesrup=vdeltac*(gamma(k)/sigmacves)^.5*exp(-sigmacves/gamma(k));
khdrup=vdeltac*(gammahd(k)/sigmachd)^.5*exp(-sigmachd/gammahd(k));

rvesstar=v0delta;
rhdstar=v0delta;


% fill in coefficient matrix B

B=zeros(4,4);

B(1,1)=-kvesstar;
B(1,2)=rvesstar;
B(1,4)=-Sves0/(Sves0+Svesstar)*khdrup;

B(2,1)=kvesstar;
B(2,2)=-rvesstar-kvesrup;
B(2,4)=-Svesstar/(Sves0+Svesstar)*khdrup;

B(3,2)=-Shd0/(Shd0+Shdstar)*kvesrup;
B(3,3)=-khdstar;
B(3,4)=rhdstar;

B(4,2)=-Shdstar/(Shd0+Shdstar)*kvesrup;
B(4,3)=+khdstar;
B(4,4)=-rhdstar-khdrup;


% solve for new column of S values, S(:,k+1)

Btwiddle=diagonal-B*tau/2;
S(:,k+1)=inv(Btwiddle)*((diagonal+B*tau/2)*S(:,k));

L(k+1)=L(k)+ kvesrup*0.5*(S(2,k)+S(2,k+1))*tau;
F(k+1)=F(k)+ khdrup*0.5*(S(4,k)+S(4,k+1))*tau;
H(k+1)=1-L(k+1)-F(k+1);
pfus(k+1)=(F(k+1)-F(k))/tau;
plys(k+1)=(L(k+1)-L(k))/tau;
t(k+1)=k*tau;

end  %end for k loop



deadendfraction=H(m)
fusionfraction=F(m)
lysisfraction=L(m)
Tfusion=sum(t.*pfus)*tau
Tlysis=sum(t.*plys)*tau

kinetics_matrix(:,1)=t';
kinetics_matrix(:,2)=H';
kinetics_matrix(:,3)=F';
kinetics_matrix(:,4)=L';
kinetics_matrix(:,5)=pfus';
kinetics_matrix(:,6)=plys';

final_matrix(:,1)=deadendfraction;
final_matrix(:,2)=fusionfraction;
final_matrix(:,3)=lysisfraction;
final_matrix(:,4)=Tfusion;
final_matrix(:,5)=Tlysis;

final_matrix=final_matrix';

%plot(t,F,'r',t,L,'g')
%plot(t,pfus,t,plys*(.1))
