function [Angle, NearestPoint, simplex_choice, weight, iteration, flag, quadprog_exit_info]...
         = angleToConvexCone(Point, ConvexConeBase)
%
%This function uses the GJK algorithm to calculate the minimum angle
%between Point and the convex cone cone(ConvexConeBase(:, 1),
%...,ConvexConeBase(:, end)).
%
%INPUT:
%
%ConvexConeBase:             Each column of ConvexConeBase is a base of the
%                            convex cone.
%
%Point:                      Point is the vector we want to calculate the
%                            minimum angle.
%
%OUTPUT:                     
%
%Angle:                      The minimum vector space angle from Point to
%                            the convex cone.
%
%NearestPoint:               The coordinate of the direction inside the
%                            convex cone that has the smallest angle to the
%                            Point. Not only the direction is found,the
%                            amplitude is also tuned to make it the closest
%                            to the cone.
%
%simplex_choice:             The id numbers indicating the choice of the
%                            vertices of the simplex cone that encloces the
%                            closest point.The bases of the simplex cone
%                            are ConvexConeBase(:, simplex_choice).
%
%weight:                     The combine coefficients of the
%                            ConvexConeBase(:, cpp_simplex_choice) to get
%                            the closest point.
%
%iteration:                  The number of iterations in the GJK algorithm.
%
%flag:                       How the GJK algorithm exited.
%                            flag = 0 means the algorithm converges and a
%                            minimum value has been found. flag = 1 means
%                            the origin is inside the convex set. flag = 2
%                            means the distance began to increase due to
%                            unknown reasons. flag = 3 means the algorithm
%                            stopped after 10000 iterations.
%
%quadprog_exit_info:         The exitflag of the matlab quadprog program
%                            in each iteration. It is a count of the number
%                            of iterations that exit at the n th kind of
%                            exitflag. It is a 13 dimensional vector
%                            because the exitflag can vary from -8 to 4. A
%                            total number of 13 different kinds.
%                            quadprog_exit_info(1) means the number of
%                            iterations that exit at -8. It is in the
%                            increasing order, respectively. 
%                        
%   Copyright 2020 Manxiu Cui, Biophotonics Lab, Tsinghua University.

digits(100);

Dim = length(Point);
[Q, R] = qr([Point, eye(Dim)]);
if(R(1,1) < 0)
    Q = -Q;
end
ConvexBase = Q' * ConvexConeBase;
ConvexBase_project = ConvexBase(2:end, :)./ (ones(Dim - 1, 1) * ConvexBase(1, :));

[d, v, simplex_choice, lambda, iteration, flag, quadprog_exit_info]...
 = findNearestGJK(ConvexBase_project);

Angle = atan(d);

% if Angle < 3e-6
%     Angle_s = zeros(6, 1);
%     Angle_s(1) = Angle;
%     for k = 2:6
%        [d, v, simplex_choice, lambda, iteration, flag, quadprog_exit_info]...
%          = FindNearestGJK(ConvexBase_project);
%        Angle_s(k) = atan(d);
%     end
%     Angle = min(Angle_s);
%     
%     if Angle < 5e-7
%        Angle_s = [Angle_s; zeros(14, 1)];
%        for k = 7:20
%            [d, v, simplex_choice, lambda, iteration, flag, quadprog_exit_info]...
%              = FindNearestGJK(ConvexBase_project);
%            Angle_s(k) = atan(d);
%        end
%        Angle = min(Angle_s);
%     end
% end


NearestPoint = (cos(Angle))^2 * norm(Point) * Q * [1;v];
weight = (cos(Angle))^2 * norm(Point) * lambda./(ConvexBase(1, simplex_choice))';

end