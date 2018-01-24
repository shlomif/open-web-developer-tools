export function test_tools_1()
{
    QUnit.module("OpenWebDevTools.Tests");

    QUnit.test("test the tests", function(a : Assert) {
        a.expect(1);

        {
            // TEST
            a.equal("string", "string", "sample test");
        }

    });
}
