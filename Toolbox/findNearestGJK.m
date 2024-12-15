function [d, v, p, lambda, iteration, flag, quadprog_exit_info] = findNearestGJK(Base)

%This function uses the GJK algorithm to calculate the minimum distance
%from the origin to the convex set co(Base(:, 1), ...,Base(:, end)).
%
%INPUT:
%
%Base:                       Each column of Base is the coordinate of the
%                            vertices of the convex hull.    
%
%OUTPUT:                     
%
%d:                          The minimum distance from the origin to the
%                            convex hull.
%
%v:                          The coordinate of the point that is the
%                            closest to the origin.
%
%p:                          The id numbers indicating the choice of the
%                            vertices of the simplex that encloces the
%                            closest point.The vertices of the simplex are
%                            Base(:, p).
%
%lambda:                     The combine coefficients of the Base(:, p) to
%                            get the closest point.
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

    [dim, N] = size(Base);
    p = (randperm(N, dim + 1))';
    Simplex = Base(:, p);

    options = optimoptions('quadprog');
    options.MaxIterations = 1000;
    options.OptimalityTolerance = 1e-17;
    options.Display = 'none';
    
    gjk_tolerance = 1e-10;%1e-10;
    gjk_max_iter  = 1000;
    quadprog_exit_info = zeros(13, 1);
    
    d_pre = inf;
    flag = 3;
    %flag = 3 means the algorithm stopped after 10000 iterations.
    for iteration = 1 : gjk_max_iter
    %% Find the closest point in the Simplex
    
%         Det = det([ones(1, dim + 1);Simplex]);       
%         CramDet = zeros(dim + 1, 1);
%         for m = 1:dim + 1
%             CramDet(m) = (-1)^(m + 1) * det(Simplex(:, [1:m - 1, m + 1 : end]));
%         end
%   
%         CramDet = CramDet / Det;
%         if(min(CramDet) > 0)
%             v = zeros(dim, 1);
%             d = 0;
%             flag = 1;
%             lambda = CramDet;
%             %flag = 1 means the origin is inside the convex set.
%             return;
%         end

        [lambda, ~, exitflag, ~] = quadprog(sparse(Simplex' * Simplex), sparse(zeros(dim + 1, 1)),...
                          sparse(-eye(dim + 1)), sparse(zeros(dim + 1, 1)),...
                          sparse(ones(1, dim + 1)), 1,...
                          sparse(zeros(dim + 1, 1)), sparse(ones(dim + 1, 1)),...
                          sparse(ones(dim + 1, 1) / (dim + 1)), options);
        
        quadprog_exit_info(exitflag + 9) = quadprog_exit_info(exitflag + 9) + 1;       
        %Find the closest point to the origin in the simplex

        v = Simplex * lambda;
        d = norm(v);
        
        if(d == 0)
            flag = 1;
            return;
            %flag = 1 means the origin is inside the convex set.
        end
        
        if(d > d_pre)
            v = v_pre;
            d = d_pre;
            p = p_pre;
            lambda = lambda_pre;
            flag = 2;
            %flag = 2 means the distance began to increase due to unknown
            %reasons.
            return;
        end
        
        v_pre = v;
        d_pre = d;
        p_pre = p;
        lambda_pre = lambda;

    %% Update the new simplex
        [m, id] = min(v' * Base);
        if (v'* v < m * (1 + gjk_tolerance))
            flag = 0;
            %flag = 0 means the algorithm converges and a minimum value has
            %been found.
            return;
        else
            [~, min_id] = min(lambda);
            Simplex(:, min_id) = Base(:, id);
            p(min_id) = id;
        end
    end
    
    
end