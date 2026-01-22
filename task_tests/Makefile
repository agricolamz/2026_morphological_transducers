.DEFAULT_GOAL: requirements

.PHONY: requirements forms clean

requirements:
	@curl -s https://apertium.projectjj.com/apt/install-nightly.sh | sudo bash
	sudo apt-get install hfst lexd

task.generator.hfst: task.lexd
	@lexd task.lexd | hfst-txt2fst -o lexd.hfst
	@if [ ! -f task.twol ]; then\
		mv lexd.hfst $@;\
	else\
		hfst-twolc -q task.twol -o twol.hfst;\
		hfst-compose-intersect lexd.hfst twol.hfst -o $@;\
	fi

task.analyzer.hfst: task.generator.hfst
	@hfst-invert $^ -o $@

analysis: task.analyzer.hfst
	@echo "$(FORM)" | hfst-lookup $^
	@rm -f *.hfst

generation: task.generator.hfst
	@echo "$(FORM)" | hfst-lookup $^
	@rm -f *.hfst

for_test_%.txt:
	@curl -s https://raw.githubusercontent.com/agricolamz/2025_morphological_transducers/refs/heads/main/task_tests/$@ -o $@

forms: task.generator.hfst
	@hfst-fst2strings $^
	@rm -f *.hfst

clean: 
	@rm -f *.hfst *.txt

test_%: for_test_%.txt task.generator.hfst
	@hfst-fst2strings task.generator.hfst > generated_forms.txt
	@$(eval N_over_wrong=`grep -xvf $< generated_forms.txt | wc -l`)
	@if [ "$(N_over_wrong)" != "0" ]; then\
		echo "Overgeneration or wrong generation:\n" > test_results.txt;\
		grep -xvf $< generated_forms.txt >> test_results.txt;\
	fi
	@$(eval N_not_generated=`grep -xvf generated_forms.txt $<  | wc -l`)
	@if [ "$(N_not_generated)" != "0" ]; then\
		echo "\nNot generated:\n" >> test_results.txt;\
		grep -xvf generated_forms.txt $< >> test_results.txt;\
	fi
	@if [ ! -f test_results.txt ]; then\
		echo "\e[32mAll tests for the task have passed.\e[0m";\
	else\
		echo "\e[31mIt looks like your lexd/twol files failed one of the tests.\n\e[0m";\
		cat test_results.txt;\
	fi
	@rm -f *.hfst *.txt
