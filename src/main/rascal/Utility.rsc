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
    // Check if comment
    trimmedLine = trim(line);     
    if(endsWith(trimmedLine, "*/") || startsWith(trimmedLine, "/*") || startsWith(trimmedLine, "*") || startsWith(trimmedLine, "//")) {
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
