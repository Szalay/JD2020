classdef Vehicle < handle
	%VEHICLE 
	
	properties
		Driver = Driver();
		
		% Össztömeg
		m;						% [kg]
		
		% Kanyarmerevségek
		c_1;					% [N/rad]
		c_2;
		
		% Tehetetlenségi nyomaték
		I_zz;					% [kg m^2]
		
		% Hosszméretek
		l_1;					% [m]
		l_2;
		l;
		
		% Légellenállás
		c_W;
		rho_L = 1.2;
		A;
	end
	
	properties (Constant)
		BMW3 = Vehicle( ...
			1250, 33000, 28000, 1750, 1.2, 1.4 ...
			);
	end
	
	methods
		
		function this = Vehicle(m, c_1, c_2, I_zz, l_1, l_2)
			this.m = m;
			this.c_1 = c_1;
			this.c_2 = c_2;
			
			this.I_zz = I_zz;
			this.l_1 = l_1;
			this.l_2 = l_2;
			
			this.l = this.l_1 + this.l_2;
			
			this.c_W = 0.3;
			this.A = 2;
		end
		
		function dxdt = Model(this, t, x)
			
			% Állapotok
			% x = [v_x; v_y; dpszidt; pszi; x_0; y_0]
			v_x = x(1);
			v_y = x(2);
			dpszidt = x(3);
			pszi = x(4);
			x_0 = x(5);
			y_0 = x(6);
			
			% Bemenetek
			
			% Kormányszög
			delta = this.Driver.SteeringAngle(t, x);
			
			% Hajtóerõ
			F_H = 0;
			F_Hx = F_H * cos(pszi + delta);
			F_Hy = F_H * sin(pszi + delta);
			M_H = F_H * this.l_1 * sin(delta);
			
			% Kúszási szögek
			[alfa_1, alfa_2] = this.SideSlip(v_x, v_y, dpszidt, pszi, delta);
			
			F_y1 = -this.c_1 * alfa_1;
			F_y1x = -F_y1 * sin(pszi + delta);
			F_y1y = F_y1 * cos(pszi + delta);
			M_y1 = F_y1 * this.l_1 * cos(delta);
			
			F_y2 = -this.c_2 * alfa_2;
			F_y2x = -F_y2 * sin(pszi);
			F_y2y = F_y2 * cos(pszi);
			M_y2 = -F_y2 * this.l_2;
			
			% Zavarások
			F_Lx = sign(v_x) * 1/2 * this.c_W * this.rho_L * this.A * v_x^2;
			F_Ly = sign(v_y) * 1/2 * this.c_W * this.rho_L * this.A * v_y^2;
			
			% Az állapotok deriváltjai
			dxdt = zeros(6, 1);
			
			% Az a_x gyorsulás
			dxdt(1) = 1/this.m * (F_y1x + F_y2x + F_Hx - F_Lx);
			
			% Az a_y gyorsulás
			dxdt(2) = 1/this.m * (F_y1y + F_y2y + F_Hy - F_Ly);
			
			% d^2pszi/dt^2
			dxdt(3) = 1/this.I_zz * (M_y1 + M_y2 + M_H);
			
			% Integrálás
			dxdt(4) = dpszidt;
			dxdt(5) = v_x;
			dxdt(6) = v_y;
			
		end
		
		function [alfa_1, alfa_2] = SideSlip(this, v_x, v_y, dpszidt, pszi, delta)
			% A sebesség a a jármûhöz tájolt kooridinátarendszerben
			% R(-pszi) [v_x; v_y]
			v_xJ = v_x .* cos(pszi) + v_y .* sin(pszi); 
			v_yJ = v_y .* cos(pszi) - v_x .* sin(pszi);
			
			% A kúszási szögek
			alfa_1 = atan2(v_yJ + dpszidt*this.l_1, v_xJ) - delta;
			alfa_2 = atan2(v_yJ - dpszidt*this.l_2, v_xJ);
		end
		
	end
	
end

