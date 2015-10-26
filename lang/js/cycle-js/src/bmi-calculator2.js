/* BMI Calculator example using Custom Elements */

/*
 * Custom elements is a way of encapsulating looks and behavior together
 * to reuse them seamlessly.
 * In custom elements, properties are passed as observables.
 */

import Rx from 'rx';
import Cycle from '@cycle/core';
import {h, makeDOMDriver} from '@cycle/dom';

/**
 * Labeled slider element
 */
function labeledSlider({props, DOM}) {
  function intent(DOM) {
    return {
      changeValue$: DOM.select('.slider').events('input')
        .map(ev => ev.target.value)
    };
  }

  function model(props, actions) {
    let initialValue$ = props.get('initial').first();
    let value$ = initialValue$.concat(actions.changeValue$);
    let props$ = props.getAll();
    return Rx.Observable.combineLatest(props$, value$,
      (props, value) => { return {props, value}; }
    );
  }

  function view(state$) {
    return state$.map(state => {
      let { children, unit, min, max } = state.props;
      let value = state.value;
      return h('div.labeled-slider', [
        h('div.label',
          // props.children is an array with all
          // the VTree objects passed into this
          // custom elements.
          children.concat(value + unit)
        ),
        h('input.slider',
          {type: 'range', min, max, value}
        )
      ])
    });
  }

  let actions = intent(DOM);
  let vtree$  = view( model(props, actions) );
  return {
    DOM: vtree$,
    events: {
      newValue: actions.changeValue$
    }
  };
}

function calculateBMI(weight, height) {
  let heightMeters = height * 0.01;
  return Math.round( weight / (heightMeters * heightMeters) );
}

function intent(DOM) {
  // Custom elements emit custom DOM events as a 'detail' property.
  return {
    changeWeight$: DOM.select('#weight').events('newValue')
      .map(ev => ev.detail),
    changeHeight$: DOM.select('#height').events('newValue')
      .map(ev => ev.detail),
  };
}

function model(actions) {
  return Rx.Observable.combineLatest(
    actions.changeWeight$.startWith(70),
    actions.changeHeight$.startWith(170),
    (weight, height) => {
      return { weight, height, bmi: calculateBMI(weight, height) };
    }
  );
}

function view(state$) {
  return state$.map(({ weight, height, bmi }) => {
    // We usually should provide a 'key' property as an identifier
    // when we render a custom element.
    return h('div', [
      h('h1', 'BMI Calulator Example 2'),

      h('labeled-slider#weight', {
        key     : 1,
        unit    : 'kg',
        initial : weight,
        min     : 40,
        max     : 140
      }, [
        h('h2', 'Weight')
      ]),

      h('labeled-slider#height', {
        key     : 2,
        unit    : 'cm',
        initial : height,
        min     : 140,
        max     : 210
      }, [
        h('h4', 'Height')
      ]),

      h('h2', 'BMI is ' + bmi)
    ])
  });
}

/**
 * Main function.
 */
function main({ DOM }) {
  return { DOM: view(model( intent(DOM) )) };
}

export default function() {
  Cycle.run(main, {
    DOM: makeDOMDriver('#bmiCalculator2', {
      'labeled-slider': labeledSlider
    })
  });
}
