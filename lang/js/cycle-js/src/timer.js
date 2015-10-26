import Rx from 'rx';
import Cycle from '@cycle/core';
import {makeDOMDriver, h} from '@cycle/dom';

function main() {
  return {
    DOM: Rx.Observable.interval(1000)
      .startWith('_')
      .map(i => h(
        'h3', '' + i + ' seconds elapsed'
      ))
  };
}

export default function run() {
  Cycle.run(main, { DOM: makeDOMDriver('#timer') });
}
