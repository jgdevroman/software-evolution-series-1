module UnitComplexity

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;
import Volume;
import Utility;

//bug solution from stackoverflow
//https://stackoverflow.com/questions/73873370/issue-reading-file-io-unsupported-scheme-javacompilationunit
loc sourceFile(loc logical, M3 model) {
    if (loc f <- model.declarations[logical]) {
    return f;
  }
  
  throw FileNotFound(logical);
}

tuple[real,real,real,real] calculateComplexity(set[loc] projectFiles) {

    list[int] perUnitCount = []; 
    list[tuple[int, int]] ccLocList = [];
    int totalLOC = 0;

    for(f <- projectFiles){
        tuple[list[tuple[int, int]], int] result = getComplexity(f);
        ccLocList += result[0];

        perUnitCount += result[1];
        totalLOC += result[1];
    }

    //from paper
    list[real] risks = getRisks(ccLocList, [10, 20, 50]);

    list[str] labels = ["Simple", "More complex", "Complex", "Untestable"];
    
    println("\nCalculated Risks:");
    for (int i <- [0 .. size(risks)]) {
        println("<labels[i]> Risk: <risks[i]>");
    }

    // Print the total LOC
    
    println("\nRisk Percentages:");
    tuple[real, real, real, real] percentages = <0.0, 0.0, 0.0 ,0.0>;
    for (int i <- [0 .. size(risks)]) {
        real percentage = (risks[i] / totalLOC) * 100;
        percentages[i] = percentage;
        println("<labels[i]>: <percentage>%");
    }

    return percentages;
}

tuple[list[tuple[int, int]], int] getComplexity(file) {
    myModel = createM3FromFile(file);
    fileAST  = createAstFromFile(file, true);

    set[loc] myMethods = methods(myModel);
    // List to store tuples of (LOC, CC)
    list[tuple[int, int]] ccLocList = [];
    
    int totalLOC = 0;

    for (m <- myMethods) {
        methodAST = {d | /Declaration d := fileAST, d.decl == m};
           
        int cc = calcCC(methodAST);
        loc source = sourceFile(m, myModel);
        code = readFile(source);
        
        int count = getLineCount(code);
        totalLOC += count;

        ccLocList += <cc, count>;
    }

    return <ccLocList, totalLOC>;
}

// This function is from "Empirical analysis of the relationship between CC and SLOC
// in a large corpus of Java methods and C functions"
// doi:10.1002/smr.1760 
int calcCC(set[Declaration] ast) {
    int result = 1;

    visit (ast) {
        case \if(_,_) : result += 1;
        case \if(_,_,_) : result += 1;
        case \case(_) : result += 1;
        case \do(_,_) : result += 1;
        case \while(_,_) : result += 1;
        case \for(_,_,_) : result += 1;
        case \for(_,_,_,_) : result += 1;
        case \foreach(_,_,_) : result += 1;
        case \catch(_,_): result += 1;
        case \conditional(_,_,_): result += 1;
        case \infix(_,"&&",_) : result += 1;
        case \infix(_,"||",_) : result += 1;
    }
    
    return result;
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