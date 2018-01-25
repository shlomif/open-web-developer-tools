import {
    BaseTransform,
    BaseTransformArgs,
    Input,
    Output,
    constructStrToStrTransform,
} from "./open-web-dev-tools--base";

class UpperCaseTrans extends BaseTransform {
    public transform(args: BaseTransformArgs): Output {
        return new Output({str: args.input.getString().toUpperCase()});
    }
};
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
        a.expect(3);

        {
            const inp = new Input({str: "Hello"});
            // TEST
            a.equal(inp.getString(), "Hello", "getString()");
        }

        {
            const inp = new Input({str: "24"});
            // TEST
            a.equal(inp.getDecimalInt()*1, 24, "getDecimalInt()");
        }

        {
            const inp = new Input({str: "500"});
            // TEST
            a.equal(10 + inp.getDecimalInt() * 3, 1510, "getDecimalInt()");
        }

    });

    QUnit.test("test the output class", function(a : Assert) {
        a.expect(1);

        {
            const outp = new Output({str: "Hello"});
            // TEST
            a.equal(outp.getString(), "Hello", "getString()");
        }

    });
    QUnit.test("test the transform class", function(a : Assert) {
        a.expect(1);

        {
            const outp = (new UpperCaseTrans()).transform({input: new Input({str: "Hello"})});
            // TEST
            a.equal(outp.getString(), "HELLO", "getString()");
        }

    });
}
    QUnit.test("test the constructStrToStrTransform", function(a : Assert) {
        a.expect(1);

        {
            const t = constructStrToStrTransform((s) => s.toLowerCase());
            const outp = t.transform({input: new Input({str: "Test"})});
            // TEST
            a.equal(outp.getString(), "test", "getString()");
        }

    });
