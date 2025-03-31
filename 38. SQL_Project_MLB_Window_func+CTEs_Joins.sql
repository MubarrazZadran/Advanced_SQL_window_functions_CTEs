-- To get the top 20% of teams based on their annual spending.


-- In order to get the total spending per year by teams first, and then the average spend per year, use the below code. 

select yearID,TeamID,sum(salary) as total_spending_per_year
from salaries
group by yearID, teamID
order by teamID, yearID;
with cte as (select TeamID,sum(salary) as total_spending_per_year
from salaries
group by yearID, teamID
order by teamID, yearID)
select teamID, avg(total_spending_per_year) as avg_spending
from cte
group by teamID;

-- To rank team based on their total average spent per year. 


with team_annual_avg_spending as (with cte as (select TeamID,sum(salary) as total_spending_per_year
from salaries
group by yearID, teamID
order by teamID, yearID)
select teamID, avg(total_spending_per_year) as avg_spending
from cte
group by teamID)
select *, Ntile(5) over (order by avg_spending desc) as rank_team
from team_annual_avg_spending;


-- In order to select the top team based on their average annual spending, use the below code. 


with top_twenty_percent_teams as (with team_annual_avg_spending as (with cte as (select TeamID,sum(salary) as total_spending_per_year
from salaries
group by yearID, teamID
order by teamID, yearID)
select teamID, avg(total_spending_per_year) as avg_spending
from cte
group by teamID)
select *, Ntile(5) over (order by avg_spending desc) as rank_team
from team_annual_avg_spending)
select teamID, ROUND(avg_spending/1000000,2) as avg_spending_in_millions from top_twenty_percent_teams
where rank_team = 1;





