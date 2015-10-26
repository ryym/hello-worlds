import Rx from 'rx';
import Cycle from '@cycle/core';
import {h, makeDOMDriver} from '@cycle/dom';

function main({ DOM }) {
  // Note: '$' represents Observable or Stream

  let action$ = Rx.Observable.merge(
    DOM.select('.decrement').events('click').map(ev => -1),
    DOM.select('.increment').events('click').map(ev => +1)
  );

  // `scan` function accumulates values like `reduce`.
  let count$ = action$.startWith(0).scan( (x, y) => x + y );

  return {
    DOM: count$.map(count => {
      return h('div', [
        h('h1.title', 'Counter Example'),
        h('button.decrement', 'Decrement'),
        h('button.increment', 'Increment'),
        h('p', 'Counter: ' + count)
      ])
    })
  };
}

export default function run() {
  Cycle.run(main, {
    DOM: makeDOMDriver('#counter')
  });
}
