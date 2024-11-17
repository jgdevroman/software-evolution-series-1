module Main

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
import Test;


void main() {
    loc projectPathSmallSql = |cwd:///smallsql0.21_src|;
    loc projectPathHsql = |cwd:///hsqldb-2.3.1|;
    loc testLocation = |cwd:///Tests///Complexity|;

    set[loc] smallsqlAST = find(projectPathSmallSql, "java");
    set[loc] hsqldbAST = find(projectPathHsql, "java");
    set[loc] testloc = find(testLocation, "java");
    
    TestComplexity();

    //getUnitSize(projectPathSmallSql);
    //getUnitSize(projectPathSmallSql);
    // smallSqlVolume = getVolume(smallsqlAST);
    // hsqlVolume = getVolume(hsqldbAST);
    //getComplexity(projectPathSmallSql);
    //TestComplexity();
    // println("Volume smallSql: <smallSqlVolume>");
    // println("Volume hsql: <hsqlVolume>");
}
