% ---------------------------------------------------------------------------------
% > Function Name: forcbs (FORWARD CANTILEVER BEAM SOLVER)
% ---------------------------------------------------------------------------------
%
% > Purpose: Forward Solver based on the Pseudo-Spectral Scheme that 
%            Computes First 3 Non-Dimentional Natural Frequencies for a
%            Vibrating Cantilever with Non-Ideal Boundary Conditions 
%
% > Function Call: [bl_1, bl_2, bl_3] = forwardc(kl)
%
% > Inputs:
%     kl: Assessement Parameter with range: [0,1)
%         - 0 Corresponds to Ideal Cantilever (no Damage)
%         - (0,1) Domain Corresponds to Severity of Damage
%         - 1 Corresponds to a Non-Functional Cantilever (Simply-Supported Model),
%           where "forcbs" no Longer Applies    
%
% > Outputs:
%     First 3 Non-Dimentional Natural Frequencies
%     bl_1, bl_2, bl_3
%
% ---------------------------------------------------------------------------------
% > By Ali Termos & Salim Laaguel
% > Contributors: Alfa Heryudono & Jinhee Lee
% > University of Massachusetts Dartmouth, Mathematics Department 
% > Date: November 21, 2018
% ---------------------------------------------------------------------------------

function [bl_1,bl_2,bl_3] = forcbs(kl)

    format short e % Display Format
    L = 2; % Can be Utilized as Function Input for Desired Length
    n = 25; % 5 Significant Figures is Achieved with (n=19)    
    x = - cos((0:n).*(pi/n)).'; % Create Chebyshev Nodes
    T = ones(n+1,n+1); % Create Matrix T
    T(:,2) = x;
    Tp = zeros(n+1,n+1); % Create matrix Tp
    Tp(:,2) = 1;
    Tp2 = zeros(n+1,n+1); % Create matrix Tp2
    Tp3 = zeros(n+1,n+1); % Create matrix Tp3
    Tp4 = zeros(n+1,n+1); % Create matrix Tp4
    
    for i=3:n+1 % Loop to get Desired T,Tp,Tp2,Tp3,Tp4 Matrices
        T(:,i) = 2*x.*T(:,i-1)-T(:,i-2);
        Tp(:,i) = 2*T(:,i-1) + 2*x.*Tp(:,i-1) - Tp(:,i-2);
        Tp2(:,i) = 4*Tp(:,i-1) + 2*x.*Tp2(:,i-1) - Tp2(:,i-2);
        Tp3(:,i) = 6*Tp2(:,i-1) + 2*x.*Tp3(:,i-1) - Tp3(:,i-2);
        Tp4(:,i) = 8*Tp3(:,i-1) + 2*x.*Tp4(:,i-1) - Tp4(:,i-2);
    end
    
    % Assign Proper Boundary Conditions    
    A = Tp4; % Form matrix A
    A(1,:) = T(1,:);
    A(2,:) = (1.0-kl)*Tp(1,:)-kl*L*Tp2(1,:);
    A(n,:) = Tp2(n+1,:);
    A(n+1,:) = Tp3(n+1,:);
    B = T; % Form matrix B
    B(1,:) = 0;
    B(2,:) = 0;
    B(n,:) = 0;
    B(n+1,:) = 0;
    [~,D]=eig(A\B); % Solve for Eigen Values
    l_s = diag(D);
    l = (16/(L.^4)).*(1./l_s);
    
    % Get first 3 Non-Dimensional Natural Frequencies
    bl_1 = nthroot(l(1),4)*L;
    bl_2 = nthroot(l(2),4)*L;
    bl_3 = nthroot(l(3),4)*L;

end