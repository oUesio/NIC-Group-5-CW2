TTP PIPELINE 

-read and parse TTP file

-extract cities, items, capacity, speeds

-build nearest-neighbour TSP tour

-compute distances for that route

-build candidate lists (k-NN)

-run 2-opt using only candidates to improve the tour

-map items to tour positions

-compute suffix distance (remaining distance after city)

-generate initial population using several greedy heuristics

-repair any individual exceeding capacity

-evaluate each solution → get time, profit, weight

-NSGA-II loop:

	-crossover parents

	-mutate child

	-repair weight if needed

	-evaluate

	-combine parents + offspring

	-rank via Pareto

	-keep best fronts

after final generation → output non-dominated set (Pareto front)