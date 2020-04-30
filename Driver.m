classdef Driver < handle
	%DRIVER 
	
	properties
		
	end
	
	methods
		
		function this = Driver()
			
		end
		
		function delta = SteeringAngle(this, t, x)
			delta = 5/180*pi * ones(size(t)); %1/180*pi*sin(2*pi*0.1*t);
		end
		
	end
end

