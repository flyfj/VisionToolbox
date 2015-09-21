%   TGV2-L2 Depth Image Upsampling
%
%   Author: David Ferstl
%
%   If you use this file or package for your work, please refer to the
%   following papers:
% 
%   [1] David Ferstl, Christian Reinbacher, Rene Ranftl, Matthias Rüther 
%       and Horst Bischof, Image Guided Depth Upsampling using Anisotropic
%       Total Generalized Variation, ICCV 2013.
%
%   License:
%     Copyright (C) 2013 Institute for Computer Graphics and Vision,
%                      Graz University of Technology
% 
%     This program is free software; you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation; either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see
%     <http://www.gnu.org/licenses/>.
%
%UPSAMPLINGTENSORTGVL2_MAT function for depth image upsampling
%   [ U ] = UPSAMPLINGTENSORTGVL2_MAT( U_INIT, DEPTH, WEIGHT, GRAY, 
%               TENSOR, TGV_ALPHA, L, MAXITS, CHECK, TOL, VERBOSE )
%       returns a upsampled depht image according to its imput parameters
%
%   [IN]
%       U_INIT ...    Initial upsampling solution (a good
%                       initial solution will reduce the number 
%                       of iterations until convergence)
%       DEPTH ...       Sparse input depth image
%       WEIGHT ...    Weights according to the imput depth vales 
%                       (lambda.*w)
%       GRAY ...      High Resolution intensity image for anisotropic 
%                       regularization
%       TENSOR ...    Anisotropic Tensor parameters [beta, gamma]
%       TGV_ALPHA ... TGV weighting parameters [alpha0, alpha1]
%       L ...         Timestep Lambda to adjust convergence rate (usually 1)
%       MAXITS ...    Number of iterations
%       CHECK ...     Check solution every CHECK iterations for convergence
%       TOL ...       Tolerance to define convergence
%       VERBOSE ...   Generate additional output [ TRUE/FALSE ]  
%   [OUT]
%       U ...         Final Upsampling solution

