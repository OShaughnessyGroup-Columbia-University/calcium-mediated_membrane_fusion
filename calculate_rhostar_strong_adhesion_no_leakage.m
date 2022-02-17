function[rhostar,tension,Aflat,theta,A,Aves]=calculate_rhostar_strong_adhesion(gamma0,kdelta,kbar,Aves0,Ahd,epsiloncat,Wvv,volume)

%Aves0=Aves;

thetaguess=[0:pi/2/1000:pi/2];
f=zeros(length(thetaguess),1);
Aguess=zeros(length(thetaguess),1);
Rguess=zeros(length(thetaguess),1);
gammaguess=zeros(length(thetaguess),1);
thetacheck=zeros(length(thetaguess),1);
h=zeros(length(thetaguess),1);

R0= (Aves0 / (4*pi))^.5;

%volume=4/3*pi*R0^3;

for i=1:length(thetaguess)
   
   f(i)= .5 + .75* cos(thetaguess(i)) -.25 * (cos(thetaguess(i)))^3;
   Rguess(i)=(3*volume/(4*pi*f(i))^(1/3); 
   Aguess(i)= pi * (Rguess(i))^2 * ( 2*(1+cos(thetaguess(i))) + (sin(thetaguess(i)))^2 );
   gammaguess(i)= gamma0 + kbar /2 * ( (Aguess(i) - Ahd/2)/Aves0 - 1);
   thetacheck(i)= acos(1-Wvv/(2*gammaguess(i)));
   h(i)=thetacheck(i)-thetaguess(i);
end



[p,n]=min(abs(h));
R=Rguess(n);
A=Aguess(n);
theta=thetaguess(n);


tension=gamma0 + kbar / 2 * ( (A - Ahd/2)/Aves0 - 1);
Aflat= pi * (R.*sin(theta)).^2;
rhostar= tension * (cos(theta)-.5)/kdelta + epsiloncat;
Aves=A-Ahd;

