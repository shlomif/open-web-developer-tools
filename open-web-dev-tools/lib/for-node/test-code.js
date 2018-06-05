var requirejs = require('requirejs');

requirejs.config({
    //Pass the top-level main.js/index.js require
    //function to requirejs so that node modules
    //are loaded relative to the top-level JS file.
    nodeRequire: require
});

{
    let tests_mod = require('tools-tests-1');
    tests_mod.test_tools_1();
}
