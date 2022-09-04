clear all
close all
clc
%% 1.1. Given data

E = 2.06e11; % Young modulus [N/m^2]
rho = 7800; % Density [kg/m^3]
d_B = 60e-3; % External diameter of blue beams' sections [m]
t_B = 2e-3; % Thickness of blue beams' sections [m]
d_G = 40e-3; % External diameter of green beams' sections [m]
t_G = 1.5e-3; % Thickness of green beams' sections [m]
d_R = 25e-3; % External diameter of green beams' sections [m]
t_R = 1.5e-3; % Thickness of red beams' sections [m]

% Lumped parameters in point C
Mc= 5; % Lumped mass [kg]
kc = 1e5; % Lumped stiffness [N/m]
rc = 50; % Lumped damping [N.s/m]

% Lumped stiffnesses in points A and B [N/m]
kx = 5e4;
ky = 5e4;

% Structural damping according to Rayleigh damping model
alpha = 1.5; % [s^-1]
beta = 9e-5; % [s]

fmax= 20; % Maximum frequency [Hz] 
df  = 0.01; % Frequency resolution [Hz]

%% 1.2. Maximum length of each element
% Flexural rigidity [N.m^2]
EJ_B = E*(pi/64)*(d_B^4 - (d_B - 2*t_B)^4) % Blue beams
EJ_G = E*(pi/64)*(d_G^4 - (d_G - 2*t_G)^4) % Green beams
EJ_R = E*(pi/64)*(d_R^4 - (d_R - 2*t_R)^4) % Red beams

% Axial stiffness [N]
EA_B = E*(pi/4)*(d_B^2 - (d_B - 2*t_B)^2) % Blue beams
EA_G = E*(pi/4)*(d_G^2 - (d_G - 2*t_G)^2) % Green beams
EA_R = E*(pi/4)*(d_R^2 - (d_R - 2*t_R)^2) % Red beams

% Mass per unit length [kg/m]
m_B = rho*(pi/4)*(d_B^2 - (d_B - 2*t_B)^2) % Blue beams
m_G = rho*(pi/4)*(d_G^2 - (d_G - 2*t_G)^2) % Green beams
m_R = rho*(pi/4)*(d_R^2 - (d_R - 2*t_R)^2) % Red beams

sf= 1.5; % Safety factor
Omax= sf*fmax*2*pi; % Maximum frequency [rad/s]

% Calculated maximum lengths [m]
Lm_B = sqrt(pi^2/Omax*sqrt(EJ_B/m_B)) % Blue beams
Lm_G = sqrt(pi^2/Omax*sqrt(EJ_G/m_G)) % Green beams
Lm_R = sqrt(pi^2/Omax*sqrt(EJ_R/m_R)) % Red beams

% Therefore we need to:
%       Break element ED into 2 elements
%       Break element EG into 2 elements

%% 1.3. Load input file
[file_i,xy,nnod,sizee,idb,ndof,incidenze,l,gamma,m,EA,EJ,posiz,nbeam,pr] = loadstructure;

%% 1.4. Plot undeformed structure
dis_stru(posiz,l,gamma,xy,pr,idb,ndof);
xlabel('x [m]'); ylabel('y [m]')

% Assembling of elements from .inp file 
[M,K] = assem(incidenze,l,m,EA,EJ,gamma,idb);
 
