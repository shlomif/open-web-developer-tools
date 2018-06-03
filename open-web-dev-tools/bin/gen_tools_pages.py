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


class Page:
    """docstring for Page"""
    def __init__(self, params):
        self.params = params

    def generate(self):
        params = self.params
        basename = params['basename']
        dir_ = 'dest/tools'
        d = dir_ + '/' + basename
        os.mkdir(d)
        path = d + '/index.xhtml'
        root_path = '../..'
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
<script type="text/javascript" src="%(root_path)s/js/main_all.js"></script>
</head>
<body>
<h1>Hello</h1>
</body>
</html>''' % {
              'root_path': root_path,
              'title': params['title'],
             })


PARAMS = [
          {
            'basename': 'uppercase',
            'title': 'Convert to uppercase',
          }
         ]


def main():
    for params in PARAMS:
        Page(params).generate()


main()