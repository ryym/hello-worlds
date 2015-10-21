import Rx from 'rx';
import Cycle from '@cycle/core';
import {h, makeDOMDriver} from '@cycle/dom';


function main({ DOM }) {
  function calcBmi(weight, height) {
    let heightMeters = height * 0.01;
    return Math.round( weight / (heightMeters * heightMeters) );
  }

  let changeWeight$ = DOM.select('#weight').events('input')
    .map(ev => ev.target.value);

  let changeHeight$ = DOM.select('#height').events('input')
    .map(ev => ev.target.value);

  // `combineLatest` has 'AND' semantics on the other hand `merge` has 'OR' semantics.
  let state$ = Rx.Observable.combineLatest(
    changeWeight$.startWith(70),
    changeHeight$.startWith(170),
    (weight, height) => {
      let bmi = calcBmi(weight, height);
      return { weight, height, bmi };
    }
  );

  let vtree$ = state$.map(({ weight, height, bmi }) => {
    return h('div', [
      h('h1', 'BMI Calculator'),

      h('div', [
        `Weight ${weight}kg`,
        h('input#weight', {
          type  : 'range',
          value : weight,
          min   : 40,
          max   : 140
        })
      ]),

      h('div', [
        `Height ${height}cm`,
        h('input#height', {
          type  : 'range',
          value : height,
          min   : 140,
          max   : 210
        })
      ]),

      h('h2', 'BMI is ' + bmi)
    ]);
  });

  return { DOM: vtree$ };
}

export default function() {
  Cycle.run(main, {
    DOM: makeDOMDriver('#bmiCalculator')
  });
}
