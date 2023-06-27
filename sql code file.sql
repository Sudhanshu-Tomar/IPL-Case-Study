select * from deliveries ;
select * from matches ;


-- 1. WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?

SELECT
      player_of_match,
      count(*) as awards_count
FROM matches 
GROUP BY player_of_match
ORDER BY 2 desc 
LIMIT 5;



-- 2. HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?

SELECT
      season,
      winner as team,
      COUNT(*) as matches_won
FROM matches 
GROUP BY 1,2;

-- 3.WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?

WITH result AS(
SELECT batsman,
       (SUM(total_runs)/COUNT(ball))*100 as strike_rate
FROM deliveries
GROUP BY batsman)
SELECT  
     Round(AVG(strike_rate),2) AS average_strike_rate
FROM result ;


-- 4.WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND?

select 
       batting_first,
       count(*) as matches_won
from(
select 
      case when win_by_runs>0 then team1 else team2 end as batting_first
from matches
where winner!="Tie") as batting_first_teams
group by 1
order by 2 desc;

-- 5.WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?

select 
      batsman,
       round((sum(batsman_runs)*100/count(*)),2) as strike_rate
from 
     deliveries 
group by 1
having sum(batsman_runs)>=200
order by 2 desc
limit 1;




-- 6.HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?

select 
      batsman,
      count(*) as total_dismissals
from 
     deliveries 
where player_dismissed is not null 
            and bowler='SL Malinga'
group by 1
order by 2 desc;



-- 7.WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN?

select 
        batsman,
        avg(case when batsman_runs=4 or batsman_runs=6 then 1 else 0 end)*100 as average_boundaries
from deliveries 
group by 1;




-- 8. WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?

select 
       season,
       batting_team,
       avg(fours+sixes) as average_boundaries
from
     (select 
           season,
           match_id,
           batting_team,
           sum(case when batsman_runs=4 then 1 else 0 end)as fours,
		   sum(case when batsman_runs=6 then 1 else 0 end) as sixes
           from deliveries,matches 
           where deliveries.match_id=matches.id
           group by 1,2,3) as team_bounsaries
group by 1,2;


-- 9.WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?

select 
	season,
    batting_team,
    max(total_runs) as highest_partnership
from(
     select 
            season,
            batting_team,
            partnership,
            sum(total_runs) as total_runs
            from(
                  select 
                          season,
                          match_id,
                          batting_team,
                          d.over,
                          sum(batsman_runs) as partnership,
                          sum(batsman_runs)+sum(extra_runs) as total_runs
                   from deliveries d,matches 
                   where d.match_id=matches.id
                   group by 1,2,3,4) as team_scores
            group by 1,2,3) as highest_partnership
group by 1,2
order by 3 desc; 


-- 10.HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?

select 
       m.id as match_no,
       d.bowling_team,
       sum(d.extra_runs) as extras
from matches as m
join deliveries as d 
on d.match_id=m.id
where extra_runs>0
group by 1,2;

-- 11. WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLEMATCH?

select 
       m.id as match_no,
       d.bowler,
       count(*) as wickets_taken
from matches as m
join deliveries as d 
on d.match_id=m.id
where d.player_dismissed is not null
group by 1,2
order by 3 desc
limit 1;


-- 12.HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?

select 
      m.city,
      case 
           when m.team1=m.winner then m.team1
           when m.team2=m.winner then m.team2 else 'draw' end as winning_team,
      count(*) as wins
from 
       matches as m
join deliveries as d 
on d.match_id=m.id
where m.result!='Tie'
group by 1,2;

-- 13.HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?

select 
       season,
       toss_winner,
       count(*) as toss_wins
from matches
 group by 1,2;

-- 14.HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?

select 
     player_of_match,
     count(*) as total_wins
from matches 
where player_of_match is not null
group by 1
order by 2 desc;



-- 15.WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?

select 
      m.id,
      d.inning,
      d.over,
      round(avg(d.total_runs),2) as average_runs_per_over
from matches as m
join deliveries as d 
on d.match_id=m.id
group by 1,2,3;





-- 16. WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?

select 
      m.season,
      m.id as match_no,
      d.batting_team,
      sum(d.total_runs) as total_score
from matches as m
join 
    deliveries as d 
on d.match_id=m.id
group by 1,2,3
order by 4 desc
limit 1;



-- 17. WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?

select 
       m.season,
       m.id as match_no,
       d.batsman,
       sum(d.batsman_runs) as total_runs
from 
      matches as m
join 
     deliveries as d 
on d.match_id=m.id
group by 1,2,3
order by 4 desc
limit 1;



