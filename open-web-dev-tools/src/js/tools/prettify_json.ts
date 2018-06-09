import {
    constructStrToStrTransform,
} from "../open-web-dev-tools--base";

export const trans = constructStrToStrTransform((s) => JSON.stringify(JSON.parse(s), null, 4));
