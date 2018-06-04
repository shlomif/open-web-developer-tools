import {
    constructStrToStrTransform,
} from "../open-web-dev-tools--base";

export = {trans: constructStrToStrTransform((s) => s.toUpperCase())};
