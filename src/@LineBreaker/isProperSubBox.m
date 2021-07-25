function idx = isProperSubBox(boxA,boxB)
    import LineBreaker.*;
    idx = isSubBox(boxA,boxB) & ~isequal(boxA,boxB);
end
