function [meanDiff,sdDiff,CR] = BlandAltman(var1,var2)
    var1 = double(var1);
    var2 = double(var2);
    if (nargin~=2)
       errordlg('Bad Input')
    end
    
    if (nargin==2)
    
    means = mean([var1;var2]);
    diffs = var1-var2;
    
    meanDiff = mean(diffs);
    meanDiffVec(1:length(means)) = meanDiff;
    sdDiff = std(diffs);
    CR = [meanDiff + 1.96 * sdDiff, meanDiff - 1.96 * sdDiff]; %%95% confidence range
    
    linFit = polyfit(means,diffs,1); %%%work out the linear fit coefficients

        plot(means,diffs,'o')
        hold on
            plot(means, ones(1,length(means)).*CR(1),'r-'); %%%plot the upper CR
            plot(means, ones(1,length(means)).*CR(2),'r-'); %%%plot the lower CR
            plot(means,zeros(1,length(means)),'k'); %%%plot zero
            plot(means, means.*linFit(1)+linFit(2),'y--'); %%%plot the linear fit
            plot(means,meanDiffVec,'b');
        title('Bland-Altman Plot')
        errordlg('the vectors are independent statistically (Correlation in yellow) ')
    end