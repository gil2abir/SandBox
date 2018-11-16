function cuminx = utils_tri_cummin1D(x)
dim = 1 + double(isrow(x));
baseSquare = ones(size(x, dim));
A = x.*tril(baseSquare);
B = triu(baseSquare, 1).*x(1);
cuminx = min(A+B, [], 2)';


