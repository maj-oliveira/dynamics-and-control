% ###########################################################
% Ives Caero Vieira - N°USP:10355551
% Luiz Ricardo de Sousa Cruz - N°USP:10334961
% Matheus José Oliveira dos Santos - N°USP:10335826
% Seminário 2 - Introdução ao Método de Elementos Finitos
% PME 3555 - 20222 - Prof. Dr. Ponge
% ###########################################################

clear all
close all
clc

%% parâmetros
L1 = 3.4644; %[m]
L2 = L1; %[m]
L3 = 3.4644; %[m]
L4 = L3; %[m]
L5 = 3; %[m]
L6 = 4.5828/2; %[m]

A1 = 0.0015936; %[m^2]
A2 = A1; %[m^2]
A3 = 0.0013904; %[m^2]
A4 = 0.0050796; %[m^2]
A5 = 0.0013904; %[m^2]
A6 = 0.0003904; %[m^2]

E = 210*10^9; %[Pa]

Fv = 10393.2; %[N]

%% Montando a matriz de rigidez global
K = zeros(165,165);

%Direito
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),1,5);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),5,7);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),7,9);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),9,11);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),11,13);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),13,15);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),15,17);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),17,19);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),19,3);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),21,23);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),23,25);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),25,27);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),27,29);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),29,31);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),31,33);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),33,35);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),35,37);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A4,L4,60,90,30),1,21);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),5,23);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),7,25);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),9,27);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),11,29);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),13,31);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),15,33);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),17,35);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),19,37);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),5,21);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),7,23);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),9,25);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),11,27);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),13,29);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),15,31);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),17,33);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),19,35);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A4,L4,120,90,30),3,37);

%Esquerdo
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),2,6);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),6,8);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),8,10);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),10,12);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),12,14);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),14,16);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),16,18);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),18,20);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A1,L1,0,90,90),20,4);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),22,24);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),24,26);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),26,28);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),28,30);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),30,32);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),32,34);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),34,36);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A2,L2,0,90,90),36,38);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A4,L4,60,90,30),2,22);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),6,24);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),8,26);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),10,28);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),12,30);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),14,32);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),16,34);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),18,36);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,60,90,30),20,38);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),6,22);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),8,24);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),10,26);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),12,28);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),14,30);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),16,32);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),18,34);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A3,L3,120,90,30),20,36);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A4,L4,120,90,30),4,38);

%Base
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),1,2);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),5,6);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),7,8);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),9,10);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),11,12);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),13,14);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),15,16);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),17,18);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),19,20);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),3,4);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),1,39);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),39,6);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),5,40);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),40,8);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),7,41);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),41,10);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),9,42);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),42,12);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),11,43);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),43,14);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),13,44);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),44,16);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),15,45);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),45,18);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),17,46);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),46,20);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),19,47);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),47,4);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),5,39);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),39,2);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),7,40);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),40,6);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),9,41);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),41,8);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),11,42);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),42,10);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),13,43);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),43,12);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),15,44);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),44,14);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),17,45);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),45,16);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),19,46);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),46,18);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),3,47);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),47,20);

%Topo
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),21,22);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),23,24);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),25,26);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),27,28);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),29,30);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),31,32);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),33,34);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),35,36);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A5,L5,90,0,90),37,38);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),21,48);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),48,24);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),23,49);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),49,26);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),25,50);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),50,28);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),27,51);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),51,30);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),29,52);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),52,32);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),31,53);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),53,34);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),33,54);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),54,36);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),35,55);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,40.89,49.11,90),55,38);

K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),23,48);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),48,22);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),25,49);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),49,24);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),27,50);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),50,26);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),29,51);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),51,28);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),31,52);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),52,30);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),33,53);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),53,32);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),35,54);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),54,34);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),37,55);
K = SpaceTrussAssemble(K,SpaceTrussElementStiffness(E,A6,L6,139.1,49.11,90),55,36);

%% Solução
F0 = [0;0;-Fv;0;0;-Fv;0;0;-Fv;0;0;-Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;0;0;-2*Fv;];
F_peso = []
F00 = zeros(105,1);
F=[F0;F00];
F2 = F([13:165]);
d0 = [0;0;0;0;0;0;0;0;0;0;0;0];
K2=K([13:165],[13:165]);
d2=K2\F2;
d=[d0;d2];
F=K*d;

