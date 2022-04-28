clear all;
close all;
clc;
%Main_Constrained_trajectory
%1.UAV ����
H = 100; %m
c1 = 9.26*1e-4;
c2 = 2250;
q0 = [0,1000].';%��ʼλ��
qF = [1000,0].';%����λ��
v_0F = (qF-q0)/norm(qF-q0,2); %%��ʼ�ͽ����ĵ�λ�ٶȷ���
v0 = 30*v_0F;   %��ʼ�ٶ� m/s
vF = v0;        %�����ٶ�
Vmax = 100;     %����ٶ�
Vmin = 3;       %��С�ٶȣ���֤�ڿ��з���
amax = 5;      %�����ٶ� m/s^2
T = 400;        %�۲�����
deltat = 0.2;   %��ɢ�������
g = 9.8;        %�������ٶ�
N = T/deltat;
%2.Communication ����
B = 1e6;        %���� MHz
N0dBm = -170;    %����������dBm/Hz
N0 = 10^(N0dBm/10);
sigma2 = N0*B;  %��������
PdBm = 10;      %���˻����书�ʣ��̶���
P = 10^(PdBm/10);
beta0dB = -50;  %1m�ο������Ӧ·��
beta0 = 10^(beta0dB/10);
gama0 = P*beta0/sigma2;

%3.Trajectory optimization
[q_EE,v_EE,a_EE,R_aveEE,P_aveEE,EE] = EE_A1(B,gama0,H,g,c1,c2,v0,vF,q0,qF,Vmax,Vmin,amax,deltat,T);
[q_RM,v_RM,a_RM,R_aveRM,P_aveRM,EE_RM] = RM_A1(B,gama0,H,g,c1,c2,q_EE,v_EE,v0,vF,q0,qF,Vmax,Vmin,amax,deltat,T);
[q_EM,v_EM,a_EM,R_aveEM,P_aveEM,EE_EM] = ...
    EM_A1(B,gama0,H,g,c1,c2,q_EE,v_EE,v0,vF,q0,qF,Vmax,Vmin,amax,deltat,T);

%Trajectory
figure(2)
plot(q_EE(1,:),q_EE(2,:),'k-','LineWidth',1.5)
hold on,grid on;
plot(q_RM(1,:),q_RM(2,:),'b-.','LineWidth',1.5)
plot(q_EM(1,:),q_EM(2,:),'g--','LineWidth',1.5)
title('Trajectory')
legend('EE-max','Rate-max','Energy-min')
xlabel('x(m)')
ylabel('y(m)')

%speed v.s. t
figure(3)
plot((1:N+1)*deltat,norms(v_EE,2),'k-','LineWidth',1.5);
hold on,grid on;
plot((1:N+1)*deltat,norms(v_RM,2),'b-.','LineWidth',1.5);
plot((1:N+1)*deltat,norms(v_EM,2),'g--','LineWidth',1.5);
title('Speed')
legend('EE-max','Rate-max','Energy-min')
xlabel('time(s)')
ylabel('Speed(m/s)')
xlim([0,200])
