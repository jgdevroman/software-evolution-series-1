module Utility

import lang::java::m3::Core;
import lang::java::m3::AST;

import List;
import IO;
import Set;
import String;

list[Declaration] getASTs(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    list[Declaration] asts = [createAstFromFile(f, true)
        | f <- files(model.containment), isCompilationUnit(f)];
    return asts;
}

list[str] getLines(loc projectLocation) {
   list[str] lines = []; 
   M3 model = createM3FromMavenProject(projectLocation); 
   for (f <- files(model.containment), isCompilationUnit(f)) {
        lines += filterRedundantLines(readFileLines(f));
   }

   return lines;
}

bool isRedundantLine(str line) {
  // Check if comma
  if(endsWith(line, "*/") || startsWith(line, "/*") || startsWith(line, "*")) {
     return true; 
  }
  // Check if whitespace
  if( /^\s*$/ := line) {
    return true;
  }
  return false;
}

list[str] filterRedundantLines(list[str] src) {
    list[str] newLines = [];
    for(line <- src) {
        if (isRedundantLine(line)) {
            continue;
        }
        newLines += trim(line);
    }
    return newLines;
}

list[real] getRisks(list[tuple[int, int]] ccLocTuples, list[int] thresholds){
    list[real] riskList = [0.0, 0.0, 0.0, 0.0];

    for(tuple[int, int] ccLocTuple <- ccLocTuples){
        int cc = ccLocTuple[0];
        int LOC = ccLocTuple[1];

        if (cc <= thresholds[0]){
            riskList[0] += LOC; // Simple
        } else if (cc <= thresholds[1]){
            riskList[1] +=LOC; // Moderate
        } else if (cc <= thresholds[2]){
            riskList[2] += LOC; // Complex
        } else {
            riskList[3] += LOC; // Untestable
        }
    }

    return riskList;
}

list[real] getRisks(list[int] lines, list[int] thresholds) {
    list[real] riskList = [0.0, 0.0, 0.0, 0.0];

    for (int line <- lines) {
        if (line <= thresholds[0]) {
            riskList[0] += line; // Simple
        } else if (line <= thresholds[1]) {
            riskList[1] += line; // Moderate
        } else if (line <= thresholds[2]) {
            riskList[2] += line; // Complex
        } else {
            riskList[3] += line; // Untestable
        }
    }
    return riskList;
}

str determineComplexityRating(real moderate, real high, real veryHigh) {
    list[real] moderateThresholds = [25.0, 30.0, 40.0, 50.0];
    list[real] highThresholds = [0.0, 5.0, 10.0, 15.0];
    list[real] veryHighThresholds = [0.0, 0.0, 0.0, 5.0];

    if (moderate <= moderateThresholds[0] && high <= highThresholds[0] && veryHigh <= veryHighThresholds[0]) {
        return "++";
    } else if (moderate <= moderateThresholds[1] && high <= highThresholds[1] && veryHigh <= veryHighThresholds[1]) {
        return "+";
    } else if (moderate <= moderateThresholds[2] && high <= highThresholds[2] && veryHigh <= veryHighThresholds[2]) {
        return "o";
    } else if (moderate <= moderateThresholds[3] && high <= highThresholds[3] && veryHigh <= veryHighThresholds[3]) {
        return "-";
    } else {
        return "--";
    }
}
