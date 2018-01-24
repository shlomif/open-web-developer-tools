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
