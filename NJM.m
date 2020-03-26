classdef NJM < handle
	%NJM Negyedjármûmodell
	
	properties (Constant)
		g = 9.81;				% [m/s^2]
		
		% Busz
		m_R = 4500;				% [kg]
		c_R = 300000;			% [N/m]
		k_R = 20000;			% [N/(m/s)]
		
		m_0 = 500;				% [kg]
		c_0 = 1600000;			% [N/m]
		k_0 = 150;				% [N/(m/s)]
		
		% Állapot
		% x = [v_R; v_0; z_R; z_0]
		
		% Rendszermátrix
		A = [ ...
			[-NJM.k_R,   NJM.k_R,			-NJM.c_R,   NJM.c_R]/NJM.m_R; ...
			[ NJM.k_R, -(NJM.k_0 + NJM.k_R), NJM.c_R, -(NJM.c_0 + NJM.c_R)]/NJM.m_0; ...
			1, 0, 0, 0; ...
			0, 1, 0, 0 ...
			];
		
		% Bemenet
		% u = [F; g; v; z]
		
		% Bemeneti mátrix
		B = [ ...
			 1/NJM.m_R, -1, 0, 0; ...
			-1/NJM.m_0, -1, NJM.k_0/NJM.m_0, NJM.c_0/NJM.m_0; ...
			0, 0, 0, 0; ...
			0, 0, 0, 0 ...
			];
		
		% Kimenet
		% y = a_R
		
		% Kimeneti mátrix
		C = [-NJM.k_R, NJM.k_R, -NJM.c_R, NJM.c_R]/NJM.m_R;
		
		% Elõrecsatolási mátrix
		D = [1/NJM.m_R, -1, 0, 0];
	end
	
	properties
		
		% Bemenet
		u = @(t, x) [0; NJM.g; 0; 0];
		
		% A szimuláció hossza
		T_0 = 1;				% [s]
		
		% Mintavételi idõ
		T_S = 1e-3;				% [s]
		
		% Kezdeti érték
		x_0 = [0; 0; 0; 0];
		
		% Megoldás
		T;
		X;
		Y;
		
	end
	
	methods
		
		function this = NJM(u, x_0)
			this.u = u;
			this.x_0 = x_0;
		end
		
		function Simulate(this)
			
			dxdt = @(t, x) NJM.A * x + NJM.B * this.u(t, x);
			
			% Megoldás
			[this.T, this.X] = ode45(dxdt, 0:this.T_S:this.T_0, this.x_0);
			
			% Kimenet y = C x + D u
			for i = 1:length(this.T)
				% y' = x' C' + u' D'
				this.Y(i, :) = this.X(i, :) * NJM.C' + this.u(this.T(i), this.X(i, :)')' * NJM.D';
			end
		end
		
		function Plot(this)
			figure(345);
			
			% Bemenetek
			subplot(3, 1, 1); hold on;
			
			U = zeros(length(this.T), 4);
			for i = 1:length(this.T)
				U(i, :) = this.u(this.T(i), this.X(i, :)')';
			end
			
			pf = plot(this.T, U(:, 1), 'LineWidth', 3);
			pg = plot(this.T, U(:, 2), 'LineWidth', 3);
			pv = plot(this.T, U(:, 3), 'LineWidth', 3);
			pz = plot(this.T, U(:, 4), 'LineWidth', 3);
			
			legend([pf, pg, pv, pz], {'F(t)', 'g', 'v(t)', 'z(t)'});

			% Állapotok
			subplot(3, 1, 2); hold on;
			pvr = plot(this.T, this.X(:, 1), 'LineWidth', 3);
			pv0 = plot(this.T, this.X(:, 2), 'LineWidth', 3);
			pzr = plot(this.T, this.X(:, 3), 'LineWidth', 3);
			pz0 = plot(this.T, this.X(:, 4), 'LineWidth', 3);
			
			legend([pvr, pv0, pzr, pz0], {'v_R(t)', 'v_0(t)', 'z_R(t)', 'z_0(t)'});
			
			% Kimenet
			subplot(3, 1, 3); hold on;
			par = plot(this.T, this.Y(:, 1), 'LineWidth', 3);
			legend(par, 'a_R(t)');
		end
		
	end
	
	methods (Static)
		
		function njm = Run()
			% Bemenet
			u = @(t, x) [0; NJM.g; 0; 0];
			
			% Kezdeti érték
			x_0 = [0; 0; 0; 0];
			
			% Példányosítás
			njm = NJM(u, x_0);
			
		end
		
	end
	
end

