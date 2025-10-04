TEST ?= alu_test
COUNT ?= 10

ALUVM_DIR := /home/admini/ALUVM_advanced

TOP := ALUVM_top

DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

REG_LIST := $(shell cat $(DIR)/regression.list)

REG_TARGETS := $(REG_LIST:%=run_%)

all:
	export ALUVM_HOME=$(ALUVM_DIR) && \
	cd $(DIR)/.. && \
	mkdir -p run && \
	cd run && \
	qrun \
	-64 \
	-sv \
	-timescale 1ns/1ps \
	-mfcu \
	-incr \
	-sv_seed random \
	+acc=npr \
	+cover \
	-coverage \
	-f ../sim/user_files/filelist.f \
	-top $(TOP) \
	-l $(TEST).log \
	+UVM_TESTNAME=$(TEST) \
	+define+RANDOM_RUN_COUNT=$(COUNT)

#@rm -rf {*,.[!.]*,..?*}
run_%: $(DIR)/regression.list
	@echo -n "Running test: $* ... "
	@cd $(DIR)/.. && \
	export ALUVM_HOME=$(ALUVM_DIR) && \
	mkdir -p run && \
	cd run && \
	echo -n "Running test: $* ... " >> regress.summary && \
	mkdir -p $* && \
	cd $* && \
	qrun \
	-64 \
	-sv \
	-timescale 1ns/1ps \
	-mfcu \
	-incr \
	-sv_seed random \
	+acc=npr \
	+cover \
	-coverage \
	-f ../../sim/user_files/filelist.f \
	-top $(TOP) \
	+UVM_TESTNAME=$* \
	+define+RANDOM_RUN_COUNT=$(COUNT) > $*.log
	@ERR_CNT=$$(grep -c "UVM_ERROR" $(DIR)/../run/$*/$*.log); \
	if (($$ERR_CNT >= 2)); then \
		echo "ERROR" | tee -a $(DIR)/../run/regress.summary; \
	else \
		echo "done" | tee -a $(DIR)/../run/regress.summary; \
	fi

regress: $(REG_TARGETS)
	find $(DIR)/../run -type f -name "*.ucdb" -print0 | xargs -0 vcover merge -out $(DIR)/../run/regress_cov.ucdb
	@echo ""
	@echo "########## REGRESSION COMPLETE ##########"
	@echo "Passed: $$(grep -c "\bdone\b" $(DIR)/../run/regress.summary)"
	@echo "Failed: $$(grep -c "\bERROR\b" $(DIR)/../run/regress.summary)"
	@echo "#########################################"
	@echo ""

cover:
	cd $(DIR)/../run && \
	vcover report -details -all *.ucdb > covers.rpt

clean:
	cd $(DIR) && [ -d "../run" ] && rm -rf ../run

.PHONY: all cover clean regress