interface InputArgs {
    str: string,
};
export class Input {
    private str: string;
    constructor(args: InputArgs) {
        this.str = args.str;
    }
    public getString() {
        return this.str;
    }
    public getDecimalInt() {
        return parseInt(this.getString());
    }
};
interface OutputArgs {
    str: string,
};
export class Output {
    private str: string;
    constructor(args: OutputArgs) {
        this.str = args.str;
    }
    public getString() {
        return this.str;
    }
};
export interface BaseTransformArgs {
    input: Input,
};
export class BaseTransform {
    public transform(args: BaseTransformArgs): Output {
        throw "ToImpl";
    }
};
class CbTrans extends BaseTransform {
    private cb: (string) => string;

    constructor(cb) {
        super();
        this.cb = cb;
    }

    public transform(args: BaseTransformArgs): Output {
        return new Output({str: this.cb(args.input.getString())});
    }
};

export function constructStrToStrTransform(cb: (string) => string) {
    return new CbTrans(cb);
};
