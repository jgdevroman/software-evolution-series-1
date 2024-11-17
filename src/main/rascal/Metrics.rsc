module Metrics

import IO;
import List;
import Set;
import String;
import Map;
import Node;

// map[str, str] score = (
//     "VERY_GOOD": "++",
//     "GOOD": "+",
//     "SUFFICIENT": "o",
//     "LOW": "-",
//     "VERY_LOW": "--"
// );

tuple[str VERY_GOOD, str GOOD, str SUFFICIENT, str LOW, str VERY_LOW] score = <"++", "+", "o", "-", "--">;

tuple[str,str] calcVolumeMetric(int volume) {
    if (volume <= 66000) {
        return <score.VERY_GOOD , "0 - 8">;
    }
    if (volume <= 246000) {
        return <score.GOOD, "8 - 30">;
    }
    if (volume <= 665000) {
        return <score.SUFFICIENT, "30 - 80">; 
    }
    if (volume <= 1310000) {
        return <score.LOW, "80 - 160">;
    }
    return <score.VERY_LOW, "\> 160">;
}

str calcDuplicationMetric(real percentage) { 
    if(percentage <= 0.03){
        return score.VERY_GOOD;
    }
    if(percentage <= 0.05) {
        return score.GOOD;
    }
    if(percentage <= 0.1) {
        return score.SUFFICIENT;
    }
    if(percentage <= 0.2) {
        return score.LOW;
    }
    return score.VERY_LOW;
}

str calcComplexityReport(real moderateRisk, real highRisk, real veryHighRisk){
    if (moderateRisk <= 0.25 && highRisk <= 0 && veryHighRisk <= 0) {
        return score.VERY_GOOD;
    }
    if (moderateRisk <= 0.3 && highRisk <= 0.05 && veryHighRisk <= 0) {
        return score.GOOD;
    }
    if (moderateRisk <= 0.4 && highRisk <= 0.1 && veryHighRisk <= 0) {
        return score.SUFFICIENT;
    }
    if (moderateRisk <= 0.5 && highRisk <= 0.15 && veryHighRisk <= 0.05) {
        return score.LOW;
    }
    return score.VERY_LOW;
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