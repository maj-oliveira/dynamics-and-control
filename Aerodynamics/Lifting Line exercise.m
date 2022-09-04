%###############################
%  High aspect ratio           #
%  planar wing design          #
%  based on Prandtl's          # 
%  Lifting Line Theory         #
%  and on Trefftz's method     #
%  for arbitrary wing loads    #
%  The quarter chord line      #
%  is assumed to be straight   #
%  and the airfoil data is     #
%  computed by means of the    #
%  2-D thin airfoil theory.    # 
%  by Prof. Dr. E. V. Volpe, Matheus Oliveira version
%############################### 
 clear all
 
 NF     = 201;                   % Fourier Modes <=> wing control stations
 tethat = linspace(0,pi,NF+2)';  % control stations in Fourier space
 tetha  = zeros(NF,1);
 tetha  = tethat(2:NF+1);
 y      = cos(tetha);            % dimensionless spanwise coordinate 
 yt     = cos(tethat);
 
%-------------------------------- 
% Flight conditions: air density and far-field speed
 Rho     = 1.0985;   
 Uoo     = 250/3.6;
 qoo     = (Rho*Uoo^2)/2;
 % root a.o.a with respect to the chord (deg) 
 alfa_sd = 2;   

 %-------------------------------- 
 % Wing geometric specifications 
 AR      = 7.0;         % aspect ratio
 b       = 10.0;        % wing-span
 lamb    = 0.6;         % taper ratio
 ltrd    = 0.0;         % linear twist rate (deg)
 % zero lift angle: alfa_os (deg)  
 % alfa_os = 0  for symmetric airfoils 
 alfa_os  =  0.0;  
 alfa_o   =  alfa_os*ones(size(y))*pi/180;  % (rad)
 % cmac: pitching moment coefficient 
 % about the local a.c.
 cmacunif  = 0.0;
 cmac      = cmacunif*ones(size(y)); 
 cmace     = cmac;      
 % the pitching moment of the elliptic wing
 % is assumed as that of the original wing, but 
 % without any twist or flap actuation. That is,
 % only the original airfoil contribution, 
 % otherwise it would not yield an elliptic 
 % wing loading.
 % Flap--aileron specifications are assumed as  
 % being symmetric with respect to the wing root.
 % flapped percent of the half-span: Kb 
 % flapped percent of the chord:     Kc
 Kb = 0.5;
 Kc = 0.2;
 thetaflap = acos(1-2*Kc);
 % flap deflection angles  (deg)
 % on the right and left sides
 % the sign convention for flap 
 % deflection here means that 
 % flap up is negative and 
 % flap down is positive
 right_delta_alfa_o = 0.0; 
 left_delta_alfa_o  = 0.0;
 % It must be born in mind, though, that
 % these formulae have been derived for
 % thin airfoils with NO CAMBER, but for
 % the effect of the flap, itself.
 % Besides, there seems to be some sort
 % of Gibbs' phenomenon that happens 
 % next to the discontinuities the 
 % flap actuations causes on the 
 % load profiles.
 r_d_a_o            = -right_delta_alfa_o*pi/180;
 l_d_a_o            = -left_delta_alfa_o*pi/180;
 Dalfa_oDdelta      = ((pi-thetaflap)+sin(thetaflap))/pi;
 DCmacDdelta        = sin(2*thetaflap)/4 - sin(thetaflap)/2;
 Crdao              = Dalfa_oDdelta*r_d_a_o;
 Cldao              = Dalfa_oDdelta*l_d_a_o;
 cmac_right         = DCmacDdelta*r_d_a_o;    
 cmac_left          = DCmacDdelta*l_d_a_o;   
                          
 %-------------------------------- 
 % wing plan-form parameters
 Yt      = b*yt/2; % dimensional spanwise coordinate  (Y=b*cos(tetha)/2)
 Y       = b*y/2;
 Sw     = (b^2)/AR;
 Cr     = 2*Sw/(b*(1+lamb));
 Ct     = lamb*Cr;
 Cmean  = b/AR;           % mean aerodynamic chord-- this is actually a simpler                         
                          % approximation, not the actual quantity which is in Etkins book 
 ltrr   = ltrd*pi/180;    % linear twist rate (rad)
 alfa_s = alfa_sd*pi/180; % root a.o.a (rad)
 
 %-------------------------------- 
 % An ELLIPTIC WING for comparison
 % it'll have the same span (b) and AR,
 % where AR = 4*b/(pi*Cre), and hence the 
 % same  Cmean = b/AR 
 Cre    = 4*b/(pi*AR); % root chord
 Swe    = pi*Cre*b/4;  % area
 Cemean = pi*Cre/4;    % mean aerodynamic chord
 Cye    = sin(tetha);  
 % Cre and b are twice the minimun and maximum 
 % parameters of the ellipsis, respectively. 
 % Chord distribution:  
 % (2*X/Cre)^2 = = 1 - (2*Y/b)^2;
 % dimensionless form:  
 % (X/Cre)  = + - sqrt((1 - (y/2)^2)/4) 
 % Cye/Cre  = 2*sqrt(1 - (cos(theta))^2)/2  = sin(tetha)
 %--------------------------------
 % twist, chord and sweep distributions
 % local geometric a.o.a, with respect to the chord 
 % Chord distribution: Cy = Cr -(Cr-Ct)*Y/0.5*b;
 % dimensionless form: (Cy/Cr) = 1 -(1-lamb)*cos(tetha);
 for k=1:NF,
 if (y(k)>=0)
       alfa_g(k) = alfa_s + ltrr*y(k);          
       Cy(k)     = 1 - (1-lamb)*cos(tetha(k)); 
    else      
       alfa_g(k) = alfa_s - ltrr*y(k);          
       Cy(k)     = 1 + (1-lamb)*cos(tetha(k));  
    end;
 end;
 alfa_g = alfa_g';
 Cyt    = [Ct,Cy*Cr,Ct];
 Cy     = Cy';
 Cyt    = Cyt';
 Xac    = (Cr/4)*ones(size(Yt)); % the quarter chord line is straight
 Xle    = Xac - Cyt/4;  
 Xte    = Xac + 3*Cyt/4;
 Xmeanc = Xle + Cmean; 
 xhinge  = NaN*ones(size(Y));
 yhinge  = xhinge;
  for k=1:NF,
    if (y(k)<= -Kb)
        xhinge(k) = Xle(k) + (1-Kc)*Cyt(k);
        yhinge(k) = Y(k);
    elseif (y(k)>= Kb)
        xhinge(k) = Xle(k) + (1-Kc)*Cyt(k);
        yhinge(k) = Y(k);        
    end;
 end;

 % Elliptic wing
 Cyet    = [0;Cye*Cre;0]; 
 Xace    = (Cre/4)*ones(size(Yt)); % the quarter chord line is straight
 Xlee    = Xace - Cyet/4; 
 Xtee    = Xace + 3*Cyet/4;
 Xmeance = Xlee + Cemean; 

 %-------------------------------- 
 % Generic thin airfoil characteristic
 ao     = 2*pi*ones(size(y));   % dcl/dalfa                                           
 for k=1:NF,
    if      (y(k)<= -Kb)
        alfa_o(k) = alfa_o(k) +  Cldao ;  
        cmac(k)   = cmac(k)   +  cmac_left;
    elseif  (y(k)>= Kb)
        alfa_o(k) = alfa_o(k) +  Crdao ;     
        cmac(k)   = cmac(k)   +  cmac_right;
    end;
 end;
 
 alfa   = alfa_g - alfa_o;  
 cmact  = [0;cmac;0];
 cmacet = [0;cmace;0];
 % Testing the code with the elliptic wing, only
 %alfa   = alfa_s*ones(size(alfa_g));
 %cmac   = cmace;
 %cmact  = cmacet;
 %Cy     = Cye;
 %Cyt    = Cyet;
 %Xac    = Xace;
 %Xle    = Xlee;
 %Xte    = Xtee;
 %Xmeanc = Xmeance;
 %Sw     = Swe;
 
 %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 % Trefftz's Method for solving Prandtl's equation in Fourier Space
 %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 