%% Tensões

%direito
sigma(1) = SpaceTrussElementStress(E,L1,0,90,90,d,1,5);
sigma(2) = SpaceTrussElementStress(E,L1,0,90,90,d,5,7);
sigma(3) = SpaceTrussElementStress(E,L1,0,90,90,d,7,9);
sigma(4) = SpaceTrussElementStress(E,L1,0,90,90,d,9,11);
sigma(5) = SpaceTrussElementStress(E,L1,0,90,90,d,11,13);
sigma(6) = SpaceTrussElementStress(E,L1,0,90,90,d,13,15);
sigma(7) = SpaceTrussElementStress(E,L1,0,90,90,d,15,17);
sigma(8) = SpaceTrussElementStress(E,L1,0,90,90,d,17,19);
sigma(9) = SpaceTrussElementStress(E,L1,0,90,90,d,19,3);

sigma(10) = SpaceTrussElementStress(E,L2,0,90,90,d,21,23);
sigma(11) = SpaceTrussElementStress(E,L2,0,90,90,d,23,25);
sigma(12) = SpaceTrussElementStress(E,L2,0,90,90,d,25,27);
sigma(13) = SpaceTrussElementStress(E,L2,0,90,90,d,27,29);
sigma(14) = SpaceTrussElementStress(E,L2,0,90,90,d,29,31);
sigma(15) = SpaceTrussElementStress(E,L2,0,90,90,d,31,33);
sigma(16) = SpaceTrussElementStress(E,L2,0,90,90,d,33,35);
sigma(17) = SpaceTrussElementStress(E,L2,0,90,90,d,35,37);

sigma(18) = SpaceTrussElementStress(E,L4,60,90,30,d,1,21);
sigma(19) = SpaceTrussElementStress(E,L3,60,90,30,d,5,23);
sigma(20) = SpaceTrussElementStress(E,L3,60,90,30,d,7,25);
sigma(21) = SpaceTrussElementStress(E,L3,60,90,30,d,9,27);
sigma(22) = SpaceTrussElementStress(E,L3,60,90,30,d,11,29);
sigma(23) = SpaceTrussElementStress(E,L3,60,90,30,d,13,31);
sigma(24) = SpaceTrussElementStress(E,L3,60,90,30,d,15,33);
sigma(25) = SpaceTrussElementStress(E,L3,60,90,30,d,17,35);
sigma(26) = SpaceTrussElementStress(E,L3,60,90,30,d,19,37);

sigma(27) = SpaceTrussElementStress(E,L3,120,90,30,d,5,21);
sigma(28) = SpaceTrussElementStress(E,L3,120,90,30,d,7,23);
sigma(29) = SpaceTrussElementStress(E,L3,120,90,30,d,9,25);
sigma(30) = SpaceTrussElementStress(E,L3,120,90,30,d,11,27);
sigma(31) = SpaceTrussElementStress(E,L3,120,90,30,d,13,29);
sigma(32) = SpaceTrussElementStress(E,L3,120,90,30,d,15,31);
sigma(33) = SpaceTrussElementStress(E,L3,120,90,30,d,17,33);
sigma(34) = SpaceTrussElementStress(E,L3,120,90,30,d,19,35);
sigma(35) = SpaceTrussElementStress(E,L4,120,90,30,d,3,37);

%esquerdo
sigma(36) = SpaceTrussElementStress(E,L1,0,90,90,d,2,6);
sigma(37) = SpaceTrussElementStress(E,L1,0,90,90,d,6,8);
sigma(38) = SpaceTrussElementStress(E,L1,0,90,90,d,8,10);
sigma(39) = SpaceTrussElementStress(E,L1,0,90,90,d,10,12);
sigma(40) = SpaceTrussElementStress(E,L1,0,90,90,d,12,14);
sigma(41) = SpaceTrussElementStress(E,L1,0,90,90,d,14,16);
sigma(42) = SpaceTrussElementStress(E,L1,0,90,90,d,16,18);
sigma(43) = SpaceTrussElementStress(E,L1,0,90,90,d,18,20);
sigma(44) = SpaceTrussElementStress(E,L1,0,90,90,d,20,4);

