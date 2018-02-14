@isTest
private class {{testTemplate}} {
    @isTest
    static void testGetValue() {
        {{classTemplate}} template = new {{classTemplate}}();
        System.assertEquals(template.getValue(), '1');
    }
}