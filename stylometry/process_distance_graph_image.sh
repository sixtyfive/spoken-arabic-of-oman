#!/bin/bash

convert distance_graph.png -flatten -fuzz 1% -trim -bordercolor white -border 1%x1% -border 4x4 +repage distance_graph_smallborder.png
