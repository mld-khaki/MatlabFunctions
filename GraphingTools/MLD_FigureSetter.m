function FigureSetter(FigH,Positions)
if nargin == 1
    Positions = [100, 100, 600, 450];
end
set(FigH, 'Position',      Positions);
set(FigH, 'OuterPosition', Positions);

end