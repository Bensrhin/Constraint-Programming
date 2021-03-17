
var 1..5: p; % items beef patty
var 1..5: b; % items bun
var 1..5: c; % items cheese
var 1..5: o; % items onions
var 1..5: pc; % items pickles
var 1..5: l; % lettuce
var 1..5: k; % ketchup
var 1..5: t; % tomatos

% constraint
constraint p*50 + b*330 + c*310 + o + pc*260 + l*3 + k*160 + t*3 < 3000;
constraint p*17 + b*9 + c*6 + o*2 < 150;
constraint p*220 + b*260 + c*70 + o*10 + pc*5 + l*4 + k*20 + t*9 < 3000;
constraint k=l /\ pc=t;

solve maximize p*25 + b*15 + c*10 + o*9 + pc*3 + l*4 + k*2 + t*4;

output ["Price = \(p*25 + b*15 + c*10 + o*9 + pc*3 + l*4 + k*2 + t*4)\n", "Beef Patty = \(p)\n", "Bun = \(b)\n", "Cheese = \(c)\n","Onions = \(o)\n","Pickle = \(pc)\n","Lettuce = \(l)\n","Ketchup = \(k)\n","Tomatos = \(t)\n",];