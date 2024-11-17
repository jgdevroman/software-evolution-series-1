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

void getComplexity(loc file) {
    myModel = createM3FromFile(file);
    fileAST  = createAstFromFile(file, true);

    set[loc] myMethods = methods(myModel);
    
    for (m <- myMethods) { 
        //methodSrc = readFile(m);
        methodAST = {d | /Declaration d := fileAST, d.decl == m};
           
        int cc = calcCC(methodAST);
        println("CC: <cc>");

        loc source = sourceFile(m, myModel);
        code = readFile(source);
        
        int count = getLineCount(code);

        println("<m>");
        println("LOC: <count>");
        println("CC: <cc>");
        

    }

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