sigma(45) = SpaceTrussElementStress(E,L2,0,90,90,d,22,24);
sigma(46) = SpaceTrussElementStress(E,L2,0,90,90,d,24,26);
sigma(47) = SpaceTrussElementStress(E,L2,0,90,90,d,26,28);
sigma(48) = SpaceTrussElementStress(E,L2,0,90,90,d,28,30);
sigma(49) = SpaceTrussElementStress(E,L2,0,90,90,d,30,32);
sigma(50) = SpaceTrussElementStress(E,L2,0,90,90,d,32,34);
sigma(51) = SpaceTrussElementStress(E,L2,0,90,90,d,34,36);
sigma(52) = SpaceTrussElementStress(E,L2,0,90,90,d,36,38);

sigma(53) = SpaceTrussElementStress(E,L4,60,90,30,d,2,22);
sigma(54) = SpaceTrussElementStress(E,L3,60,90,30,d,6,24);
sigma(55) = SpaceTrussElementStress(E,L3,60,90,30,d,8,26);
sigma(56) = SpaceTrussElementStress(E,L3,60,90,30,d,10,28);
sigma(57) = SpaceTrussElementStress(E,L3,60,90,30,d,12,30);
sigma(58) = SpaceTrussElementStress(E,L3,60,90,30,d,14,32);
sigma(59) = SpaceTrussElementStress(E,L3,60,90,30,d,16,34);
sigma(60) = SpaceTrussElementStress(E,L3,60,90,30,d,18,36);
sigma(61) = SpaceTrussElementStress(E,L3,60,90,30,d,20,38);

sigma(62) = SpaceTrussElementStress(E,L3,120,90,30,d,6,22);
sigma(63) = SpaceTrussElementStress(E,L3,120,90,30,d,8,24);
sigma(64) = SpaceTrussElementStress(E,L3,120,90,30,d,10,26);
sigma(65) = SpaceTrussElementStress(E,L3,120,90,30,d,12,28);
sigma(66) = SpaceTrussElementStress(E,L3,120,90,30,d,14,30);
sigma(67) = SpaceTrussElementStress(E,L3,120,90,30,d,16,32);
sigma(68) = SpaceTrussElementStress(E,L3,120,90,30,d,18,34);
sigma(69) = SpaceTrussElementStress(E,L3,120,90,30,d,20,36);
sigma(70) = SpaceTrussElementStress(E,L4,120,90,30,d,4,38);

%Base
sigma(71) = SpaceTrussElementStress(E,L5,90,0,90,d,1,2);
sigma(72) = SpaceTrussElementStress(E,L5,90,0,90,d,5,6);
sigma(73) = SpaceTrussElementStress(E,L5,90,0,90,d,7,8);
sigma(74) = SpaceTrussElementStress(E,L5,90,0,90,d,9,10);
sigma(75) = SpaceTrussElementStress(E,L5,90,0,90,d,11,12);
sigma(76) = SpaceTrussElementStress(E,L5,90,0,90,d,13,14);
sigma(77) = SpaceTrussElementStress(E,L5,90,0,90,d,15,16);
sigma(78) = SpaceTrussElementStress(E,L5,90,0,90,d,17,18);
sigma(79) = SpaceTrussElementStress(E,L5,90,0,90,d,19,20);
sigma(80) = SpaceTrussElementStress(E,L5,90,0,90,d,3,4);

sigma(81) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,1,39);
sigma(82) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,39,6);
sigma(83) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,5,40);
sigma(84) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,40,8);
sigma(85) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,7,41);
sigma(86) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,41,10);
sigma(87) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,9,42);
sigma(88) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,42,12);
sigma(89) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,11,43);
sigma(90) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,43,14);
sigma(91) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,13,44);
sigma(92) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,44,16);
sigma(93) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,15,45);
sigma(94) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,45,18);
sigma(95) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,17,46);
sigma(96) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,46,20);
sigma(97) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,19,47);
sigma(98) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,47,4);

