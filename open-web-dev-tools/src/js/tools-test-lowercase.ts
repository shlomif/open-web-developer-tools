import {
    BaseTransform,
    BaseTransformArgs,
    Input,
    Output,
    constructStrToStrTransform,
} from "./open-web-dev-tools--base";
import { trans} from "./tools/lowercase";

export function test_tools_1()
{
    QUnit.module("OpenWebDevTools.LC.Tests");

    QUnit.test("test the lowercase transform", function(a : Assert) {
        a.expect(1);

        {
            const outp = trans.transform({input: new Input({str: "TeÖstSTRé"})});
            // TEST
            a.equal(outp.getString(), "teöststré", "lowercase.getString()");
        }
    });
}
