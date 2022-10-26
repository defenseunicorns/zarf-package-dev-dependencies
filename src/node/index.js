#!/usr/bin/env node

var _ = require('lodash');
var { VError } = require('@netflix/nerror');

var hello = _.camelCase("HELLO world");
var err = new VError('hello error! "%s"', 'le error');

console.log(hello);
console.log(err.message);
