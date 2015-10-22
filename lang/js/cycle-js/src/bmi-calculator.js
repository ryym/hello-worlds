import Rx from 'rx';
import Cycle from '@cycle/core';
import {h, makeDOMDriver} from '@cycle/dom';

function calculateBMI(weight, height) {
  let heightMeters = height * 0.01;
  return Math.round( weight / (heightMeters * heightMeters) );
}

/**
 * Interpret DOM events as user's intended actions.
 * @param  DOM DOM Driver responses
 * @return Action observables
 */
function intent(DOM) {
  return {
    changeWeight$: DOM.select('#weight').events('input')
      .map(ev => ev.target.value),

    changeHeight$: DOM.select('#height').events('input')
      .map(ev => ev.target.value)
  };
}

/**
 * Manage state.
 * @param  Action observables
 * @return `state$` observable
 */
function model(actions) {
  // `combineLatest` has 'AND' semantics on the other hand `merge` has 'OR' semantics.
  return Rx.Observable.combineLatest(
    actions.changeWeight$.startWith(70),
    actions.changeHeight$.startWith(170),
    (weight, height) => {
      return { weight, height, bmi: calculateBMI(weight, height) };
    }
  );
}

/**
 * Visually represent state from the Model.
 * @param  `state$` observable
 * @return Observable of VTree as the DOM Driver request
 */
function view(state$) {
  return state$.map(({ weight, height, bmi }) => {
    return h('div', [
        h('h1', 'BMI Calculator'),
        renderWeightSlider(weight),
        renderHeightSlider(height),
        h('h2', 'BMI is ' + bmi)
    ]);
  });
}

function renderWeightSlider(weight) {
  return h('div', [
      `Weight ${weight}kg`,
      h('input#weight', {
        type  : 'range',
        value : weight,
        min   : 40,
        max   : 140
      })
  ]);
}

function renderHeightSlider(height) {
  return h('div', [
      `Height ${height}cm`,
      h('input#height', {
        type  : 'range',
        value : height,
        min   : 140,
        max   : 210
      })
  ]);
}

function main({ DOM }) {
  return { DOM: view(model( intent(DOM) )) };
}

export default function() {
  Cycle.run(main, {
    DOM: makeDOMDriver('#bmiCalculator')
  });
}