% Check IDB matrix and dof
disp('n_node  IDB-matix')
[[1:size(idb,1)]', idb]

%% 2.1. Contribution of lumped mass Mc to M
idof_mc = idb(12,2); % The lumped mass has a single dof (y)
M(idof_mc, idof_mc) = M(idof_mc, idof_mc) + Mc;

%% 2.2. Contribution of springs to K
% Due to kx for node A
idof_kxA = idb(1,1);
K(idof_kxA,idof_kxA) = K(idof_kxA,idof_kxA) + kx;

% Due to ky for node A
idof_kyA = idb(1,2);
K(idof_kyA,idof_kyA) = K(idof_kyA,idof_kyA) + ky;

% Due to kx for node B
idof_kxB = idb(11,1);
K(idof_kxB,idof_kxB) = K(idof_kxB,idof_kxB) + kx;

% Due to ky for node B
idof_kyB = idb(11,2);
K(idof_kyB,idof_kyB) = K(idof_kyB,idof_kyB) + ky;

% Due to kc for nodes C and the one corresponding to Mc
Mkc = [kc -kc; -kc kc];
idof_kc = [idb(10,2) idb(12,2)];
K(idof_kc,idof_kc) = K(idof_kc,idof_kc) + Mkc;

%% 2.3. Partitioning of matrices 
MFF = M(1:ndof,1:ndof);
KFF = K(1:ndof,1:ndof);

%% 2.4. Natural frequencies and modes of vibration
[eigenvectors, eigenvalues] = eig(MFF\KFF);
freq = sqrt(diag(eigenvalues))/2/pi;
[frqord,ind] = sort(freq);

% Number of modes to be plotted 
nmodes = 4;
i_modes = ind(1:nmodes);

% Scaling factor for visualization
scale_factor = 1; % For all plots
for ii=1:nmodes
    figure('Name',['Deformed structure - Mode shape ',num2str(ii)])
    diseg2(eigenvectors(:,i_modes(ii)),scale_factor,incidenze,l,gamma,posiz,idb,xy); % Plot deformed structure
    title(['Mode ' num2str(ii) ', Freq f_',num2str(ii),'=',num2str(frqord(ii)),' Hz'])
end

%% 3.1. Structural damping matrix
C = alpha*M + beta*K;

%% 3.2. Contribution of damper rc to C
Mrc = [rc -rc; -rc rc];
idof_rc = [idb(10,2) idb(12,2)];
C(idof_rc,idof_rc) = C(idof_rc,idof_rc) + Mrc;

CFF = C(1:ndof,1:ndof);
%% 3.3. Input force
% Vector of frequency to be defined
vett_f = 0:df:fmax;   % Frequency range of interest [Hz]
omega  = vett_f*2*pi; % [Hz]->[rad/s]

% Force vector
F0 = zeros(ndof,1); % Initialize force vector
idof_Cy = idb(10,2); % Node C in vertical direction
F0(idof_Cy) = 1; % Force acting vertically on node C

% FRF matrix
for k = 1:length(vett_f)    
    A = - omega(k)^2*MFF + sqrt(-1)*omega(k)*CFF + KFF;
    xx(:,k) = A\F0; % Displacement
    aa(:,k) = -omega(k)^2*xx(:,k); % Acceleration
end

%% 3.4.a. Outputs of interest - displacement and acceleration
idof_XA = idb(1,1); % Node A in horizontal direction
idof_YD = idb(4,2); % Node D in vertical direction

% FRFs for node A
FRF_XA_p = xx(idof_XA,:); % Horizontal displacement
FRF_XA_a = aa(idof_XA,:); % Horizontal acceleration

% FRFs for node D
FRF_YD_p = xx(idof_YD,:); % Vertical displacement
FRF_YD_a = aa(idof_YD,:); % Vertical acceleration

% Plot for horizontal displacement and acceleration at node A
figure('Name','FRF: Horizontal displacement and acceleration at node A')
subplot(2,2,1)
semilogy(vett_f,abs(FRF_XA_p))
hold on
grid on
title('FRF: Horizontal Displacement of A')
ylabel('|X_A/F_C| [m/N]')
subplot(2,2,3)
plot(vett_f,unwrap(angle(FRF_XA_p)))
hold on
ylabel('\Psi [rad]')
xlabel('Freq [Hz]')
grid on
subplot(2,2,2)
semilogy(vett_f,abs(FRF_XA_a))
hold on
grid on
title('FRF: Horizontal Acceleration of A')
ylabel('|Xpp_A/F_C| [m/s^2/N]')
subplot(2,2,4)
plot(vett_f,unwrap(angle(FRF_XA_a)))
hold on
ylabel('\Psi [rad]')
xlabel('Freq [Hz]')
grid on

% Plot for vertical displacement and acceleration at node D
figure('Name','FRF: Vertical displacement and acceleration at node D')
subplot(2,2,1)
semilogy(vett_f,abs(FRF_YD_p))
hold on
grid on
title('FRF: Vertical Displacement of D')
ylabel('|Y_D/F_C| [m/N]')
subplot(2,2,3)
plot(vett_f,unwrap(angle(FRF_YD_p)))
hold on
ylabel('\Psi [rad]')
xlabel('Freq [Hz]')
grid on
subplot(2,2,2)
semilogy(vett_f,abs(FRF_YD_a))
hold on
grid on
title('FRF: Vertical Acceleration of D')
ylabel('|Ypp_D/F_C| [m/s^2/N]')
subplot(2,2,4)
plot(vett_f,unwrap(angle(FRF_YD_a)))
hold on
ylabel('\Psi [rad]')
xlabel('Freq [Hz]')
grid on

%% 3.4.b. Outputs of interest - shear force, bending moment and axial force
el_num = 5; % Element that contains the node located in the midpoint of the EG beam (right end)
lambda = [ cos(gamma(el_num)) sin(gamma(el_num)) 0.
          -sin(gamma(el_num)) cos(gamma(el_num)) 0.
          0.                  0.                 1.] ;
xiG = xx(idb(5,:),:);
xjG = xx(idb(2,:),:);
xiL = lambda*xiG;
xjL = lambda*xjG;

% Axial force at the desired point
u1 = [1 0 0 0 0 0];
u2 = [-1/l(el_num) 0 0 1/l(el_num) 0 0];
syms csi
fu = @(csi) u1 + u2*csi;
dfu  = diff(fu,csi);
N_ax = EA(el_num)*dfu*[xiL;xjL];
figure('Name','FRF: Axial load at the midpoint of EG beam')
subplot(211)
semilogy(vett_f,abs(N_ax))
grid on
hold on
title('FRF: Axial load at the midpoint of EG beam')
ylabel(['|N_5/F_C| [N/N]'])
subplot(212)
plot(vett_f,angle(N_ax))
ylabel(['\Psi [rad]'])
xlabel('Freq [Hz]')
grid on
hold on

% Bending moment at the desired point
e1 = [0 1 0 0 0 0];
e2 = [0 0 1 0 0 0];
e3 = [0   -3/l(el_num)^2   -2/l(el_num)   0    3/l(el_num)^2   -1/l(el_num)];
e4 = [0    2/l(el_num)^3    1/l(el_num)^2 0   -2/l(el_num)^3    1/l(el_num)^2];
fw = @(csi) e1 + e2*csi + e3*csi^2 + e4*csi^3;
dfw2 = diff(fw,csi,2);
csi  = 0; % Input node i in local frame
vdfw2  = eval(dfw2);
M_bend = EJ(el_num)*vdfw2*[xiL;xjL];
figure('Name','FRF: Bending moment at the midpoint of EG beam')
subplot(211)
semilogy(vett_f,abs(M_bend))
grid on
hold on
title('FRF: Bending moment at the midpoint of EG beam')
ylabel(['|M_5/F_C| [N.m/N]'])
subplot(212)
plot(vett_f,angle(M_bend))
ylabel(['\Psi [rad]'])
xlabel('Freq [Hz]')
grid on
hold on


% Shear force in the desired point
syms csi
fw = @(csi) e1 + e2*csi + e3*csi^2 + e4*csi^3;
dfw3 = diff(fw,csi,3);
csi  = 0; % Input node i in local frame
vdfw3  = eval(dfw3);
S_mid = EJ(el_num)*vdfw3*[xiL;xjL];
figure('Name','FRF: Shear force at the midpoint of EG beam')
subplot(211)
semilogy(vett_f,abs(S_mid))
grid on
hold on
title('FRF: Shear force at the midpoint of EG beam')
ylabel(['|T_5/F_C| [N/N]'])
subplot(212)
plot(vett_f,unwrap(angle(S_mid)))
ylabel(['\Psi [rad]'])
xlabel('Freq [Hz]')
grid on
hold on
%% 4. Modal superposition approach
Phi = eigenvectors(:,ind(1:2)); % Considering the structure's first 2 modes
Mmodal = Phi'*MFF*Phi; 
Kmodal = Phi'*KFF*Phi; 
Cmodal = Phi'*CFF*Phi; 
Fmodal = Phi'*F0;

% FRF matrix
for k=1:length(omega)
    A_modal = -omega(k)^2*Mmodal + sqrt(-1)*omega(k)*Cmodal + Kmodal;
    xx_modal(:,k) = A_modal\Fmodal; % Displacement
    aa_modal(:,k) = -omega(k)^2*xx_modal(:,k); % Acceleration
end
xx_m2p = Phi*xx_modal;
aa_m2p = Phi*aa_modal;

% FRFs for node A
FRF_XAm_p = xx_m2p(idof_XA,:); % Horizontal displacement
FRF_XAm_a = aa_m2p(idof_XA,:); % Horizontal acceleration

% FRFs for node D
FRF_YDm_p = xx_m2p(idof_YD,:); % Vertical displacement
FRF_YDm_a = aa_m2p(idof_YD,:); % Vertical acceleration

% Plot for horizontal displacement and acceleration at node A
figure('Name','FRF: Horizontal displacement and acceleration at node A - Modal approach')
subplot(2,2,1)
semilogy(vett_f,abs(FRF_XAm_p),vett_f,abs(FRF_XA_p),'--r')
legend('Modal','FEM')
grid on
title('FRF: Horizontal Displacement of A - Modal approach')
ylabel(['|X_A/F_C| [m/N]'])
subplot(2,2,3)
plot(vett_f,unwrap(angle(FRF_XAm_p)),vett_f,unwrap(angle(FRF_XA_p)),'--r')
ylabel(['\Psi [rad]'])
xlabel('Freq [Hz]')
legend('Modal','FEM')
grid on
subplot(2,2,2)
semilogy(vett_f,abs(FRF_XAm_a),vett_f,abs(FRF_XA_a),'--r')
legend('Modal','FEM')
grid on
title('FRF: Horizontal Acceleration of A - Modal approach')
ylabel(['|Xpp_A/F_C| [m/N]'])
subplot(2,2,4)
plot(vett_f,unwrap(angle(FRF_XAm_a)),vett_f,unwrap(angle(FRF_XA_a)),'--r')
ylabel(['\Psi [rad]'])
xlabel('Freq [Hz]')
legend('Modal','FEM')
grid on

% Plot for vertical displacement and acceleration at node D
figure('Name','FRF: Vertical displacement and acceleration at node D - Modal approach')
subplot(2,2,1)
semilogy(vett_f,abs(FRF_YDm_p),vett_f,abs(FRF_YD_p),'--r')
legend('Modal','FEM')
grid on
title('FRF: Vertical Displacement of D - Modal approach')
ylabel(['[Y_D/F_C| [m/N]'])
subplot(2,2,3)
plot(vett_f,unwrap(angle(FRF_YDm_p)),vett_f,unwrap(angle(FRF_YD_p)),'--r')
ylabel(['\Psi [rad]'])
xlabel('Freq [Hz]')
legend('Modal','FEM')
grid on
subplot(2,2,2)
semilogy(vett_f,abs(FRF_YDm_a),vett_f,abs(FRF_YD_a),'--r')
legend('Modal','FEM')
grid on
title('FRF: Vertical Acceleration of D - Modal approach')
ylabel(['|Ypp_D/F_C| [m/N]'])
subplot(2,2,4)
plot(vett_f,unwrap(angle(FRF_YDm_a)),vett_f,unwrap(angle(FRF_YD_a)),'--r')
ylabel(['\Psi [rad]'])
xlabel('Freq [Hz]')
legend('Modal','FEM')
grid on

%% 5. Time history of the vertical displacement of node D (superposition principle)
Ts = 5; % Time length [s]
dt = 0.01; % Time resolution [s]
t_vec = 0:dt:Ts; % Time vector
idof_Cy = idb(10,2); % Node C in vertical direction

% Setting forcing vectors
F0_1 = zeros(ndof,1); 
F0_2 = zeros(ndof,1); 

% Frequencies of the external force [Hz]
f_1 = 1;
f_2 = 5;

% [Hz]->[rad/s]
omegaFc_1 = 2*pi*f_1; 
omegaFc_2 = 2*pi*f_2; 

% Magnitudes of the external force [N]
F0_1(idof_Cy) = 300;
F0_2(idof_Cy) = 50;

A_1 = - omegaFc_1^2*MFF + sqrt(-1)*omegaFc_1*CFF + KFF;
A_2 = - omegaFc_2^2*MFF + sqrt(-1)*omegaFc_2*CFF + KFF;

% FRF matrices
xFc_1 = A_1\F0_1;
xFc_2 = A_2\F0_2;

% Building the time responses for all dofs
xtot = zeros(ndof,length(t_vec)); % Setting displacements matrix (row: dof; column: time range)
for tsp = 1:length(t_vec)
    xtot(:,tsp) = xtot(:,tsp) + abs(xFc_1).*cos(omegaFc_1*t_vec(tsp)) + abs(xFc_2).*cos(omegaFc_2*t_vec(tsp)); % Superposition-time response
end

% Plotting the time response for the desired dof
figure('Name','Time history of the vertical displacement of D ')
idof_YD = idb(4,2); % Node D in vertical direction
xDt = xtot(idof_YD,:); % Response in time domain at node D
plot(t_vec,xDt)
hold on
grid on
xlabel('Time [s]')
ylabel('Y_D [m]')
title('Time history of the vertical displacement of D')
