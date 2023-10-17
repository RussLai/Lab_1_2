clear

numcity=50;
Fixedcost=rand(numcity)*20;
pop=15000;
weight_parameter=4; %change
budget=15000; %change
frac=0.5;

stype=23;

loantype=[-1:15,30:33,35:37,40:49];
longtype=[20:23,34,38];
strategytype=50;

Ainc=zeros(1,pop);
for i=1:pop
    Ainc(i)=lognrnd(3,0.5);
end

Ar=zeros(1,pop);
for p=1:pop
    Ar(p)=0.09+0.16/(Ainc(p)+1);
end 

Aweight=rand(1,pop)*weight_parameter;

Acityi=randi([1,numcity],1,pop);
Acityj=randi([1,numcity],1,pop);

Aliquid=zeros(1,pop);


Citypop=zeros(numcity);
for i=1:numcity
    for j=1:numcity
        tmp=(Acityi==i&Acityj==j);
        Citypop(i,j)=sum(tmp);
    end 
end 

Varcost=zeros(numcity)+5;
Shock=zeros(numcity);
Subsidy=zeros(numcity);
Asubsidy=zeros(1,pop);
Adopt=zeros(numcity);
AAdopt=zeros(1,pop);

totalsub=0;
Sub_pre=zeros(1,pop);
nruns=100;

sz=numcity;
id=30; %change
ii=Acityi(id);
jj=Acityj(id);
up=max(ii-1,1);
down=min(sz,ii+1);
left=max(jj-1,1);
right=min(jj+1,sz);
Ragent1=zeros((down-up+1)*nruns,(right-left+1));
Ragent2=zeros(nruns,9);
Ragent2(:,6)=Aweight(id);
Ragent2(:,7)=Ainc(id);


Rloan1=zeros(1,nruns);
Rloan2=zeros(1,nruns);
Rloan3=zeros(1,nruns);
Rloan4=zeros(1,nruns);
RAdopt=zeros(1,nruns);
Rsubcost=zeros(1,nruns);

for run=1:nruns
    ln1=0;
    ln2=0;
    ln3=0;
    ln4=0;
    Y=Adopt;
    imagesc(Adopt);
    drawnow;

    PreAdopt=Adopt;
    rt=findaround(ii,jj,Citypop,Adopt);
    for p=randperm(pop)
        if sum(loantype==stype)==1
            [tmp,loan1,loan2,loan3,loan4]=decide_loan(p,Adopt,Fixedcost,Varcost,Acityi,Acityj,Ainc,Aweight,Asubsidy,Citypop,AAdopt,Ar);
        elseif sum(longtype==stype)==1
            [tmp,loan1,loan2,loan3,loan4]=decide_long(p,Adopt,Fixedcost,Varcost,Acityi,Acityj,Ainc,Aweight,Asubsidy,Citypop,AAdopt,Ar);
        else 
            [tmp,loan1,loan2,loan3,loan4]=decide_strategy(p,Adopt,Fixedcost,Varcost,Acityi,Acityj,Ainc,Aweight,Asubsidy,Citypop,AAdopt,Ar);
        end 

        AAdopt(p)=AAdopt(p)+tmp;
        ln1=ln1+loan1;
        ln2=ln2+loan2;
        ln3=ln3+loan3;
        ln4=ln4+loan4;

        if p==id
            Ragent2(run,1)=loan1;
            Ragent2(run,2)=loan2;
            Ragent2(run,3)=loan3;
            Ragent2(run,4)=loan4;
        end 
       
    end

    Ragent2(run,5)=rt;
    Ragent2(run,8)=Asubsidy(id);
    Ragent2(run,9)=AAdopt(id);
    tmp1=(run-1)*(down-up+1)+1;
    tmp2=run*(down-up+1);
    Ragent1(tmp1:tmp2,1:(right-left+1))=PreAdopt(up:down,left:right);


    for i=1:numcity
        for j=1:numcity
            tmp=AAdopt(Acityi==i&Acityj==j);
            Adopt(i,j)=sum(tmp);
        end 
    end 

    tmp=sum(AAdopt(:));
    RAdopt(run)=tmp;
    Rloan1(run)=ln1/tmp;
    Rloan3(run)=ln3/tmp;
    Rloan2(run)=ln2/(pop-tmp);
    Rloan4(run)=ln4/(pop-tmp);

    Varcost=10-1*Adopt;
    si=randi([1 numcity]);
    sj=randi([1 numcity]);
    s=1:pop;

    Aweight(Acityi==si&Acityj==sj&Aweight<0.9)=Aweight(Acityi==si&Acityj==sj&Aweight<0.9)+0.1;
   
    [Asubsidy1,total]=findsubsidy(Acityi,Acityj,Ainc,Adopt,AAdopt,run,stype,budget,Sub_pre,Citypop,Varcost,Fixedcost);
    Sub_pre=Asubsidy1;
    Asubsidy=Asubsidy1;
    Rsubcost(run)=total;


%     if Adopt==Y
%         break;
%     end 

end 
        















