function [result,loan1,loan2,loan3,loan4]=decide_loan3(a,Adopt,Fixedcost,Varcost,Acityi,Acityj,Ainc,Aweight,Asubsidy,Citypop,AAdopt,Ar)

beta=1;
r2=Ar(a);
r=0.03; %change

fix2=2;
fac=3; %change

adopted=AAdopt(a);
i=Acityi(a);
j=Acityj(a);
fix=Fixedcost(i,j);
var=Varcost(i,j);
wgt=Aweight(a);
inc=Ainc(a);
s=Asubsidy(a);

ratio=findaround(i,j,Citypop,Adopt);

h=(1+r2)/(1+r);

if adopted==0

    loan1=((h-1)*(inc-var)+fix-s)/(2+r2);
    loan2=(h-1)*inc/(2+r2);
    loan4=((h-1)*inc+h*(s-var-fix))/(2+r2);
    loan3=((h-1)*inc+var+fix-s-h*fix2)/(2+r2);
    
    loan1=min((inc-var)/(1+r),loan1);
    loan1=max(0,loan1);
    loan2=min(inc/(1+r),loan2);
    loan2=max(0,loan2);
    loan4=min((inc-var-fix+s)/(1+r),loan4);
    loan4=max(0,loan4);
    loan3=min((inc-fix2)/(1+r),loan3);
    loan3=max(0,loan3);

    if (inc-fix-var+loan1+s)<=0
        utilA=-inf;
    else
        utilA=log(inc-var-fix+loan1+s)+wgt+ratio*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan1-var)+wgt+ratio*fac) ;
    end

    if inc-var-fix+loan3+s<0
        utilB=-inf;
    else
        utilB=log(inc-var-fix+loan3+s)+wgt+ratio*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan3-fix2)+(1-ratio)*fac) ;
    end 
    
    utilP=log(inc+loan4)+(1-ratio)*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan4-var-fix+s)+wgt+ratio*fac);

    utilN=log(inc+loan2)+(1-ratio)*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan2)+(1-ratio)*fac);


    if max(utilA,utilB)>max(utilP,utilN)
        result=1;
        if utilA>utilB
            loan2=0;
            loan3=0;
            loan4=0;
        else 
            loan1=0;
            loan2=0;
            loan4=0;
        end 
    else 
        result=0;
        if utilP>utilN
            loan1=0;
            loan2=0;
            loan3=0;
        else 
            loan1=0;
            loan3=0;
            loan4=0;
        end 
    end
end 






if adopted==1

    loan1=((h-1)*(inc-var)-s)/(2+r2);
    loan2=((h-1)*inc+fix2)/(2+r2);
    loan3=((h-1)*inc+var-s-h*fix2)/(2+r2);
    loan4=((h-1)*inc+fix2+h*(s-fix-var))/(2+r2);

    loan1=min((inc-var)/(1+r),loan1);
    loan1=max(0,loan1);
    loan2=min(inc/(1+r),loan2);
    loan2=max(0,loan2);
    loan3=min((inc-fix2)/(1+r),loan3);
    loan3=max(0,loan3);
    loan4=min((inc-fix-var+s)/(1+r),loan4);
    loan4=max(0,loan4);



    if (inc-var+loan1+s)<=0
        utilA=-inf;
    else
        utilA=log(inc-var+loan1+s)+wgt+ratio*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan1-var)+wgt+ratio*fac);
    end 
    
    if (inc-var+loan3+s)<=0
        utilP=-inf;
    else 
        utilP=log(inc-var+loan3+s)+wgt+ratio*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan3-fix2)+(1-ratio)*fac) ;
    end 

    if inc-fix2+loan4<0
        utilB=-inf;
    else 
        utilB=log(inc-fix2+loan4)+(1-ratio)*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan4-fix-var+s)+wgt+ratio*fac) ;
    end 

    if inc-fix2+loan2<0
        utilN=-inf;
    else
        utilN=log(inc-fix2+loan2)+(1-ratio)*fac + beta*1/(1+r2)*(log(inc-(1+r)*loan2)+(1-ratio)*fac) ;
    end 
    
    if max(utilA,utilP)>max(utilB,utilN)
        result=0;
        if utilA>utilP
            loan2=0;
            loan3=0;
            loan4=0;
        else 
            loan1=0;
            loan2=0;
            loan4=0;
        end 
    else 
        result=-1;
        if utilB>utilN
            loan1=0;
            loan2=0;
            loan3=0;
        else 
            loan1=0;
            loan3=0;
            loan4=0;
        end 
    end

end 

end 








