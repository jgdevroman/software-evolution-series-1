Complexitypublic class TestSample {

    public void testIf() {
        if (true) { // +1
            System.out.println("This is an if statement");
        }
    }

    public void testIfElse() {
        if (true) { // +1
            System.out.println("This is an if-else statement");
        } else {
            System.out.println("Else branch");
        }
    }

    public void testSwitchCase() {
        int x = 1;
        switch (x) {
            case 1: // +1
                System.out.println("Case 1");
                break;
            default:
                System.out.println("Default case");
        }
    }

    public void testDoWhile() {
        int i = 0;
        do { // +1
            System.out.println("Do-while loop");
            i++;
        } while (i < 1);
    }

    public void testWhile() {
        int i = 0;
        while (i < 1) { // +1
            System.out.println("While loop");
            i++;
        }
    }

    public void testForLoop() {
        for (int i = 0; i < 1; i++) { // +1
            System.out.println("For loop");
        }
    }

    public void testForLoopWithMultipleVariables() {
        for (int i = 0, j = 0; i < 1; i++, j++) { // +1
            System.out.println("For loop with multiple variables");
        }
    }

    public void testForEachLoop() {
        int[] numbers = {1};
        for (int number : numbers) { // +1
            System.out.println("For-each loop");
        }
    }

    public void testTryCatch() {
        try {
            throw new Exception("Test exception");
        } catch (Exception e) { // +1
            System.out.println("Catch block");
        }
    }

    public void testTernaryOperator() {
        int result = (true) ? 1 : 0; // +1
        System.out.println("Ternary operator result: " + result);
    }

    public void testLogicalAnd() {
        if (true && false) { // +1
            System.out.println("Logical AND");
        }
    }

    public void testLogicalOr() {
        if (true || false) { // +1
            System.out.println("Logical OR");
        }
    }
}
