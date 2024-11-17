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
import Duplication;
import Metrics;


void main() {
    loc projectPathSmallSql = |cwd:///smallsql0.21_src|;
    loc projectPathHsql = |cwd:///hsqldb-2.3.1|;
    loc testLocation = |cwd:///Tests///Complexity|;

    set[loc] smallsqlAST = find(projectPathSmallSql, "java");
    set[loc] hsqldbAST = find(projectPathHsql, "java");
    set[loc] testloc = find(testLocation, "java");
    
    // smallSql metrics and report
    smallSqlVolume = getVolume(smallsqlAST);
    smallSqlDuplication = getDuplication(projectPathSmallSql);
    smallSqlUnitSize = getUnitSize(projectPathSmallSql);
    smallSqlComplexity = calculateComplexity(smallsqlAST);
    printMetricsReport(smallSqlVolume, smallSqlDuplication, smallSqlComplexity, smallSqlUnitSize, "smallsql0.21");

    // hsqldb metrics and report
    hsqldbVolume = getVolume(hsqldbAST);
    hsqldbDuplication = getDuplication(projectPathHsql);
    hsqldbUnitSize = getUnitSize(projectPathHsql);
    hsqldbComplexity = calculateComplexity(hsqldbAST);
    printMetricsReport(hsqldbVolume, hsqldbDuplication, hsqldbComplexity, hsqldbUnitSize, "hsqldb-2.3.1");

}