sigma(99) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,5,39);
sigma(100) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,39,2);
sigma(101) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,7,40);
sigma(102) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,40,6);
sigma(103) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,9,41);
sigma(104) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,41,8);
sigma(105) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,11,42);
sigma(106) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,42,10);
sigma(107) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,13,43);
sigma(108) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,43,12);
sigma(109) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,15,44);
sigma(110) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,44,14);
sigma(111) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,17,45);
sigma(112) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,45,16);
sigma(113) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,19,46);
sigma(114) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,46,18);
sigma(115) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,3,47);
sigma(116) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,47,20);

%Topo
sigma(117) = SpaceTrussElementStress(E,L5,90,0,90,d,21,22);
sigma(118) = SpaceTrussElementStress(E,L5,90,0,90,d,23,24);
sigma(119) = SpaceTrussElementStress(E,L5,90,0,90,d,25,26);
sigma(120) = SpaceTrussElementStress(E,L5,90,0,90,d,27,28);
sigma(121) = SpaceTrussElementStress(E,L5,90,0,90,d,29,30);
sigma(122) = SpaceTrussElementStress(E,L5,90,0,90,d,31,32);
sigma(123) = SpaceTrussElementStress(E,L5,90,0,90,d,33,34);
sigma(124) = SpaceTrussElementStress(E,L5,90,0,90,d,35,36);
sigma(125) = SpaceTrussElementStress(E,L5,90,0,90,d,37,38);

sigma(126) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,21,48);
sigma(127) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,48,24);
sigma(128) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,23,49);
sigma(129) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,49,26);
sigma(130) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,25,50);
sigma(131) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,50,28);
sigma(132) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,27,51);
sigma(133) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,51,30);
sigma(134) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,29,52);
sigma(135) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,52,32);
sigma(136) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,31,53);
sigma(137) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,53,34);
sigma(138) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,33,54);
sigma(139) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,54,36);
sigma(140) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,35,55);
sigma(141) = SpaceTrussElementStress(E,L6,40.89,49.11,90,d,55,38);

sigma(142) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,23,48);
sigma(143) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,48,22);
sigma(144) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,25,49);
sigma(145) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,49,24);
sigma(146) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,27,50);
sigma(147) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,50,26);
sigma(148) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,29,51);
sigma(149) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,51,28);
sigma(150) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,31,52);
sigma(151) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,52,30);
sigma(152) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,33,53);
sigma(153) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,53,32);
sigma(154) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,35,54);
sigma(155) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,54,34);
sigma(156) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,37,55);
sigma(157) = SpaceTrussElementStress(E,L6,139.1,49.11,90,d,55,36);

sigma_max = 0;
i_max = 0;
for i = 1:156
    if sigma(i) > sigma_max
       sigma_max = sigma(i);
       i_max = i;
    end
end

sigma_min = 0;
i_min = 0;
for i = 1:156
    if sigma(i) < sigma_min
       sigma_min = sigma(i);
       i_min = i;
    end
end

sigma_max_abs = 0;
i_max_abs = 0;

for i = 1:156
    if abs(sigma(i)) > sigma_max_abs
       sigma_max_abs = abs(sigma(i));
       i_max_abs = i;
    end
end

%% 3d plot
hold on
cor = abs(sigma)/sigma_max_abs;
centro_x = 15;
centro_y = 1.5;
centro_z = 1.5;

lim =10;

plot3([centro_x-lim],[centro_y-lim],[centro_z-lim])
plot3([centro_x-lim],[centro_y-lim],[centro_z+lim])
plot3([centro_x-lim],[centro_y+lim],[centro_z-lim])
plot3([centro_x-lim],[centro_y+lim],[centro_z+lim])
plot3([centro_x+lim],[centro_y-lim],[centro_z-lim])
plot3([centro_x+lim],[centro_y-lim],[centro_z+lim])
plot3([centro_x+lim],[centro_y+lim],[centro_z-lim])
plot3([centro_x+lim],[centro_y+lim],[centro_z+lim])

%Direito
for i=1:9
    desenhar_barra((i-1)*L1,0,0,L1*i,0,0,cor(i))
end

for i=10:17
    j=i-9;
    desenhar_barra((j-1)*L1+L1/2,0,3,L1*j+L1/2,0,3,cor(i))
end

