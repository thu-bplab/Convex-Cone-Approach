function [SO2, P_post] = convexConeSO2_bayes(PA, Angle, noise_std)
    %Angle should be the result of convexConeSO2_noise
    L = norm(PA ./ noise_std);
    s = 0:0.005:1;
    %P_post = exp(-(sin(Angle) * L).^2 / 2);
    p = -(sin(Angle) * L).^2 / 2;
    p = p - max(p);
    P_post = exp(p);
    
    P_post = P_post / sum(P_post);
    SO2 = sum(s' .* P_post);
end