function [ u ] = upsamplingTensorTGVL2( u_init, d, w, gray, tensor_ab, tgv_alpha, l, maxits, check, tol, verbose )
    
    [M, N] = size(gray);
    alpha0 = tgv_alpha(1);
    alpha1 = tgv_alpha(2);
    
    % initial time-steps
    tau = 1;
    sigma = 1/tau;

    % preconditioning variables
    eta_p = 3;
    eta_q = 2;

    % calculate anisotropic diffusion tensor
    [tensor, ~, ~] = calcTensor(gray, tensor_ab, 2);
    
    a = tensor{1};
    b = tensor{2};
    c = tensor{3};
    
    eta_u = (a.^2 + b.^2 + 2*c.^2 + (a+c).^2 + (b+c).^2).*(alpha1.^2) + 0*w.^2;

    eta_v = zeros(M,N,2);
    
    eta_v(:,:,1) = (alpha1.^2).*(b.^2 + c.^2) + 4*alpha0.^2;
    eta_v(:,:,2) = (alpha1.^2).*(a.^2 + c.^2) + 4*alpha0.^2;
    
    p = zeros(M,N,2);      
    q = zeros(M,N,4); 

    u = u_init;
    u_ = u;
    u_old = zeros(M,N);
    
    v = zeros(M,N,2);
    v_ = v;
    
    grad_v = zeros(M,N,4);

    dw = d.*w;

    if(verbose > 0 ) 
        hf5 = figure(verbose);
        set(hf5,'Name', 'TGV-Huber Fusion TENSOR', 'OuterPosition', [1 1 1200 800]);
    end
    
    for k = 0:maxits
    
        disp(sprintf('current iter %d', k));
        % update timesteps
        if(sigma < 1000)
            mu = 1/sqrt(1+0.7*tau*l);
        else
            mu = 1;
        end
        
        % --------- update dual variables tgv ---------------
        
        u_x = dxp(u_) - v_(:,:,1);
        u_y = dyp(u_) - v_(:,:,2);
        
        du_tensor_x = a.*u_x + c.*u_y; 
        du_tensor_y = c.*u_x + b.*u_y;

        p(:,:,1) = p(:,:,1) + alpha1*sigma/eta_p.*du_tensor_x;
        p(:,:,2) = p(:,:,2) + alpha1*sigma/eta_p.*du_tensor_y;

        % projection
        reprojection = max(1.0, sqrt(p(:,:,1).^2 + p(:,:,2).^2));
        p(:,:,1) = p(:,:,1)./reprojection;
        p(:,:,2) = p(:,:,2)./reprojection;
        
        grad_v(:,:,1) = dxp(v_(:,:,1));
        grad_v(:,:,2) = dyp(v_(:,:,2));
        grad_v(:,:,3) = dyp(v_(:,:,1));
        grad_v(:,:,4) = dxp(v_(:,:,2));

        q = q + alpha0*sigma/eta_q.*grad_v;

        % projection
        reproject = max(1.0, sqrt(q(:,:,1).^2 + q(:,:,2).^2 + q(:,:,3).^2 + q(:,:,4).^2));
        q(:,:,1) = q(:,:,1)./reproject;
        q(:,:,2) = q(:,:,2)./reproject;
        q(:,:,3) = q(:,:,3)./reproject;
        q(:,:,4) = q(:,:,4)./reproject;
        
        
        % --------- update primal variables l2 ---------------
        
        u_ = u;
        v_ = v;

        Tp(:,:,1) = a.*p(:,:, 1) + c.*p(:,:,2);
        Tp(:,:,2) = c.*p(:,:, 1) + b.*p(:,:,2);
        
        div_p = dxm(Tp(:,:,1)) + dym(Tp(:,:,2));
                
        tau_eta_u = tau./eta_u;
                
        u = (u_ + tau_eta_u.*(alpha1.*div_p + dw))./(1 + tau_eta_u.*w);
        
        qc(:,:,1) = [q(:,1:end-1, 1), zeros(M,1)];
        qc(:,:,2) = [q(1:end-1,:, 2); zeros(1,N)];
        qc(:,:,3) = [q(1:end-1,:, 3); zeros(1,N)];
        qc(:,:,4) = [q(:,1:end-1, 4), zeros(M,1)];
        
        qw_x = [zeros(M,1,1), q(:,1:end-1,1)];
        qw_w = [zeros(M,1,1), q(:,1:end-1,4)];
        
        qn_y = [zeros(1,N,1); q(1:end-1,:,2)];
        qn_z = [zeros(1,N,1); q(1:end-1,:,3)];

        div_q(:,:,1) = (qc(:,:,1) - qw_x) + (qc(:,:,3) - qn_z);
        div_q(:,:,2) = (qc(:,:,4) - qw_w) + (qc(:,:,2) - qn_y);
        
        dq_tensor(:,:,1) = a.*p(:,:,1) + c.*p(:,:,2); 
        dq_tensor(:,:,2) = c.*p(:,:,1) + b.*p(:,:,2);
        
        v = v_ + tau./eta_v.*(alpha1.*dq_tensor + alpha0.*div_q);

        % over-relaxation
        u_ = u + mu.*(u - u_);
        v_ = v + mu.*(v - v_);

        sigma = sigma/mu;
        tau = tau*mu;
        
        if mod(k, check) == 0,
            
            if(verbose > 0)
                subplot(241), imshow(d, [0 1]); title(sprintf('inputD %u x %u ', M, N)); drawnow;
                subplot(2,4,[2:3 6:7]), imshow(u, [0 1]); title(sprintf('fused it %u : %u x %u', k, M, N)); drawnow;
                impixelinfo;
            end

            if(sum(abs(u_old(:)-u(:))) < tol)
                disp('reached minimum before maxits');
                break;
            end
            
            u_old = u;
        end
    end

end

