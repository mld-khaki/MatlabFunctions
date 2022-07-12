function Out = MLD_EngMode(Inp)
Vals = [ -24,   -21,     -18,  -15,     -12,   -9,    -6,     -3,    -2,     -1,    0,  1,     2,      3,     6,     9,     12,    15,    18,   21    ];
Strs = {'yocto','zepto','atto','femto','pico','nano','micro','mili','centi','deci',' ','Deca','Hecto','Kilo','Mega','Giga','Tera','Peta','Exa','Zetta'};
Syms = {'y',    'z',    'a',   'f',    'p',   'n',   'u',    'm',   'c',    'd',   ' ','D'   ,'H',    'K',   'M',   'G',   'T',   'P',   'E',  'Z'};

for jCtr=2:length(Vals),vCtr=Vals(jCtr);
    LowBound = 10^Vals(jCtr-1);
    UppBound = 10^Vals(jCtr);
    if Inp >= LowBound && Inp < UppBound
        Value = Inp / LowBound;
        Out = sprintf('%5.2f [%s] [%s] => (%i)', Value, Strs{jCtr-1},Syms{jCtr-1},Vals(jCtr-1));
    end
end
