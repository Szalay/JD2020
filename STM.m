classdef STM < handle
	%STM 
	
	properties
		Vehicle;			% Jármû (Vehicle)
		Track;				% Pálya (Track)
		
		T_0;		% A szimuláció hossza
		T_S;		% Mintavételi idõ
		
		x_0;
		
		T;
		X;
	end
	
	methods
		
		function this = STM(vehicle, track, t_S, t_0, x_0)
			this.Vehicle = vehicle;
			this.Track = track;
			this.Vehicle.Driver.Follow(this.Track);
			
			this.T_S = t_S;
			this.T_0 = t_0;
			
			this.x_0 = x_0;
		end
		
		function Simulate(this)
			[this.T, this.X] = ode45(@(t, x)this.Vehicle.Model(t, x), 0:this.T_S:this.T_0, this.x_0);
		end
		
		function Plot(this)
			figure(345);
			
			subplot(4, 4, [1, 15]);
			hold on;
			axis equal;
			title('Pálya és nyomvonal');
			plot(this.Track.X, this.Track.Y, 'Color', [0.5, 0.5, 0.5], 'LineWidth', 10);
			plot(this.X(:, 5), this.X(:, 6), 'k-', 'LineWidth', 3);
			
			subplot(4, 4, 4);
			hold on;
			title('Sebességek');
			plot(this.T, this.X(:, 1:2));
			
			subplot(4, 4, 8);
			hold on;
			title('Legyezési szögsebesség');
			plot(this.T, this.X(:, 3));
			
			subplot(4, 4, 12);
			hold on;
			title('Legyezési szög');
			plot(this.T, this.X(:, 4));
			
			% Nem állapotváltozók
			[delta, index] = this.Vehicle.Driver.SteeringAngle(this.T, this.X);
			[alfa_1, alfa_2] = this.Vehicle.SideSlip( ...
				this.X(:, 1), this.X(:, 2), this.X(:, 3), this.X(:, 4), delta ...
				);
			
			subplot(4, 4, 16);
			hold on;
			title('A kormányszög és a kúszási szögek');
			pd = plot(this.T, delta, 'Color', [0, 0.5, 0], 'LineWidth', 3);
			plot(this.T, index/max(index), 'm-', 'LineWidth', 3);
			pa1 = plot(this.T, alfa_1, 'b--', 'LineWidth', 2);
			pa2 = plot(this.T, alfa_2, 'r--', 'LineWidth', 2);
			
			legend([pd, pa1, pa2], {'\delta', '\alpha_1', '\alpha_2'});
		end
		
	end
	
	methods (Static)
		
		function stm = Run()
			x_0 = 10;
			y_0 = 25;
			
			stm = STM(Vehicle.BMW3, Track.Circle(x_0, y_0 + 200, 200, 10, 270, 360), 1e-3, 30, ...
				[10; 10; 0; 45/180*pi; 10; 25] ...
				);
			
			stm.Simulate();
			
			stm.Plot();
		end
		
	end
	
end

