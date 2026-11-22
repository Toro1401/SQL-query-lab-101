SELECT min(player_a,player_b),max(player_a,player_b),sum(score)
FROM t1
GROUP BY min(player_a,player_b),max(player_a,player_b);
