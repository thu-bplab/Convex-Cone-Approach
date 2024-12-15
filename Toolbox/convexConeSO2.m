function [SO2, Angle, NearestPA, flags] = convexConeSO2...
                        (PA, spectra_Hb, spectra_HbO2, F_base)

    s = 0:0.005:1;

    Angle = zeros(length(s), 1);
    
    NearestPA  = zeros(length(spectra_Hb), length(s));
    flags      = zeros(length(s), 1);
    
    %f = waitbar(0,'Convex Cone GJK algoritnm');
    for t = 1 : length(s)
        %waitbar(s(t), f, 'Convex Cone GJK algoritnm');
        Mua_guess = (1 - s(t)) * log(10) * spectra_Hb + s(t) * log(10) * spectra_HbO2;
        Deposit_cpp_base = F_base .* Mua_guess ;

        [Angle(t), NearestPA(:, t), ~, ~, ~, flags(t), ~]...
         = angleToConvexCone(PA', Deposit_cpp_base');

%         figure(10)
%         hold off;
%         scatter(1:21, NearestPA(:, t), '+');
%         hold on;
%         plot(PA);
%         drawnow;

    end

    [~, idm_s] = min(Angle);
    SO2 = s(idm_s);
    %close(f);
end

