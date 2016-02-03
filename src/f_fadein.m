function [y_v] = f_fadein(x_v, t_end)
% On effectue un fade in (montée progressive depuis le silence)

if t_end > length(x_v) - 1
    t_end = length(x_v) - 1;
end

cross_factor_v = (1 : t_end);
cross_factor_v = cross_factor_v /t_end * 9;
cross_factor_v = 1 ./ (.9 + cross_factor_v) - 1/10;
cross_factor_v = cross_factor_v.';

y_v = x_v(1 : t_end) .* cross_factor_v(end:-1:1);
y_v = [y_v ; x_v(t_end + 1 : end)];

end