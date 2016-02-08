function outvec = psynthesis(unknowns,knowns)

%knowns

p12x = knowns(1);
p13x = knowns(2);
p14x = knowns(3);
p15x = knowns(4);
p12y = knowns(5);
p13y = knowns(6);
p14y = knowns(7);
p15y = knowns(8);

%unknowns
wx = unknowns(1);
wy = unknowns(2);
zx = unknowns(3);
zy = unknowns(4);
ux = unknowns(5);
uy = unknowns(6);
sx = unknowns(7);
sy = unknowns(8);
b2 = unknowns(9);
b3 = unknowns(10);
b4 = unknowns(11);
b5 = unknowns(12);
a2 = unknowns(13);
a3 = unknowns(14);
a4 = unknowns(15);
a5 = unknowns(16);
g2 = unknowns(17);
g3 = unknowns(18);
g4 = unknowns(19);
g5 = unknowns(20);

outvec = zeros(16,1);
outvec(1) = wx*(cos(b2)-1)-wy*sin(b2)+zx*(cos(a2)-1)-zy*sin(a2)-p12x;
outvec(2) = wx*(cos(b3)-1)-wy*sin(b3)+zx*(cos(a3)-1)-zy*sin(a3)-p13x;
outvec(3) = wx*(cos(b4)-1)-wy*sin(b4)+zx*(cos(a4)-1)-zy*sin(a4)-p14x;
outvec(4) = wx*(cos(b5)-1)-wy*sin(b5)+zx*(cos(a5)-1)-zy*sin(a5)-p15x;
outvec(5) = ux*(cos(g2)-1)-uy*sin(g2)+sx*(cos(a2)-1)-sy*sin(a2)-p12x;
outvec(6) = ux*(cos(g3)-1)-uy*sin(g3)+sx*(cos(a3)-1)-sy*sin(a3)-p13x;
outvec(7) = ux*(cos(g4)-1)-uy*sin(g4)+sx*(cos(a4)-1)-sy*sin(a4)-p14x;
outvec(8) = ux*(cos(g5)-1)-uy*sin(g5)+sx*(cos(a5)-1)-sy*sin(a5)-p15x;
outvec(9) = wy*(cos(b2)-1)+wx*sin(b2)+zy*(cos(a2)-1)+zx*sin(a2)-p12y;
outvec(10) = wy*(cos(b3)-1)+wx*sin(b3)+zy*(cos(a3)-1)+zx*sin(a3)-p13y;
outvec(11) = wy*(cos(b4)-1)+wx*sin(b4)+zy*(cos(a4)-1)+zx*sin(a4)-p14y;
outvec(12) = wy*(cos(b5)-1)+wx*sin(b5)+zy*(cos(a5)-1)+zx*sin(a5)-p15y;
outvec(13) = uy*(cos(g2)-1)+ux*sin(g2)+sy*(cos(a2)-1)+sx*sin(a2)-p12y;
outvec(14) = uy*(cos(g3)-1)+ux*sin(g3)+sy*(cos(a3)-1)+sx*sin(a3)-p13y;
outvec(15) = uy*(cos(g4)-1)+ux*sin(g4)+sy*(cos(a4)-1)+sx*sin(a4)-p14y;
outvec(16) = uy*(cos(g5)-1)+ux*sin(g5)+sy*(cos(a5)-1)+sx*sin(a5)-p15y;
