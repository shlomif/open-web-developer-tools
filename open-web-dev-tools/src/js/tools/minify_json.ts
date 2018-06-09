import {
    constructStrToStrTransform,
} from "../open-web-dev-tools--base";

import jsonminify = require("jsonminify");

export const trans = constructStrToStrTransform((s) => jsonminify(s));
