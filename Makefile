SHELL=/usr/bin/bash
PYTHON=.env/bin/python

clean-tpch-dbgen:
	$(MAKE) -C tpch-dbgen clean

clean-venv:
	rm -r .venv

clean-tables:
	rm -r tables_scale_*

clean: clean-tpch-dbgen clean-venv

tables_scale_1:
	$(MAKE) -C tpch-dbgen all
	cd tpch-dbgen && ./dbgen -vf -s 1 && cd ..
	mkdir -p "tables_scale_1"
	mv tpch-dbgen/*.tbl tables_scale_1/
	$(PYTHON) prepare_files.py 1

tables_scale_5:
	$(MAKE) -C tpch-dbgen all
	cd tpch-dbgen && ./dbgen -vf -s 5 && cd ..
	mkdir -p "tables_scale_5"
	mv tpch-dbgen/*.tbl tables_scale_5/
	$(PYTHON) prepare_files.py 5

tables_scale_10:
	$(MAKE) -C tpch-dbgen all
	cd tpch-dbgen && ./dbgen -vf -s 10 && cd ..
	mkdir -p "tables_scale_10"
	mv tpch-dbgen/*.tbl tables_scale_10/
	$(PYTHON) prepare_files.py 10

run_polars: $(PYTHON) -m polars_queries.executor

run_pandas: $(PYTHON) -m pandas_queries.executor

run_dask: $(PYTHON) -m dask_queries.executor

run_modin: $(PYTHON) -m modin_queries.executor

run_vaex: .venv
	.venv/bin/python -m vaex_queries.executor

run_spark: .venv
	.venv/bin/python -m spark_queries.executor

plot_results: $(PYTHON) -m scripts.plot_results

run_all: run_polars run_pandas run_dask run_modin 

# run_spark run vaex

pre-commit:
	.venv/bin/python -m isort .
	.venv/bin/python -m black .
