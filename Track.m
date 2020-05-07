classdef Track < handle
	%TRACK Pálya
	
	properties
		X = [];
		Y = [];
	end
	
	properties (Constant)
		
	end
	
	methods
		
		function this = Track(x, y)
			if nargin < 2
				retutn;
			end
			
			this.X = x;
			this.Y = y;
		end
		
		function AddPoint(this, P)
			this.X(end+1, 1) = P(1);
			this.Y(end+1, 1) = P(2); 
		end
		
		function d = Distance(this, x_0, y_0)
			d = sqrt((this.X - x_0).^2 + (this.Y - y_0).^2);
		end
		
	end
	
	methods (Static)
		
		function t = Circle(x_0, y_0, r, n, alpha, beta)
			% Szögfelosztás
			q = pi/180 * (alpha:((beta-alpha)/n):beta);
			
			x = r*cos(q) + x_0;
			y = r*sin(q) + y_0;
			
			% Új pálya
			t = Track(x', y');
		end
		
	end
	
end

