module Test

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;
import util::FileSystem;

import Volume;
import Utility;
import UnitSize;
import UnitComplexity;


void TestComplexity(){
    loc testLocation = |cwd:///Tests///Complexity|;
    
    set[loc] testco = find(testLocation, "java");

    for (loc l <- testco){
        println(getComplexity(l));
    }

}
void TestUnitSize(){
    loc testLocation = |cwd:///Tests///UnitSize|;
    
    set[loc] testco = find(testLocation, "java");

    for (loc l <- testco){
        println(getComplexity(l));
    }

}

void main() {
    TestComplexity();
    TestUnitSize();
}