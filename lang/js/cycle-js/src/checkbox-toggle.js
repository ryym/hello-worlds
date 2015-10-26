import Cycle from '@cycle/core';
import {makeDOMDriver, h} from '@cycle/dom';

function main(drivers) {
  return {
    DOM: drivers.DOM.select('input').events('click')
      .map(ev => ev.target.checked)
      .startWith(false)
      .map(toggled =>
          h('div', [
            h('h1', 'Checkbox Example'),
            h('input', {type: 'checkbox'}), 'Toggle me',
            h('p', toggled ? 'ON' : 'off')
          ])
      )
  };
}

export default function run() {
  Cycle.run(main, { DOM: makeDOMDriver('#checkboxToggle') });
}
