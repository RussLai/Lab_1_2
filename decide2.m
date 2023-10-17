function [result,loan1,loan2,loan3,loan4]=decide2(a,Adopt,Fixedcost,Varcost,Acityi,Acityj,Ainc,Aweight,Asubsidy,Citypop,AAdopt,Ar)

beta=1;
r=Ar(a);

fix2=2;
fac=0;

loan1=0;
loan2=0;
loan3=0;
loan4=0;


adopted=AAdopt(a);
i=Acityi(a);
j=Acityj(a);
fix=Fixedcost(i,j);
var=Varcost(i,j);
wgt=Aweight(a);
inc=Ainc(a);
s=Asubsidy(a);

ratio=findaround(i,j,Citypop,Adopt);

if adopted==0

    if (inc-fix-var+s)<=0
        utilA=-inf;
    else
        utilA=log(inc-var-fix+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-var)+wgt+ratio*fac);
    end

    if inc-var-fix+s<0
        utilB=-inf;
    else
        utilB=log(inc-var-fix+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-fix2)+(1-ratio)*fac);
    end 
    
    utilP=log(inc)+(1-ratio)*fac + beta*1/(1+r)*(log(inc-var-fix+s)+wgt+ratio*fac);

    utilN=log(inc)+(1-ratio)*fac + beta*1/(1+r)*(log(inc)+(1-ratio)*fac) ;

    if max(utilA,utilB)>max(utilP,utilN)
        result=1;
        
    else 
        result=0;
        
    end
end 






if adopted==1


    if (inc-var+s)<=0
        utilA=-inf;
    else
        utilA=log(inc-var+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-var)+wgt+ratio*fac) ;
    end 
    
    if (inc-var+s)<=0
        utilP=-inf;
    else 
        utilP=log(inc-var+s)+wgt+ratio*fac + beta*1/(1+r)*(log(inc-fix2)+(1-ratio)*fac) ;
    end 

    if inc-fix2<0
        utilB=-inf;
    else 
        utilB=log(inc-fix2)+(1-ratio)*fac + beta*1/(1+r)*(log(inc-fix-var+s)+wgt+ratio*fac) ;
    end 

    if inc-fix2<0
        utilN=-inf;
    else
        utilN=log(inc-fix2)+(1-ratio)*fac + beta*1/(1+r)*(log(inc)+(1-ratio)*fac);
    end 
    
    if max(utilA,utilP)>max(utilB,utilN)
        result=0;

    else 
        result=-1;
       
    end

end 

end 