for i=18:26
    j=i-17;
    desenhar_barra((j-1)*L1,0,0,L1*(j-1)+L1/2,0,3,cor(i))
end

for i=27:35
    j=i-26;
    desenhar_barra((j)*L1,0,0,L1*(j-1)+L1/2,0,3,cor(i))
end

%Esquerdo

for i=36:44
    j=i-35;
    desenhar_barra((j-1)*L1,L5,0,L1*j,L5,0,cor(i))
end

for i=45:52
    j=i-44;
    desenhar_barra((j-1)*L1+L1/2,L5,3,L1*j+L1/2,L5,3,cor(i))
end

for i=53:61
    j=i-52;
    desenhar_barra((j-1)*L1,L5,0,L1*(j-1)+L1/2,L5,3,cor(i))
end

for i=62:70
    j=i-61;
    desenhar_barra((j)*L1,L5,0,L1*(j-1)+L1/2,L5,3,cor(i))
end

%Base
for i=71:80
    j=i-70;
    desenhar_barra((j-1)*L1,0,0,L1*(j-1),L5,0,cor(i))
end

for i=81:98
    j=i-80;
    iseven = rem(i, 2) == 0;
    
    if iseven
        desenhar_barra((j-1)*L1/2,L5/2,0,L1*(j-1)/2+L1/2,L5,0,cor(i))
    else
        desenhar_barra((j-1)*L1/2,0,0,L1*(j-1)/2+L1/2,L5/2,0,cor(i))
    end
    
end

for i=99:116
    j=i-98;
    iseven = rem(i, 2) == 0;
    
    if iseven
        desenhar_barra((j-1)*L1/2,L5/2,0,L1*(j-1)/2-L1/2,L5,0,cor(i))
    else
        desenhar_barra((j+1)*L1/2,0,0,L1*(j-1)/2+L1/2,L5/2,0,cor(i))
    end
    
end

%Topo
for i=117:125
    j=i-116;
    desenhar_barra((j-1)*L1+L1/2,0,3,L1*(j-1)+L1/2,L5,3,cor(i))
end

for i=126:141
    j=i-125;
    iseven = rem(i, 2) == 0;
    
    if iseven
        desenhar_barra((j)*L1/2+L1/2,L5/2,3,L1*(j)/2+L1,L5,3,cor(i))
    else
        desenhar_barra((j-1)*L1/2,0,3,L1*(j-1)/2+L1/2,L5/2,3,cor(i))
    end
    
end

for i=142:157
    j=i-141;
    iseven = rem(i, 2) == 0;
    
    if iseven
        desenhar_barra((j)*L1/2+L1/2,L5/2,3,L1*(j)/2,L5,3,cor(i))
    else
        desenhar_barra((j+1)*L1/2,0,3,L1*(j-1)/2+L1/2,L5/2,3,cor(i))
    end
    
end

xlabel("eixo x[m]")
ylabel("eixo y[m]")
zlabel("eixo z[m]")

grid on

%% funções

function y = SpaceTrussElementStiffness(E,A,L,thetax,thetay,thetaz)
    %SpaceTrussElementStiffness This function returns the element
    % stiffness matrix for a space truss
    % element with modulus of elasticity E,
    % cross-sectional area A, length L, and
    % angles thetax, thetay, thetaz
    % (in degrees). The size of the element
    % stiffness matrix is 6 x 6.
    x = thetax*pi/180;
    u = thetay*pi/180;
    v = thetaz*pi/180;
    Cx = cos(x);
    Cy = cos(u);
    Cz = cos(v);
    w = [Cx*Cx Cx*Cy Cx*Cz ; Cy*Cx Cy*Cy Cy*Cz ; Cz*Cx Cz*Cy Cz*Cz];
    y = E*A/L*[w -w ; -w w];
end

