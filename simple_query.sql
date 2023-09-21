SELECT c.neighborhood, cc.name_combine, count(c.ccnumber)
FROM "baltimore_crime"."crime" as c
  left join "baltimore_crime".crime_codes as cc on c.crimecode = cc.code
group by 1,2
order by 1,2