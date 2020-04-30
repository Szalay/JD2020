classdef STM < handle
	%STM 
	
	properties
		V;
		
		T_0;		% A szimul�ci� hossza
		T_S;		% Mintav�teli id�
		
		x_0;
		
		T;
		X;
	end
	
	methods
		
		function this = STM(vehicle, t_S, t_0, x_0)
			this.V = vehicle;
			
			this.T_S = t_S;
			this.T_0 = t_0;
			
			this.x_0 = x_0;
		end
		
		function Simulate(this)
			[this.T, this.X] = ode45(@(t, x)this.V.Model(t, x), 0:this.T_S:this.T_0, this.x_0);
		end
		
		function Plot(this)
			figure(345);
			
			subplot(4, 4, [1, 15]);
			hold on;
			axis equal;
			title('P�lya');
			plot(this.X(:, 5), this.X(:, 6), 'k-', 'LineWidth', 3);
			
			subplot(4, 4, 4);
			hold on;
			title('Sebess�gek');
			plot(this.T, this.X(:, 1:2));
			
			subplot(4, 4, 8);
			hold on;
			title('Legyez�si sz�gsebess�g');
			plot(this.T, this.X(:, 3));
			
			subplot(4, 4, 12);
			hold on;
			title('Legyez�si sz�g');
			plot(this.T, this.X(:, 4));
			
			% Nem �llapotv�ltoz�k
			delta = this.V.D.SteeringAngle(this.T, this.X);
			[alfa_1, alfa_2] = this.V.SideSlip( ...
				this.X(:, 1), this.X(:, 2), this.X(:, 3), this.X(:, 4), delta ...
				);
			
			subplot(4, 4, 16);
			hold on;
			title('A korm�nysz�g �s a k�sz�si sz�gek');
			plot(this.T, delta, 'LineWidth', 3);
			plot(this.T, [alfa_1, alfa_2]);
		end
		
	end
	
	methods (Static)
		
		function stm = Run()
			stm = STM(Vehicle.BMW3, 1e-3, 10, ...
				[10; 10; 0; 45/180*pi; 10; 25] ...
				);
			
			stm.Simulate();
			
			stm.Plot();
		end
		
	end
	
end