function y = SpaceTrussAssemble(K,k,i,j)
    %SpaceTrussAssemble This function assembles the element stiffness
    % matrix k of the space truss element with nodes
    % i and j into the global stiffness matrix K.
    % This function returns the global stiffness
    % matrix K after the element stiffness matrix-
    % k is assembled.
    K(3*i-2,3*i-2) = K(3*i-2,3*i-2) + k(1,1);
    K(3*i-2,3*i-1) = K(3*i-2,3*i-1) + k(1,2);
    K(3*i-2,3*i) = K(3*i-2,3*i) + k(1,3);
    K(3*i-2,3*j-2) = K(3*i-2,3*j-2) + k(1,4);
    K(3*i-2,3*j-1) = K(3*i-2,3*j-1) + k(1,5);
    K(3*i-2,3*j) = K(3*i-2,3*j) + k(1,6);
    K(3*i-1,3*i-2) = K(3*i-1,3*i-2) + k(2,1);
    K(3*i-1,3*i-1) = K(3*i-1,3*i-1) + k(2,2);
    K(3*i-1,3*i) = K(3*i-1,3*i) + k(2,3);
    K(3*i-1,3*j-2) = K(3*i-1,3*j-2) + k(2,4);
    K(3*i-1,3*j-1) = K(3*i-1,3*j-1) + k(2,5);
    K(3*i-1,3*j) = K(3*i-1,3*j) + k(2,6);
    K(3*i,3*i-2) = K(3*i,3*i-2) + k(3,1);
    K(3*i,3*i-1) = K(3*i,3*i-1) + k(3,2);
    K(3*i,3*i) = K(3*i,3*i) + k(3,3);
    K(3*i,3*j-2) = K(3*i,3*j-2) + k(3,4);
    K(3*i,3*j-1) = K(3*i,3*j-1) + k(3,5);
    K(3*i,3*j) = K(3*i,3*j) + k(3,6);
    K(3*j-2,3*i-2) = K(3*j-2,3*i-2) + k(4,1);
    K(3*j-2,3*i-1) = K(3*j-2,3*i-1) + k(4,2);
    K(3*j-2,3*i) = K(3*j-2,3*i) + k(4,3);
    K(3*j-2,3*j-2) = K(3*j-2,3*j-2) + k(4,4);
    K(3*j-2,3*j-1) = K(3*j-2,3*j-1) + k(4,5);
    K(3*j-2,3*j) = K(3*j-2,3*j) + k(4,6);
    K(3*j-1,3*i-2) = K(3*j-1,3*i-2) + k(5,1);
    K(3*j-1,3*i-1) = K(3*j-1,3*i-1) + k(5,2);
    K(3*j-1,3*i) = K(3*j-1,3*i) + k(5,3);
    K(3*j-1,3*j-2) = K(3*j-1,3*j-2) + k(5,4);
    K(3*j-1,3*j-1) = K(3*j-1,3*j-1) + k(5,5);
    K(3*j-1,3*j) = K(3*j-1,3*j) + k(5,6);
    K(3*j,3*i-2) = K(3*j,3*i-2) + k(6,1);
    K(3*j,3*i-1) = K(3*j,3*i-1) + k(6,2);
    K(3*j,3*i) = K(3*j,3*i) + k(6,3);
    K(3*j,3*j-2) = K(3*j,3*j-2) + k(6,4);
    K(3*j,3*j-1) = K(3*j,3*j-1) + k(6,5);
    K(3*j,3*j) = K(3*j,3*j) + k(6,6);
    y = K;
end

function y = SpaceTrussElementStress(E,L,thetax,thetay,thetaz,u,i,j)
    %SpaceTrussElementStress This function returns the element stress
    % given the modulus of elasticity E, the
    % length L, the angles thetax, thetay,
    % thetaz (in degrees), and the element
    % nodal displacement vector u.
    u1=u([i*3-2:i*3,j*3-2:j*3]);
    x = thetax * pi/180;
    w = thetay * pi/180;
    v = thetaz * pi/180;
    Cx = cos(x);
    Cy = cos(w);
    Cz = cos(v);
    y = E/L*[-Cx -Cy -Cz Cx Cy Cz]*u1;
end

function desenhar_barra(x1,y1,z1,x2,y2,z2,cor)

    r = cor;
    g = 1 - cor;
    
    %desenha linha entre pontos
    plot3([x1,x2],[y1,y2],[z1,z2],'Color',[r g 0],'LineWidth',2.5)

    %desenhar pontos
    plot3([x1],[y1],[z1],"o",'Color',[0 0 1])
    plot3([x2],[y2],[z2],"o",'Color',[0 0 1])
end