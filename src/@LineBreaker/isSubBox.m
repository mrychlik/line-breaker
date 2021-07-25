function idx = isSubBox(boxA,boxB)
    import LineBreaker.*;

    A = convertBox(boxA);
    B = convertBox(boxB);
    idx = A(:,1) >= B(:,1) & A(:,3) <= B(:,3) & ...
          A(:,2) >= B(:,2) & A(:,4) <= B(:,4);    
end