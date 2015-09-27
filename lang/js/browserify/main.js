// browserify main.js -o bundle.js
var unique = require('unique');

var data = [1,1,1,2,2,2,3,4,4,5,5,6];

console.log(unique(data));
