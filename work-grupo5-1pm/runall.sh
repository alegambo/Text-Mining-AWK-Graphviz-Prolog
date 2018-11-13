gawk -v RS="\r\n\r\n" -v FS="\r\n" -f src/compose.awk study_plan_input/study_plan.txt > compose_output/composed_plan.txt
echo "*** compose generado ***"
awk -v RS="\r\n" -v FS="::" -f src/genprolog.awk compose_output/composed_plan.txt > prolog_output/study_plan.pl
echo "*** prolog generado ***"
awk -v RS="\r\n\r\n" -v FS="\r\n" -f "src/gengraph.awk"  "study_plan_input/study_plan.txt"  | dot -Tpng -o "gv_output/grafico_plan.png"
echo "*** graphviz generado *** "