function displaysazwresults(sazwout);
% USAGE: displaysazwresults(sazwout);

disp([' SAMPLE SIZE = ',num2str(sazwout.samplesize)]);
disp([' CONVERGENCE: Final Grad Norm = ',num2str(sazwout.gradvalmax)]); % RMG modified 3/27/2018
disp([' PREDICTION ERROR = ',num2str(sazwout.insamplerror)]);
if ~isnan(sazwout.percentcorrect),
    disp(['% Correct = ',num2str(100*sazwout.percentcorrect),'%',...
    ', Precision=',num2str(100*sazwout.precision),'%',...
    ', Recall = ',num2str(100*sazwout.recall),'%']);
end; 
if ~isnan(sazwout.condnumhessian),
    disp([' UNIQUENESS: Condition Number = ',num2str(sazwout.condnumhessian),...
    ', Max. Hess Eigenvalue = ',num2str(sazwout.maxhesseig)]);
    disp([' OUT-OF-SAMPLE PREDICTION ERROR =', num2str(sazwout.outofsamplerror)]);
    %disp([' MISSPECIFICATION SCORE (0=no misspecification):',num2str(sazwout.specificationscore)]);
end;



end

