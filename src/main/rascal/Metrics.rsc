module Metrics

import IO;
import List;
import Set;
import String;
import Map;
import Node;


tuple[str,str] calcVolumeMetric(int volume) {
    if (volume <= 66000) {
        return <"++", "0 - 8">;
    }
    if (volume <= 246000) {
        return <"+", "8 - 30">;
    }
    if (volume <= 665000) {
        return <"o", "30 - 80">; 
    }
    if (volume <= 1310000) {
        return <"-", "80 - 160">;
    }
    return <"--", "\> 160">;
}

str calcDuplicationMetric(real percentage) { 
    if(percentage <= 0.03){
        return "++";
    }
    if(percentage <= 0.05) {
        return "+";
    }
    if(percentage <= 0.1) {
        return "o";
    }
    if(percentage <= 0.2) {
        return "-";
    }
    return "--";
}

str duplicationReport(real duplication) {
    duplicationScore = calcDuplicationMetric(duplication);
    str duplicationReport = 
"========== Duplication ==========

Duplication percentage: <duplication> 

Duplication Score: <duplicationScore>

";

    return duplicationReport;
}

str volumeReport(int volume) {
    tuple[str score, str manYears] volumeScore = calcVolumeMetric(volume);
    str volumeReport = 
"==========  Volume ========== 
Volume: <volume> 
    
Volume Man Years: <volumeScore.manYears>
    
Volume Score: <volumeScore.score>

";

    return volumeReport; 

}

void printMetricsReport(int volume, real duplication, str name) {
    header = 
        "----------------------------------------------------------------\n" +
        "  <name> Maintainability Score Report \n" + 
        "----------------------------------------------------------------\n";

    println(header + volumeReport(volume) + duplicationReport(duplication));
}