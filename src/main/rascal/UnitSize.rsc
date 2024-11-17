module UnitSize

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


void getUnitSize(loc projectLocation) {
    M3 model = createM3FromMavenProject(projectLocation);
    set[loc] methods = methods(model);
    
    list[int] perUnitCount = []; 

    for (m <- methods) {
        println(m);
        code = readFile(m);
        perUnitCount += getLineCount(code);     
    }

    // Calculate the risk of Unit Size 
    // The tresholds are based on the SIG/TÜVIT EVALUATION CRITERIA TRUSTED PRODUCT MAINTAINABILITY: GUIDANCE FOR PRODUCERS
    // https://www.softwareimprovementgroup.com/wp-content/uploads/SIG-TUViT-Evaluation-Criteria-Trusted-Product-Maintainability-Guidance-for-producers.pdf
    list[real] risks = getRisks(perUnitCount, [15, 30, 60]); 
    
    list[str] labels = ["Simple", "More complex", "Complex", "Untestable"];

    int total = sum(perUnitCount);

    for (int i <- [0..size(risks)]) {
        println("<labels[i]>: <risks[i]>");
    }

    for (int i <- [0..size(risks)]) {
        real percentage = (risks[i] / total) * 100;
        println("<labels[i]>: <percentage>%");
    }
  
    // Determine complexity rating using risks for Moderate, Complex, and Untestable categories
    str complexityRating = determineComplexityRating(risks[1], risks[2], risks[3]);
    println("Complexity rating: <complexityRating>");
}