% This part is for the students to write themselves.... 






%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 %--------------------------------
 % Wing downwash, lift and induced drag 
 % coefficients distribution
 Gama            = 2*b*Uoo*Lfac;
 Gamao           = An(1)*2*b*Uoo;
 Gama_elliptic   = Gamao*sqrt(1-y.^2);
 % By hypothesis, Gama(y) goes to zero at the wing tips
 Gamat           = [0;Gama;0];
 cld             = Rho*Uoo*Gamat./(qoo*Cmean);%(qoo*Cyt);
 Gamat_elliptic  = [0;Gama_elliptic;0];
 cld_elliptic    = Rho*Uoo*Gamat_elliptic./(qoo*Cmean);
 % But the extended Gama vector is not used to evalulate 
 % the downwash velocity. Because the lifting line theory
 % yields an improper value for it at the wing tips (W=oo)  
 W               = Uoo*Wfac;
 cdid            = Rho*W.*Gama./(qoo*Cmean);%(qoo*Cy);
 W_elliptic      = Uoo*An(1)*ones(size(tetha));
 cdid_elliptic   = Rho*W_elliptic.*Gama_elliptic./(qoo*Cmean);
 cdidt           = [0;cdid;0];
 cdidt_elliptic  = [0;cdid_elliptic;0];
 %--------------------------------
 % Wing Aerodynamic Coefficients
 CL           = pi*AR*An(1);             % Lift Coefficient
 CDi_elliptic = CL^2/(pi*AR);            % the elliptic wing Lift is 
                                         % the same as that of the 
                                         % actual wing, because Gamao
                                         % has been picked so as to ensure
                                         % that equivalence 
 CDi          = CDi_elliptic*Difac;      % Induced Drag Coefficient
 CMr          = -pi*An(2)*(AR^2)/4;      % Rolling Moment Coefficient
 CMy          =  pi*(AR^2)*Myfac/4;      % Yawing Moment Coefficient
 % Pitching Moment Coefficient CMp and 
 % Wing Aerodynamic Center XAC 
 % Both quantities are evaluated with respect 
 % the Y axis, with origin at the root 
 % leading edge point. 
 L      =   CL*qoo*Sw;
 fxac   =   cld.*Cyt.*Xac;
 fyac   =   cld.*Cyt.*Yt;
 fxace  =   cld_elliptic.*Cyet.*Xace;
 faux   =   cld.*Cyt;
 fcmrl  = - (fxac + cmact.*(Cyt.^2))/(b*Cmean^2);
 fcmrle = - (fxace + cmacet.*(Cyet.^2))/(b*Cemean^2);
 % Apparently there is a problem with the 
 % Matlab function trapz, in that its results
 % have flipped signs... 
 % Actually, there's no such problem.
 % It's all owed to the fact that Yt goes 
 % from negative to positive values... 
 den   = trapz(Yt,faux);
 Xacw  = trapz(Yt,fxac)/den; %(Sw*CL); %
 CMp   = trapz(Yt,fcmrl);
 CMpe  = trapz(Yt,fcmrle);
 test  = Sw*CL/den;
 % Estimating the y coordinate of 
 % the aerodynamic center of the wing half-span
 [NYt,NYc] = size(Yt);
 Nhalf     = (NYt+1)/2;
 halfden   = trapz(Yt(1:Nhalf,1),faux(1:Nhalf,1));
 Yachw     = trapz(Yt(1:Nhalf,1),fyac(1:Nhalf,1))/den;
 
 ACM          = [CL;CDi;CMr;CMy;CMp];
 ACM_elliptic = [CL;CDi_elliptic;0;0;CMpe];
 vettext      = ['Cl ';'Cdi';'Cmr';'Cmy';'Cmp'];
 ACM_T        = [ACM,ACM_elliptic];
 disp(vettext); 
 disp(ACM_T);
 % wing dCLdalpha: the Lifting Line theory gives the 
 % expression for an elliptic load (Karamcheti p.552), 
 % (eq. 19.35): aw = (1/(1+2/AR))*2*pi
 aw           = 2*pi/(1+(2/AR));   

 %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 % Figures
 %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  
 h=zeros(1,11);
 figure(1),
 subplot(3,1,1),
 h(1)  = plot(Yt,Xle,'r-');
 hold on
 h(2)  = plot(Yt,Xte,'r-');
 h(3)  = plot([-b/2,-b/2],[Xle(1),Xte(1)],'r-');
 h(4)  = plot([b/2,b/2],[Xle(NF),Xte(NF)],'r-');
 h(5)  = plot(Yt,Xac,'m--');
 h(6)  = plot(b/2,b/2,'k.');
 h(7)  = plot(Yt,Xlee,'b-');
 h(8)  = plot(Yt,Xtee,'b-');
 h(9)  = plot(Yt,Xace,'g-.'); 
 h(10) = quiver(0,-2,0,1,1);
 h(11) = plot(yhinge,xhinge,'b--');
 plot(0.0,Xacw,'mo',0.0,Xacw,'m+');
 %plot(Yt,Xmeanc,'g-.')
 grid on
 axis('normal');
 xlabel('(l)      Y       (r)')
 ylabel('X')
 title('wing plan form')
 set(h,'linewidth',1.5)

 h=zeros(1,2);
  %figure(2),
 subplot(3,1,2),
 %plot(Yt,Gamat,'r-');
 hold on
 %plot(Yt,Gamat_elliptic,'m--');
 h(1)=plot(Yt,cld,'r-');
 h(2)=plot(Yt,cld_elliptic,'m--');
 grid on
 axis('normal');
 xlabel('Y')
 ylabel('c_l')
 title('spanwise lift coefficient distribution') 
 set(h,'linewidth',1.5)

 h=zeros(1,2);
 %figure(3),
 subplot(3,1,3),
 h(1)=plot(Yt,cdidt,'b-');
 hold on
 h(2)=plot(Yt,cdidt_elliptic,'g--');
 grid on
 axis('normal');
 xlabel('Y')
 ylabel('c_{di}')
 title('spanwise induced drag coefficient distribution')
 set(h,'linewidth',1.5)

 h=zeros(1,2);
 figure(2),
