#!/usr/bin/env bash

source bench_env.sh

run=$1
results="results/$run"
raw="$results/raw"
stats_file="$results/stats.csv"
objs_file="$results/objs.csv"
plot_file="$results/plot.html"

mzn-bench collect-statistics $raw $stats_file
mzn-bench collect-objectives $raw $objs_file

cd results
mzn-bench check-solutions --base-dir instances "$run/raw" > check-solutions.txt
mzn-bench check-statuses "$run/raw" > check-statuses.txt
mzn-bench report-status stats.csv --output-mode html > statuses.html

# python <<EOF
# #!/usr/bin/env python
# from bokeh import palettes
# from bokeh.resources import CDN
# from bokeh.embed import file_html
# 
# from mzn_bench.analysis.collect import read_csv
# from mzn_bench.analysis.plot import plot_all_instances
# from bokeh.plotting import show
# 
# objs, stats = read_csv("$objs_file", "$stats_file")
# html = file_html(plot_all_instances(objs, stats, palette=palettes.Category10[3]), CDN, "plot.html")
# 
# with open("$plot_file", "w") as f:
#     f.write(html)
# EOF

tar -cf "../tar/$run.tar" $run
