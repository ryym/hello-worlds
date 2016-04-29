'use strict';

// for文を使ってひし形を作る
// http://www.2dgod.com/entry/2016/04/29/101000

/**
 * @example
 * printDiamond(3, 2);
 * >  *
 * > ***
 * >*****
 * > ***
 * >  *
 */
function printDiamond(halfHeight, step) {
  const widths = [];
  for (let i = 0; i < halfHeight; i++) {
    widths.push(1 + step * i);
  }
  _printDiamond(widths);
}

function _printDiamond(topHalfWidths) {
  const length   = topHalfWidths.length;
  const height   = length * 2 - 1;
  const maxStars = topHalfWidths[length - 1];

  for (let i = 0; i < height; i++) {
    const idx    = (i < length) ? i : height - i - 1;
    const nStars = topHalfWidths[idx];
    const stars  = makeLine(nStars, maxStars);
    console.log(stars);
  }
}

function makeLine(nStars, maxStars) {
  const nPads = (maxStars - nStars) / 2;
  const pads  = ' '.repeat(nPads);
  const stars = '*'.repeat(nStars);
  return pads.concat(stars);
}

printDiamond(3, 2)
