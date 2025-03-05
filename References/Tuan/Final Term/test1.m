function y = test1(pos_cart, theta, cart, pole)

l = 5;
r = 0.1;
x_cart = [-1 -1 1 1];

updatedX_cart = x_cart + pos_cart;
temp_x = [l*cos(3/2*pi+theta-atan(r/l)) r*cos(pi+theta) r*cos(theta) l*cos(3/2*pi+theta+atan(r/l))];
temp_y = [l*sin(3/2*pi+theta-atan(r/l)) r*sin(pi+theta) r*sin(theta) l*sin(3/2*pi+theta+atan(r/l))];
updatedX_pole = pos_cart + temp_x;
updatedY_pole = temp_y;
set(cart, 'Xdata', updatedX_cart);
set(pole, 'Xdata', updatedX_pole,'Ydata', updatedY_pole);
drawnow;

y = 1;