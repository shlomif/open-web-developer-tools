import {
    Input,
} from "./open-web-dev-tools--base";

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

    QUnit.test("test the input class", function(a : Assert) {
        a.expect(1);

        {
            const inp = new Input({str: "Hello"});
            // TEST
            a.equal(inp.getString(), "Hello", "getString()");
        }

    });
}
