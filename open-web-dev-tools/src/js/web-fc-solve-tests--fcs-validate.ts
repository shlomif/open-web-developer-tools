export function test_fcs_validate()
{
    QUnit.module("FC_Solve.Algorithmic");

    QUnit.test("verify_state Card class tests", function(a : Assert) {
        a.expect(1);

        {
            // TEST
            a.equal("one", "one", "sample test");
        }

    });
}
