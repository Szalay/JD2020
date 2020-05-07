classdef Driver < handle
	%DRIVER 
	
	properties
		Track;
		
		D = 20;			% [m], a követett pont távolsága
	end
	
	methods
		
		function this = Driver()
			
		end
		
		function Follow(this, track)
			this.Track = track;
		end
		
		function [delta, index] = SteeringAngle(this, t, x)
			%delta = 5/180*pi * ones(size(t)); %1/180*pi*sin(2*pi*0.1*t);
			
			if isvector(x)
				[delta, index] = this.SteeringAngleToNearestPoint(x);
			else
				delta = zeros(size(x, 1), 1);
				index = zeros(size(x, 1), 1);
				for i = 1:size(x, 1)
					[delta(i, 1), index(i, 1)] = this.SteeringAngleToNearestPoint(x(i, :)');
				end
			end
		end
		
		function [delta, i] = SteeringAngleToNearestPoint(this, x)
			i = this.NearestPointIndex(x(5), x(6));
			% A megcélzott pont
			x_0 = this.Track.X(i+1);
			y_0 = this.Track.Y(i+1);

			delta = atan2(y_0 - x(6), x_0 - x(5)) - x(4);
		end
		
		function i = NearestPointIndex(this, x_0, y_0)
			d = this.Track.Distance(x_0, y_0);
			
			[~, i] = min(d);
		end
		
	end
end

