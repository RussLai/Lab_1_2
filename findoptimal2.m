function [invest,obj]=findoptimal2(Demand,Adopt1,Fixedcost,Varcost,Agent,taxrate,period,subsidy,strategy,strat,i,j,coor,saving, total,obj,dep)

invest=0;

%moving average
if isnan(strat(i,j)) || strat(i,j)<5
    lb=0;
    ub=10;
else
    lb=(strat(i,j))-5;
    ub=(strat(i,j))-5;
end

%current income
taxinc=0;
for a=1:size(Agent,2)
    if Agent(a).cityi==i && Agent(a).cityj==j
    taxinc=taxinc+Agent(a).income;
    end 
end 

%local agents
agentlist=[];
for a=1:size(Agent,2)
    if Agent(a).cityi>=coor(2) && Agent(a).cityi<=coor(1) && Agent(a).cityj>=coor(4) && Agent(a).cityj<=coor(3)
    agentlist(end+1)=a;
    end 
end

maxobj=0;

%Recursive case
for num=lb:0.1:ub
%     Adopt1=Adopt1*(1-dep);
    Adopt1=Adopt1+strat;
    Adopt1(i,j)=Adopt1(i,j)-strat(i,j);
    Adopt1(i,j)=Adopt1(i,j)+num;
    saving=total-Fixedcost(i,j)-(Varcost(i,j)-subsidy)*num;
    
    %Apply constraint
    if saving<0
        break
    end 
    
    %Adjustment
    Price=Demand-1./Adopt1;
    minprice=min(Price(:));
    if minprice<0
        Price=Price+abs(minPrice);
    end
    
    %move agents
    for agent=randperm(agentlist)
        loci=Agent(i).cityi;
        locj=Agent(j).cityj;
        [loc1,loc2]=opt_utility(agent,Price,Agent,taxrate);
        Demand(loci,locj)=Demand(loci,locj)-Agent(agent).weight;
        Agent(agent).cityi=loc1;
        Agent(agent).cityj=loc2;
        Demand(loc1,loc2)=Demand(loc1,loc2)+Agent(agent).weight;
    end

    %compute income and obj
    taxinc=0;
    for a=1:size(Agent,2)
        if Agent(a).cityi==i && Agent(a).cityj==j
            taxinc=taxinc+Agent(a).income;
        end 
    end 

    obj=saving+taxinc;

    %final return
    if obj>maxobj
        maxobj=obj;
        invest=num;
    end 
end 