% figure(4),
 subplot(3,1,1), 
 h(1)=plot(Y,W,'r-');
 hold on
 h(2)=plot(Y,W_elliptic,'m--');
 grid on
 axis('normal');
 xlabel('Y')
 ylabel('W')
 title('downwash distribution')
 set(h,'linewidth',1.5)

 h=zeros(1,1);
% figure(5),
 subplot(3,1,2),
 h(1)=plot(Yt,fcmrl,'r-');
 hold on
 grid on
 axis('normal');
 xlabel('Y')
 ylabel('c_{mrl}')
 title('pitching moment coefficient distribution')
 set(h,'linewidth',1.5)

 h=zeros(1,1);
 %figure(6),
 subplot(3,1,3),
 h(1)=plot(An,'r-o');
 hold on
 grid on
 axis('normal');
 xlabel('n')
 ylabel('An')
 title('Fourier coefficients')
 set(h,'linewidth',1.5)

 
 error('test')

% Comparison with Multhopp's results 
% for large aspect ratios, naturally. 
h = zeros(1,3);
figure(2),
h(1)=plot(cld,Yt,'r-.');
hold on
h(2)=plot(cdidt,Yt,'g-.'); 
h(3)=plot(fcmrl,Yt,'b-.');
grid on
xlabel('C_f');
ylabel('y');
title('wing loading');
legend(h,'C_l','C_{di}','C_{mp}','C_{dii}');
set(h,'linewidth',1.5)
error('test')
 
 figure(7),
 plot(Y,RHS,'r');
 hold on
 ftest=0.0;
 for k=1:NF,
    ftest = ftest + An(k)*sin(k*tetha).*( k*Mu +  sin(tetha));
 end;
 plot(Y,ftest,'b--');
 hold on
 grid on