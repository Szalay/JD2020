classdef EKM
	%EKM Egykerékmodell
	
	properties (Constant)
		
		m = 1000;			% [kg]
		g = 9.81;			% [m/s^2]
		
		% Kerék
		R = 0.35;			% [m]
		J = 1.5;			% [kg m^2]
		B = 1;				% [Nm/(rad/s)]
		
		% Légellenállás
		c_W = 0.3;
		rho = 1.2;			% [kg/m^3]
		A = 2;				% [m^2]
		
	end
	
	methods (Static)
		
		function mu_x = Pacejka(s_x)
			b = 3.76;
			c = 2.7;
			d = 1;		% mu_max
			e = 1;
			
			% Magic Formula
			mu_x = d * sin( ...
				c * atan( ...
					b * ( (1-e)*s_x + e/b * atan(b * s_x) ) ...
					) ...
				);
		end
		
		function m_f = M_F(w, M, M_F0)
			if w ~= 0
				% A kerék forog
				m_f = -sign(w) * M_F0;
			else
				% A kerék nem forog
				if abs(M) > M_F0
					m_f = -sign(M) * M_F0;
				else
					m_f = -sign(M) * M;
				end
			end
		end
		
	end
	
end

