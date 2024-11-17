module Duplication

import lang::java::m3::Core;
import lang::java::m3::AST;

import IO;
import List;
import Set;
import String;
import Map;
import Node;

import Utility;

int BLOCK_COUNT = 6;

real getDuplication(loc projectPath) {
    // list[Declaration] asts = getASTs(projectPath);

    list[str] lines = getLines(projectPath);
    int count = getDuplicationCount(lines);

    println(count);
    println(size(lines));

    return (count * 1.0) / (size(lines) * 1.0);   
}

bool isSubset(list[str] leftSide, list[str] rightSide) {
    if (leftSide <= rightSide) {
        return true;
    }
    return false;
}

bool isOverLapping(list[str] leftSide, list[str] rightSide) {
    if (leftSide[1..size(leftSide)] <= rightSide) {
        return true;
    }
    return false;
}

list[list[str]] deleteElement(list[list[str]] src, list[str] el) {
    return delete(src, indexOf(src, el));
}

map[list[str], int] getUniqueDupBlocks(map[list[str], int] duplicatedBlocksWithCount) {
    map[list[str], int] uniqueDupBlocks = ();
    currsize = size(duplicatedBlocksWithCount);
    duplicatedBlocks = [b | b <- duplicatedBlocksWithCount];
    while(size(duplicatedBlocks) > 0) {
        tuple[list[str] head, list[list[str]] tail] blockHeadTail = headTail(duplicatedBlocks);
        leftSide = blockHeadTail.head;
        duplicatedBlocks = blockHeadTail.tail;
        // if there are blocks that overlap with the current head, combine the head with the overlapped block
        for(rightSide <- duplicatedBlocks) {
            if (isSubset(leftSide,rightSide)) {
                leftSide = rightSide;
                duplicatedBlocks = deleteElement(duplicatedBlocks, rightSide);            
            } else if(isSubset(rightSide, leftSide)) {
                duplicatedBlocks = deleteElement(duplicatedBlocks, rightSide);             
            } else if (isOverLapping(leftSide, rightSide)){
                leftSide = leftSide + last(rightSide);
                duplicatedBlocks = deleteElement(duplicatedBlocks, rightSide);
            } else if (isOverLapping(rightSide,leftSide)) {
                leftSide = head(rightSide) + leftSide;
                duplicatedBlocks = deleteElement(duplicatedBlocks, rightSide);
            }
        }
        for (block <- uniqueDupBlocks) {
            if (leftSide < block) {
                // if there are already bocks that are a superset of the block, skip them
                leftSide = block;
            } else if( leftSide > block) {
                // if there are already blocks that are a subset of the current block, delete them from the map
                uniqueDupBlocks = delete(uniqueDupBlocks, block);
            }
        }
        if((leftSide notin uniqueDupBlocks)){
            uniqueDupBlocks += (leftSide: duplicatedBlocksWithCount[blockHeadTail.head]);
        }
    }
    return uniqueDupBlocks;
}

int getDuplicationCount(list[str] lines) {
    // Return no duplication if there are no lines or there are not more than 6 lines
    if (isEmpty(lines) || size(lines) < BLOCK_COUNT) {
        return 0;
    }

    // Make a list of 6 blocks and calculte the distribution
    int length = size(lines) - BLOCK_COUNT;

    list[list[str]] blockList = [];

    for (int startPos <- [0 .. length]) {        
        int endPos = startPos + BLOCK_COUNT;
        list[str] block = lines[startPos .. endPos];
        blockList += [mapper(block, trim)];
    }
    blockDistribution = distribution(blockList);

    // Filter the blocks that occur only once
    map[list[str], int] duplicatedBlocksWithCount = (b : blockDistribution[b] | b <- blockDistribution, blockDistribution[b] > 1);

    // combine blocks that overlap to one unique block
    uniqueDupBlocks = getUniqueDupBlocks(duplicatedBlocksWithCount);

    for (block<- uniqueDupBlocks) {
        if (uniqueDupBlocks[block] * size(block) > 50) {
            println("block: <block>, occurence: <uniqueDupBlocks[block]>, length: <size(block)>");
        }
    }

    // sum all duplicated lines
    lineCounts = [uniqueDupBlocks[block] * size(block) | block <- uniqueDupBlocks];
    println(lineCounts);
    count = sum(lineCounts);
    println(count);

    return count;
}