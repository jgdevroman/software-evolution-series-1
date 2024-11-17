module Metrics

import IO;
import List;
import Set;
import String;
import Map;
import Node;

tuple[str VERY_GOOD, str GOOD, str SUFFICIENT, str LOW, str VERY_LOW] score = <"++", "+", "o", "-", "--">;
map[str, int] numericScore = (score.VERY_GOOD: 5, score.GOOD: 4, score.SUFFICIENT: 3, score.LOW: 2, score.VERY_LOW: 1);

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

str calcComplexityScore(real moderate, real high, real veryHigh) {
    list[real] moderateThresholds = [25.0, 30.0, 40.0, 50.0];
    list[real] highThresholds = [0.0, 5.0, 10.0, 15.0];
    list[real] veryHighThresholds = [0.0, 0.0, 0.0, 5.0];

    if (moderate <= moderateThresholds[0] && high <= highThresholds[0] && veryHigh <= veryHighThresholds[0]) {
        return score.VERY_GOOD;
    } else if (moderate <= moderateThresholds[1] && high <= highThresholds[1] && veryHigh <= veryHighThresholds[1]) {
        return score.GOOD;
    } else if (moderate <= moderateThresholds[2] && high <= highThresholds[2] && veryHigh <= veryHighThresholds[2]) {
        return score.SUFFICIENT;
    } else if (moderate <= moderateThresholds[3] && high <= highThresholds[3] && veryHigh <= veryHighThresholds[3]) {
        return score.LOW;
    } else {
        return score.VERY_LOW;
    }
}

tuple[str, str, str, str] calcSourceCodeRatings(str volume, str duplication, str complexity, str unitSize) {
    analysabilityScores = [numericScore[volume], numericScore[duplication], numericScore[unitSize]];
    changeabilityScores = [numericScore[complexity], numericScore[duplication]];
    testabilityScores = [numericScore[complexity], numericScore[unitSize]];

    analysabilityScore = sum(analysabilityScores) / size(analysabilityScores);
    changeabilityScore = sum(changeabilityScores) / size(changeabilityScores);
    testabilityScore = sum(testabilityScores) / size(testabilityScores);

    maintainabilityScores = [analysabilityScore, changeabilityScore, testabilityScore];
    maintainabilityScore = sum(maintainabilityScores) / size(maintainabilityScores);

    return <score[analysabilityScore], score[changeabilityScore], score[testabilityScore], score[maintainabilityScore]>;
}

str duplicationReport(tuple[real,int] duplication, str duplicationScore) {
    str duplicationReport = 
"========== Duplication ==========

Duplicatied Lines: <duplication[1]>
Duplication percentage: <duplication[0]> 

Duplication Score: <duplicationScore>

";

    return duplicationReport;
}

str volumeReport(int volume, tuple[str score, str manYears] volumeScore) {
    str volumeReport = 
"==========  Volume ========== 

Volume: <volume> 
Volume Man Years: <volumeScore.manYears>
    
Volume Score: <volumeScore.score>

";

    return volumeReport; 

}

str complexityReport(tuple[real low, real moderate, real high, real veryHigh] complexity, str complexityScore) {
    str complexityReport = 
"========== Unit Complexity ========== 

Low Risk (simple): <complexity.low> 
Moderate Risk (more complex): <complexity.moderate> 
High Risk (complex): <complexity.high> 
Very High Risk (untestable): <complexity.veryHigh> 
    
Complexity Score: <complexityScore>

";

    return complexityReport;  
}

str unitSizeReport(tuple[real low, real moderate, real high, real veryHigh] complexity, str complexityScore) {
    str complexityReport = 
"==========  Unit Size ========== 

Low Risk (simple): <complexity.low> 
Moderate Risk (more complex): <complexity.moderate> 
High Risk (complex): <complexity.high> 
Very High Risk (untestable): <complexity.veryHigh> 
    
Unit Size Score: <complexityScore>

";

    return complexityReport;  
}

str sourceCodeReport(tuple[str, str, str, str] sourceCodeScores) {
    str report = 
"==========  Source Code Maintainability ========== 

Analysability: <sourceCodeScores[0]>
Changeability: <sourceCodeScores[1]>
Testabillity: <sourceCodeScores[2]>

Overall Maintainability: <sourceCodeScores[3]>

";
    return report;
}

void printMetricsReport(int volume, tuple[real,int] duplication, tuple[real, real, real, real] complexity, tuple[real, real, real, real] unitSize, str name) {
    header = 
        "----------------------------------------------------------------\n" +
        "  <name> Maintainability Metrics Report \n" + 
        "----------------------------------------------------------------\n";

    duplicationScore = calcDuplicationMetric(duplication[0]);
    volumeScore = calcVolumeMetric(volume);
    complexityScore = calcComplexityScore(complexity[1], complexity[2], complexity[3]);
    unitSizeScore = calcComplexityScore(complexity[1], complexity[2], complexity[3]);
    sourceCodeScores = calcSourceCodeRatings(volumeScore[0], duplicationScore, complexityScore, unitSizeScore);

    result = header + volumeReport(volume, volumeScore) + duplicationReport(duplication, duplicationScore) + complexityReport(complexity, complexityScore) + unitSizeReport(unitSize, unitSizeScore) + sourceCodeReport(sourceCodeScores);
    writeFile(|cwd:///analysis_result| + "result_<name>.txt", result);
    println(result);
}