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
};
