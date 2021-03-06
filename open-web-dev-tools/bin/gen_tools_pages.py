#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 Shlomi Fish <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""

import os
import os.path


class Page:
    """docstring for Page"""
    def __init__(self, params):
        self.params = params

    def generate(self):
        params = self.params
        basename = params['basename']
        dir_ = 'dest/tools'
        d = dir_ + '/' + basename
        if not os.path.exists(d):
            os.mkdir(d)
        path = d + '/index.xhtml'
        root_path = '../..'
        id_base = params['id_base']
        inp_id = id_base + '_input'
        outp_id = id_base + '_output'

        with open(path, 'wt') as f:
            f.write('''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>%(title)s</title>
<meta charset="utf-8"/>
<meta content="Shlomi Fish" name="author"/>
<meta content="Web Dev Tool" name="description"/>
<meta content="fill in" name="keywords"/>
<link href="%(root_path)s/style.css" rel="stylesheet" type="text/css"
title="Normal" media="screen"/>
<link href="%(root_path)s/print.css" rel="stylesheet" type="text/css"
media="print"/>
<link href="%(root_path)s/favicon.ico" rel="shortcut icon"
type="image/x-icon"/>
<script src="%(root_path)s/js/jq.js"></script>
<script src="%(root_path)s/js/require--debug.js"/>
</head>
<body>
<h1>%(title)s</h1>
<label for="%(inp_id)s">Input:</label><br/>
<textarea id="%(inp_id)s" class="input"
cols="80" rows="10"></textarea><br/>
<button id="%(id_base)s_perform" class="perform">Run</button><br/>
<label for="%(outp_id)s">Output:</label><br/>
<textarea id="%(outp_id)s" class="output" readonly="readonly"
cols="80" rows="10"></textarea><br/>
<script>
requirejs.config({
     baseUrl: '%(root_path)s/js',
     });
require(["open-web-dev-tools--base", "tools/%(id_base)s",], (base, trans) => {
    const id_base = '%(id_base)s';
    const button_id = id_base + '_perform';
    $("#" + button_id).on('click', function() {
        const ctl = $("#" + id_base + '_input');
        const text = ctl.val();
        const outp = trans.trans.transform({
            input: new base.Input({
                str: text
                }
            )
        });
        $("#" + id_base + '_output').val(outp.getString());
    });
});
</script>
</body>
</html>''' % {
              'id_base': id_base,
              'inp_id': inp_id,
              'outp_id': outp_id,
              'root_path': root_path,
              'title': params['title'],
             })


PARAMS = [
          {
            'basename': 'lowercase',
            'id_base': 'lowercase',
            'title': 'Convert to lowercase',
          },
          {
            'basename': 'minify_json',
            'id_base': 'minify_json',
            'title': 'Minify / compress JSON',
          },
          {
            'basename': 'prettify_json',
            'id_base': 'prettify_json',
            'title': 'Pretty-print / prettify JSON',
          },
          {
            'basename': 'uppercase',
            'id_base': 'uppercase',
            'title': 'Convert to uppercase',
          },
         ]


def main():
    for params in PARAMS:
        Page(params).generate()


main()
