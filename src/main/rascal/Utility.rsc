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
        lines += readFileLines(f);
   }

   return mapper(lines, trim);
}

// Duplication: Fix the list by trimming, removing comments and white space lines
list[str] fixList (list [str] l){
    list [str] newList = [];

    for(s <- l) {
        str ss = trim(s);

        if(isComment(ss) || isWhitespaceLine(ss)) {
            continue;
        }
        else {
            newList += ss;
        }
    };

    return newList;
}


bool isComment(str line) {
  if(endsWith(line, "*/")) { return true; }
  if(startsWith(line, "/*")) { return true; }
  if(startsWith(line, "*") && !startsWith(line, "*/")) { return true; }
  return /\/\// := line || /\/\*.*\*\// := line;
}

bool isWhitespaceLine(str line) {
  return /^\s*$/ := line;
}
